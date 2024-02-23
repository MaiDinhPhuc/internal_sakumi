import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'feedback_dialog_cubit.dart';
import 'input_note_feedback.dart';

class InfoFeedBackView extends StatelessWidget {
  const InfoFeedBackView({super.key, required this.feedbackDialogCubit});
  final FeedBackDialogCubit feedbackDialogCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            child: Text(AppText.txtFeedBackType.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575)))),
        InputDropdown(
            hint: feedbackDialogCubit.listType.first,
            onChanged: (v) {
              feedbackDialogCubit.chooseCategory(v!);
            },
            items: List.generate(feedbackDialogCubit.listType.length,
                (index) => (feedbackDialogCubit.listType[index])).toList()),
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            child: Text(AppText.txtFeedBack.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575)))),
        InputNoteFeedBack(
          onChange: (value) {
            feedbackDialogCubit.inputContent(value);
          },
        ),
      ],
    );
  }
}
