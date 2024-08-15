import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'feedback_dialog_cubit.dart';
import 'input_note_feedback.dart';

class InfoFeedBackView extends StatelessWidget {
  const InfoFeedBackView({super.key, required this.feedbackDialogCubit});
  final FeedBackDialogCubit feedbackDialogCubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          Padding(
              padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.txtFiles.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: const Color(0xff757575))),
                    SizedBox(height: Resizable.padding(context, 5)),
                    if (feedbackDialogCubit.listPickerFiles.isNotEmpty)
                      SizedBox(
                          height: Resizable.size(context, 50),
                          child: ListView.builder(
                            itemCount: feedbackDialogCubit.listPickerFiles.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)),
                            itemBuilder: (_, i) => Padding(
                                padding: EdgeInsets.only(
                                    right: Resizable.padding(context, 10)),
                                child:
                                Container(
                                    padding: EdgeInsets.all(Resizable.size(context, 3)),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                        children: [
                                          Text(feedbackDialogCubit.listPickerFiles[i]['file_name'], style: TextStyle(fontSize: Resizable.size(context, 14), color: primaryColor)),
                                          SizedBox(width: Resizable.size(context, 5)),
                                          InkWell(
                                              radius:10,
                                              onTap: () async {
                                                feedbackDialogCubit.removeFile(
                                                    feedbackDialogCubit.listPickerFiles[i]);
                                              },
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: Resizable.size(context, 14),
                                                color: primaryColor,
                                              ))
                                        ]
                                    ))),
                          )),
                    DottedBorderButton(AppText.txtAddFiles.text,
                        onPressed: () async {
                          await feedbackDialogCubit.pickFiles();
                        })
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
