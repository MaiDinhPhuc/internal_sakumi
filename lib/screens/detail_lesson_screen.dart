import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/header_teacher.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  final DetailLessonCubit cubit;
  DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : cubit = DetailLessonCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailLessonCubit(),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(),
              BlocBuilder<DetailLessonCubit, LessonResultModel?>(
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
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(
                                    Resizable.padding(context, 20)),
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        Resizable.padding(context, 200)),
                                constraints: BoxConstraints(
                                    minHeight: Resizable.size(context, 50)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(
                                              0, Resizable.size(context, 2)),
                                          blurRadius:
                                              Resizable.size(context, 1),
                                          color: primaryColor)
                                    ]),
                                child: Column(
                                  children: [
                                    Text(AppText.txtNoteBeforeTeaching.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                Resizable.font(context, 24))),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          top: Resizable.padding(context, 10),
                                          bottom:
                                              Resizable.padding(context, 20)),
                                      child: Text(
                                        lesson.noteForTeacher.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                Resizable.font(context, 24)),
                                      ),
                                    ),
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
                              )
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
  DetailLessonCubit() : super(null) {
    load();
  }
  load() async {
    emit(await TeacherRepository.getLessonResultByLessonId(
        int.parse(TextUtils.getName())));
  }
}
