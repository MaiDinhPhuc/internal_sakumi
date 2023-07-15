import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/header_teacher.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class ListLessonScreen extends StatelessWidget {
  final String name;
  final String classId;

  const ListLessonScreen(this.name, this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListLessonCubit()..init(context),
      child: Scaffold(
        body: Column(
          children: [
            HeaderTeacher(),
            BlocBuilder<ListLessonCubit, int>(builder: (c, s) {
              var cubit = BlocProvider.of<ListLessonCubit>(c);
              return cubit.classModel == null
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 20)),
                            child: Text(
                                '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: Resizable.font(context, 30))),
                          ),
                          cubit.listLessonResult == null
                              ? const CircularProgressIndicator()
                              : Column(
                                  children: [
                                    ...cubit.listLessonResult!.map((e) =>
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 200),
                                              vertical: Resizable.padding(
                                                  context, 5)),
                                          child: Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 20),
                                                    vertical: Resizable.padding(
                                                        context, 10)),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: Resizable.size(
                                                            context, 1.5),
                                                        color:
                                                            greyColor.shade100),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Resizable.size(
                                                                context, 5))),
                                                child: cubit.lessons == null ||
                                                        cubit.lessons!.isEmpty
                                                    ? Center(
                                                        child: SizedBox(
                                                          height:
                                                              Resizable.font(
                                                                  context, 20),
                                                          width: Resizable.font(
                                                              context, 20),
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth:
                                                                Resizable.size(
                                                                    context, 1),
                                                          ),
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            cubit
                                                                .lessons![cubit
                                                                    .listLessonResult!
                                                                    .indexOf(e)]
                                                                .title
                                                                .toUpperCase(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Resizable.font(
                                                                        context,
                                                                        20)),
                                                          ),
                                                          cubit.listStudentLessons ==
                                                                      null ||
                                                                  cubit.listAttendance ==
                                                                      null
                                                              ? const CircularProgressIndicator()
                                                              : CircleProgress(
                                                                  title:
                                                                      '${(cubit.listAttendance!.length) / (cubit.listStudentLessons!.length)}',
                                                                  lineWidth:
                                                                      Resizable.size(
                                                                          context,
                                                                          4),
                                                                  percent: 0.9,
                                                                  radius: Resizable
                                                                      .size(
                                                                          context,
                                                                          16),
                                                                  fontSize:
                                                                      Resizable.font(
                                                                          context,
                                                                          15),
                                                                )
                                                        ],
                                                      ),
                                              ),
                                              Positioned.fill(
                                                  child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/teacher?name=$name/class?id=${e.classId}/lesson?id=${e.lessonId}");
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Resizable.size(
                                                                context, 5))),
                                              ))
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                        ],
                      ),
                    ));
            })
          ],
        ),
      ),
    );
  }
}

class ListLessonCubit extends Cubit<int> {
  ListLessonCubit() : super(0);

  List<LessonResultModel>? listLessonResult;

  ClassModel? classModel;

  List<LessonModel>? lessons;

  List<StudentLessonModel>? listStudentLessons;

  List<int>? listAttendance;

  init(context) async {
    await loadClass(context);
    await loadLessonResult(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    classModel =
        await teacherRepository.getClassById(int.parse(TextUtils.getName()));

    emit(state + 1);
  }

  loadLessonResult(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    listLessonResult = await teacherRepository
        .getLessonResultByClassId(int.parse(TextUtils.getName()));

    lessons =
        await teacherRepository.getLessonsByCourseId(classModel!.courseId);

    emit(state + 1);
  }

  loadStudentLesson(context, int lessonId) async {
    listAttendance = [];
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    listStudentLessons =
        await teacherRepository.getStudentLessonsByLessonId(lessonId);

    listAttendance = listStudentLessons!.fold(
        <int>[],
        (pre, e) => [
              ...pre,
              if (e.timekeeping > 0 && e.timekeeping < 5) e.timekeeping
            ]).toList();

    emit(state + 1);
  }
}
