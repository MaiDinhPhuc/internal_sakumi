import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_teacher_feedback/teacher_feedback_cubit.dart';

import 'feedback_cubit.dart';
import 'feedback_item.dart';

class ListFeedBack extends StatelessWidget {
  const ListFeedBack({super.key, required this.cubit});
  final FeedBackCubit cubit;
  @override
  Widget build(BuildContext context) {
    return cubit.getFeedBack().isEmpty
        ? Center(
            child: Text(AppText.txtFeedBackEmpty.text),
          )
        : Column(
            children: [
              ...cubit
                  .getFeedBack()
                  .map((e) => FeedBackItem(feedback: e, cubit: cubit))
            ],
          );
  }
}

class ListFeedBackV2 extends StatelessWidget {
  const ListFeedBackV2({super.key, required this.cubit});
  final TeacherFeedBackCubit cubit;
  @override
  Widget build(BuildContext context) {
    return cubit.getFeedBack().isEmpty
        ? Center(
      child: Text(AppText.txtFeedBackEmpty.text),
    )
        : Column(
      children: [
        ...cubit
            .getFeedBack()
            .map((e) => FeedBackItemV2(feedback: e, cubit: cubit))
      ],
    );
  }
}
