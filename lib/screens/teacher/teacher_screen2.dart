import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/text_utils.dart';
import 'detail_grading_screen.dart';

class ClassResultModel {
  // int classId;
}

// class CourseModel2 {
//   final int courseId;
//   final int courseToken;
//   final int courseName;
//
//   CourseModel2({required this.courseId,
//     required this.courseToken,
//     required this.courseName});
// }

class ClassModel2 {
  final int classId;
  final String status;
  final String classCode;
  final int courseId;

  // final CourseModel course;

  static List<ClassModel2> make(
      List<ClassModel> classes, List<CourseModel> courses) {
    List<ClassModel2> results = [];

    for (var classModel in classes) {
      // CourseModel course = courses
      //     .firstWhere((course) => course.courseId == classModel.courseId);

      results.add(ClassModel2(
        classId: classModel.classId,
        status: classModel.classStatus,
        classCode: classModel.classCode,
        courseId: classModel.courseId,
        // course: course,
      ));
    }

    return results;
  }

  ClassModel2({
    required this.classId,
    required this.status,
    required this.courseId,
    required this.classCode,
    // required this.course,
  });
}

class ClassListCubit extends Cubit<List<ClassModel2>?> {
  ClassListCubit() : super(null) {
    loadIf();
  }

  loadIf() async {
    debugPrint(
        "ClassListCubit load ===> ${DateFormat('yyyy-MM-dd hh:mm:ss.SSS').format(DateTime.now())}");

    SharedPreferences localData = await SharedPreferences.getInstance();
    var teaId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());

    emit(await FireBaseProvider.instance.getClassByTeacherId(teaId));

    debugPrint(
        "ClassListCubit loaded ===> ${DateFormat('yyyy-MM-dd hh:mm:ss.SSS').format(DateTime.now())}");
  }
}

class CourseCubit extends Cubit<CourseModel?> {
  final int courseId;

  CourseCubit(this.courseId) : super(null) {
    load();
  }

  load() async {
    emit(await FireBaseProvider.instance.getCourseById(courseId));
  }
}

class ClassItem extends StatelessWidget {
  final CourseCubit cubit;

  final ClassModel2 classModel;

  ClassItem({super.key, required this.classModel})
      : cubit = CourseCubit(classModel.courseId);

  @override
  Widget build(BuildContext context) {
    return Card( child : Row(children: [
      BlocBuilder<CourseCubit, CourseModel?>(
        bloc: cubit,
          builder: (context, course) =>
              course == null ? Container() : Text(course.name))
    ]));
  }
}

class ClassProgress {}

class TeacherScreen2 extends StatelessWidget {
  TeacherScreen2({Key? key})
      : cubit = ClassListCubit(),
        super(key: key);

  final ClassListCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<AppBarInfoTeacherCubit, TeacherModel?>(
                  bloc: context.read<AppBarInfoTeacherCubit>()..load(),
                  builder: (context, s) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: Resizable.padding(context, 70),
                          right: Resizable.padding(context, 70),
                          top: Resizable.padding(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5, color: Colors.black)
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: Resizable.size(context, 25),
                                    backgroundColor: greyColor.shade300,
                                    child: s == null
                                        ? Container()
                                        : ImageNetwork(
                                            key: Key(s.url),
                                            image: s.url.isEmpty
                                                ? AppConfigs.defaultImage
                                                : s.url,
                                            height: Resizable.size(context, 50),
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            width: Resizable.size(context, 50),
                                            onLoading: Transform.scale(
                                              scale: 0.25,
                                              child:
                                                  const CircularProgressIndicator(),
                                            ),
                                            duration: 100,
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '${Routes.teacher}/profile');
                                            },
                                          ),
                                  )),
                              SizedBox(width: Resizable.size(context, 10)),
                              s == null
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppText.txtHello.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  Resizable.font(context, 24)),
                                        ),
                                        Text(
                                            '${s.name} ${AppText.txtSensei.text}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: Resizable.font(
                                                    context, 40)))
                                      ],
                                    )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              BlocBuilder<ClassListCubit, List<ClassModel2>?>(
                  bloc: cubit,
                  builder: (context, classes) => classes == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : classes.isNotEmpty
                          ? Column(children: [
                              ...classes
                                  .map((e) => ClassItem(classModel: e))
                                  .toList(),
                              SizedBox(height: Resizable.size(context, 50))
                            ])
                          : Center(
                              child: Text(AppText.txtNoClass.text),
                            ))
            ],
          ),
        )),
      ],
    ));
  }
}

List<String> listFilter = [
  AppText.optInProgress.text,
  AppText.optComplete.text
];
