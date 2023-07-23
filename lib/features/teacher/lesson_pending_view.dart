import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class LessonPendingView extends StatelessWidget {
  final LessonResultModel lessonResultModel;
  const LessonPendingView(this.lessonResultModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 150)),
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
              Text(AppText.txtNoteBeforeTeaching.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  lessonResultModel!.noteForSupport.toString(),
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
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 200)),
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
              Text(AppText.txtNoteFromSupport.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  lessonResultModel!.noteForSupport.toString(),
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
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 200)),
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
              Text(AppText.txtNoteFromAnotherTeacher.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  lessonResultModel!.noteForTeacher.toString(),
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
            onPressed: () => BlocProvider.of<DetailLessonCubit>(context)
                .updateStatus(context, 'Teaching'),
            title: AppText.txtStartLesson.text)
      ],
    );
  }
}
