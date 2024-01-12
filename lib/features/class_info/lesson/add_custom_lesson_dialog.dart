import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'info_add_custom_lesson_dialog.dart';

class AddCustomLessonDialog extends StatelessWidget {
  AddCustomLessonDialog({super.key})
      : desCon = TextEditingController(),
        titleCon = TextEditingController();

  final TextEditingController desCon, titleCon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin:
                        EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                    child: Text(
                      AppText.btnAddNewLesson.text.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child:
                      InfoAddCustomLesson(desCon: desCon, titleCon: titleCon)),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin:
                          EdgeInsets.only(top: Resizable.padding(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                minWidth: Resizable.size(context, 100)),
                            margin: EdgeInsets.only(
                                right: Resizable.padding(context, 20)),
                            child: DialogButton(
                                AppText.textCancel.text.toUpperCase(),
                                onPressed: () => Navigator.pop(context)),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                minWidth: Resizable.size(context, 100)),
                            child: SubmitButton(
                                onPressed: () {}, title: AppText.btnAdd.text),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}
