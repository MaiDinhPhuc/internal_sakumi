import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

class LessonPendingView extends StatelessWidget {
  final DetailLessonCubit cubit;
  const LessonPendingView(this.cubit, this.dataCubit, {Key? key})
      : super(key: key);
  final DataCubit dataCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteBeforeTeaching.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteBeforeTeaching.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 10)),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteFromSupport.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteFromSupport.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 10)),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteFromAnotherTeacher.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteFromAnotherTeacher.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 20)),
        SubmitButton(
            onPressed: () async {
              waitingDialog(context);
              await cubit.addLessonResult(LessonResultModel(
                  id: 1000,
                  classId: int.parse(TextUtils.getName(position: 1)),
                  lessonId: int.parse(TextUtils.getName()),
                  teacherId: cubit.teacherId!,
                  status: 'Teaching',
                  date:
                      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
                  noteForStudent: '',
                  noteForSupport: '',
                  noteForTeacher: ''));
              dataCubit.updateLessonResults(
                  int.parse(TextUtils.getName(position: 1)),
                  LessonResultModel(
                      id: 1000,
                      classId: int.parse(TextUtils.getName(position: 1)),
                      lessonId: int.parse(TextUtils.getName()),
                      teacherId: cubit.teacherId!,
                      status: 'Teaching',
                      date: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now()),
                      noteForStudent: '',
                      noteForSupport: '',
                      noteForTeacher: ''));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            title: AppText.txtStartLesson.text)
      ],
    );
  }
}
