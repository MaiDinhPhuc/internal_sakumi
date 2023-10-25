import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/welcome_teacher_appbar.dart';
import 'package:internal_sakumi/main.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_statistic_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/teacher/teacher_home/class_item.dart';

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

class OverViewCubit extends Cubit<int> {
  final int courseId;
  final int classId;
  OverViewCubit(this.courseId, this.classId) : super(0) {
    load();
  }
  int? lessonCount;
  double? lessonPercent;
  CourseModel? courseModel;
  ClassStatisticModel? classStatistic;
  load() async {
    courseModel = await FireBaseProvider.instance.getCourseById(courseId);
    lessonCount = await FireBaseProvider.instance
        .getCountWithCondition("lesson_result", "class_id", classId);
    lessonPercent = lessonCount! / courseModel!.lessonCount;
    emit(state + 1);
    loadInfoStatistic();
  }

  loadInfoStatistic() async {
    classStatistic = await FireBaseProvider.instance.getClassStatistic(classId);
    emit(state+1);
  }
}

class TeacherScreen2 extends StatelessWidget {
  const TeacherScreen2({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {

    var dataController = BlocProvider.of<TeacherDataCubit>(context);

    return Scaffold(
        body: Column(
      children: [
        Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const WelComeTeacherAppBar(),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 150)),
                  child: ClassItemRowLayout(
                    widgetClassCode: Text(AppText.txtClassCode.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetCourse: Text(AppText.txtCourse.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetLessons: Text(AppText.txtNumberOfLessons.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetAttendance: Text(AppText.txtRateOfAttendance.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetSubmit: Text(AppText.txtRateOfSubmitHomework.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetEvaluate: Text(AppText.txtEvaluate.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetStatus: Text(AppText.titleStatus.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                  )),
              BlocBuilder<TeacherDataCubit, int>(
                  builder: (context, _) => dataController.classes == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : dataController.classes!.isNotEmpty
                          ? Column(children: [
                              ...dataController.classes!
                                  .map((e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.size(context, 150)),
                                      child: ClassItem(classModel: e)))
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
