import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/status_feedback_icon.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'feedback_cubit.dart';
import 'feedback_note_cubit.dart';

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
                    color: const Color(0xffD9D9D9),
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
                    color: const Color(0xffD9D9D9),
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
                    color: const Color(0xffD9D9D9),
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
            color: const Color(0xffD9D9D9),
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
          Material(
              color: Colors.transparent,
              child: DottedBorderButton(
                  AppText.txtAddNote.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () async {
                noteCubit.list.add("value");
                print(noteCubit.list);
              }))
        ]));
  }
}
