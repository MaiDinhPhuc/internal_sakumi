import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/status_feedback_icon.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/features/master/manage_teacher_feedback/teacher_feedback_cubit.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'dart:html' as html;

import 'feedback_cubit.dart';
import 'feedback_note_cubit.dart';
import 'input_feedback_note.dart';

class FeedBackItem extends StatelessWidget {
  FeedBackItem({super.key, required this.feedback, required this.cubit})
      : noteCubit = NoteFeedBackCubit();
  final FeedBackModel feedback;
  final FeedBackCubit cubit;
  final NoteFeedBackCubit noteCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 10),
            horizontal: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(Resizable.size(context, 5))),
            color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SmallAvatar(cubit.getAvt(feedback.userId)),
                  SizedBox(width: Resizable.font(context, 10)),
                  Text(cubit.getName(feedback.userId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  Text(cubit.getClassCode(feedback.classId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  Text(cubit.getCourse(feedback.classId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  Text(cubit.getDate(feedback.date),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                ],
              ),
              StatusFeedbackIcon(feedback: feedback, cubit: cubit)
            ],
          ),
          Container(
            height: Resizable.size(context, 1),
            margin: EdgeInsets.only(
                top: Resizable.padding(context, 5),
                bottom: Resizable.padding(context, 10)),
            color: greyColor.shade300,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(feedback.content,
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          BlocBuilder<NoteFeedBackCubit, int>(
              bloc: noteCubit..loadNote(feedback),
              builder: (cc, ss) {
                return Column(
                  children: [
                    ...noteCubit.listNote.map((e) => InputFeedBackNote( sendNote: ()async{
                      if(noteCubit.listController[noteCubit.listNote.indexOf(e)].text != ""){
                        noteCubit.sendNote(feedback,cubit);
                      }
                    }, controller: noteCubit.listController[noteCubit.listNote.indexOf(e)],)),
                    if (noteCubit.canAdd)
                      Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 10)),child: Material(
                          color: Colors.transparent,
                          child: DottedBorderButton(
                              AppText.txtAddNote.text.toUpperCase(),
                              isManageGeneral: true,
                              onPressed: () async {
                                noteCubit.addNewNote();
                              })))
                  ],
                );
              })
        ]));
  }
}

class FeedBackItemV2 extends StatelessWidget {
  FeedBackItemV2({super.key, required this.feedback, required this.cubit})
      : noteCubit = NoteFeedBackCubit();
  final FeedBackModel feedback;
  final TeacherFeedBackCubit cubit;
  final NoteFeedBackCubit noteCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 10),
            horizontal: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(Resizable.size(context, 5))),
            color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SmallAvatar(cubit.getAvt(feedback.userId)),
                  SizedBox(width: Resizable.font(context, 10)),
                  Text(cubit.getName(feedback.userId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  Text(cubit.getDate(feedback.date),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                ],
              ),
              StatusFeedbackIconV2(feedback: feedback, cubit: cubit)
            ],
          ),
          Container(
            height: Resizable.size(context, 1),
            margin: EdgeInsets.only(
                top: Resizable.padding(context, 5),
                bottom: Resizable.padding(context, 10)),
            color: greyColor.shade300,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(feedback.content,
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          if (feedback.files.isNotEmpty)
            SizedBox(
                height: Resizable.size(context, 50),
                child: ListView.builder(
                  itemCount: feedback.files.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 5)),
                  itemBuilder: (_, i) => Padding(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 10)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 10)),
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            html.AnchorElement anchorElement = html.AnchorElement(href: feedback.files[i]['db']);
                            anchorElement.download = feedback.files[i]['db'];
                            anchorElement.click();
                          },
                          child: Text(feedback.files[i]['file_name'],
                              style: TextStyle(
                                  fontSize: Resizable.padding(context, 14),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )),
                )),
          BlocBuilder<NoteFeedBackCubit, int>(
              bloc: noteCubit..loadNote(feedback),
              builder: (cc, ss) {
                return Column(
                  children: [
                    ...noteCubit.listNote.map((e) => InputFeedBackNote( sendNote: ()async{
                      if(noteCubit.listController[noteCubit.listNote.indexOf(e)].text != ""){
                        noteCubit.sendNoteV2(feedback,cubit);
                      }
                    }, controller: noteCubit.listController[noteCubit.listNote.indexOf(e)],)),
                    if (noteCubit.canAdd)
                      Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 10)),child: Material(
                          color: Colors.transparent,
                          child: DottedBorderButton(
                              AppText.txtAddNote.text.toUpperCase(),
                              isManageGeneral: true,
                              onPressed: () async {
                                noteCubit.addNewNote();
                              })))
                  ],
                );
              })
        ]));
  }
}
