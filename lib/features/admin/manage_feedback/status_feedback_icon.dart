import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/master/manage_teacher_feedback/teacher_feedback_cubit.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'feedback_cubit.dart';

class StatusFeedbackIcon extends StatelessWidget {
  const StatusFeedbackIcon(
      {super.key, required this.feedback, required this.cubit});
  final FeedBackModel feedback;
  final FeedBackCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (cc, s) {
          return PopupMenuButton(
            itemBuilder: (context) => [
              ...cubit.listStatus.map((e) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: BlocProvider(
                      create: (context) =>
                          CheckBoxFilterCubit(feedback.status == e),
                      child: BlocBuilder<CheckBoxFilterCubit, bool>(
                          builder: (c, state) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            if (feedback.status != e) {
                              cubit.changeStatus(feedback, e);
                            }
                          },
                          child: Container(
                              height: Resizable.size(context, 33),
                              decoration: BoxDecoration(
                                  color: state ? primaryColor : Colors.white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subStatus(e),
                                        style: TextStyle(
                                            fontSize:
                                                Resizable.font(context, 15),
                                            color: state
                                                ? Colors.white
                                                : Colors.black)),
                                    if (state)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                  ],
                                ),
                              )),
                        );
                      }))))
            ],
            child: Image.asset("assets/images/ic_${feedback.status}.png",
                height: Resizable.size(context, 25),
                width: Resizable.size(context, 25)),
          );
        },
      ),
    );
  }
}

class StatusFeedbackIconV2 extends StatelessWidget {
  const StatusFeedbackIconV2(
      {super.key, required this.feedback, required this.cubit});
  final FeedBackModel feedback;
  final TeacherFeedBackCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (cc, s) {
          return PopupMenuButton(
            itemBuilder: (context) => [
              ...cubit.listStatus.map((e) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: BlocProvider(
                      create: (context) =>
                          CheckBoxFilterCubit(feedback.status == e),
                      child: BlocBuilder<CheckBoxFilterCubit, bool>(
                          builder: (c, state) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (feedback.status != e) {
                                  cubit.changeStatus(feedback, e);
                                }
                              },
                              child: Container(
                                  height: Resizable.size(context, 33),
                                  decoration: BoxDecoration(
                                      color: state ? primaryColor : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Resizable.padding(context, 10)),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(subStatus(e),
                                            style: TextStyle(
                                                fontSize:
                                                Resizable.font(context, 15),
                                                color: state
                                                    ? Colors.white
                                                    : Colors.black)),
                                        if (state)
                                          const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                      ],
                                    ),
                                  )),
                            );
                          }))))
            ],
            child: Image.asset("assets/images/ic_${feedback.status}.png",
                height: Resizable.size(context, 25),
                width: Resizable.size(context, 25)),
          );
        },
      ),
    );
  }
}

String subStatus(String value) {
  switch (value) {
    case "unread":
      return "Chưa đọc";
    case "waiting":
      return "Đang chờ được xử lí";
    case "done":
      return "Đã xử lí";
  }
  return "Chưa đọc";
}
