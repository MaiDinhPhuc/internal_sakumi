import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/header_teacher.dart';
import 'package:internal_sakumi/features/teacher/attendance_item.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  final DetailLessonCubit cubit = DetailLessonCubit();
  DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailLessonCubit()..load(),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(),
              BlocConsumer<DetailLessonCubit, LessonResultModel?>(
                  listener: (c, s) {
                    //cubit.load();
                    debugPrint(
                        '============> ===========> ${s!.status.toString()}');
                  },
                  bloc: cubit..load(),
                  builder: (c, lesson) => lesson == null
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 20)),
                                child: Text(
                                    '${AppText.txtLesson.text} ${lesson.lessonId}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 30))),
                              ),
                              if (lesson.status == 'Pending')
                                Column(
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 20)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 200)),
                                      constraints: BoxConstraints(
                                          minHeight:
                                              Resizable.size(context, 50)),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0,
                                                    Resizable.size(context, 2)),
                                                blurRadius:
                                                    Resizable.size(context, 1),
                                                color: primaryColor)
                                          ]),
                                      child: Column(
                                        children: [
                                          Text(
                                              AppText
                                                  .txtNoteBeforeTeaching.text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Resizable.font(
                                                      context, 24))),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: Resizable.padding(
                                                    context, 10),
                                                bottom: Resizable.padding(
                                                    context, 20)),
                                            child: Text(
                                              lesson.noteForSupport.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Resizable.font(
                                                      context, 24)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: Resizable.size(context, 10)),
                                    Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 20)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 200)),
                                      constraints: BoxConstraints(
                                          minHeight:
                                              Resizable.size(context, 50)),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0,
                                                    Resizable.size(context, 2)),
                                                blurRadius:
                                                    Resizable.size(context, 1),
                                                color: primaryColor)
                                          ]),
                                      child: Column(
                                        children: [
                                          Text(AppText.txtNoteFromSupport.text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Resizable.font(
                                                      context, 24))),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: Resizable.padding(
                                                    context, 10),
                                                bottom: Resizable.padding(
                                                    context, 20)),
                                            child: Text(
                                              lesson.noteForSupport.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Resizable.font(
                                                      context, 24)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: Resizable.size(context, 10)),
                                    Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 20)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 200)),
                                      constraints: BoxConstraints(
                                          minHeight:
                                              Resizable.size(context, 50)),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0,
                                                    Resizable.size(context, 2)),
                                                blurRadius:
                                                    Resizable.size(context, 1),
                                                color: primaryColor)
                                          ]),
                                      child: Column(
                                        children: [
                                          Text(
                                              AppText.txtNoteFromAnotherTeacher
                                                  .text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Resizable.font(
                                                      context, 24))),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                top: Resizable.padding(
                                                    context, 10),
                                                bottom: Resizable.padding(
                                                    context, 20)),
                                            child: Text(
                                              lesson.noteForTeacher.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Resizable.font(
                                                      context, 24)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: Resizable.size(context, 20)),
                                    ElevatedButton(
                                      onPressed: () => startLesson(lesson),
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: Resizable.padding(
                                                      context, 30)))),
                                      child: Text(AppText.txtStartLesson.text),
                                    ),
                                  ],
                                ),
                              if (lesson.status == 'Teaching')
                                BlocProvider(
                                    create: (context) =>
                                        AttendanceCubit()..init(context),
                                    child: BlocBuilder<AttendanceCubit, int>(
                                      builder: (cc, __) {
                                        var attendCubit =
                                            BlocProvider.of<AttendanceCubit>(
                                                cc);
                                        return attendCubit.listStudent == null
                                            ? const CircularProgressIndicator()
                                            : Column(
                                                // children: [
                                                //   ...attendCubit.listStudent!
                                                //       .map((e) =>
                                                //           AttendanceItem(e))
                                                // ],
                                                );
                                      },
                                    ))
                            ],
                          ),
                        )))
            ],
          ),
        ));
  }

  startLesson(LessonResultModel model) async {
    await FirebaseFirestore.instance
        .collection('lesson_result')
        .doc("lesson_${model.lessonId}_class_${model.classId}")
        .update({
      'status': 'Teaching',
    });
  }
}

class DetailLessonCubit extends Cubit<LessonResultModel?> {
  DetailLessonCubit() : super(null);

  load() async {
    emit(await TeacherRepository.getLessonResultByLessonId(
        int.parse(TextUtils.getName())));
  }
}

class AttendanceCubit extends Cubit<int> {
  AttendanceCubit() : super(0);

  List<StudentModel>? listStudent;

  init(context) {
    loadStudentInClass(context);
  }

  updateTimeKeeping() {}

  loadStudentInClass(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    List<int> list = [];
    List<StudentModel> listAllStudent = await adminRepository.getAllStudent();
    debugPrint("============> listStudentClass");
    List<StudentClassModel> listStudentClass =
        await adminRepository.getStudentClassByClassId(
            int.parse(TextUtils.getName(position: 2)));
    debugPrint("============> listStudentClass111");
    for (var i in listStudentClass) {
      list.add(i.userId);
    }

    list = LinkedHashSet<int>.from(list.map((e) => e)).toList();

    listStudent = [];
    for (var i in list) {
      for (var j in listAllStudent) {
        if (j.userId == i) {
          listStudent!.add(j);
          break;
        }
      }
    }
    emit(state + 1);
  }
}
