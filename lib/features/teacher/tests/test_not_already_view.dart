import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/test/alert_confirm_assign_test.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_test_see_soon.dart';

class TestNotAlreadyView extends StatelessWidget {
  const TestNotAlreadyView(
      {super.key,
      required this.index,
      required this.title,
      required this.onConfirm,
      required this.role,
      required this.test});
  final int index;
  final String title, role;
  final Function() onConfirm;
  final TestModel test;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 150),
          vertical: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 15),
          vertical: Resizable.padding(context, 8)),
      decoration: BoxDecoration(
          color: greyColor.shade100,
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: TestItemRowLayout(
          test: Padding(
              padding: EdgeInsets.only(left: Resizable.padding(context, 10)),
              child: Text(
                  '${AppText.textLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 20)))),
          name: Text(title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 16))),
          submit: Container(),
          status: Container(),
          mark: Container(),
          dropdown: PopupMenuButton(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.black, // Set the desired border color here
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(Resizable.size(context, 5)),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  await alertTestSeeSoon(context, test);
                  //waitingDialog(context);
                },
                padding: EdgeInsets.zero,
                child: Center(
                    child: Text(AppText.txtSeeSoon.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Resizable.font(context, 20)))),
              ),
              if (role == "teacher")
                PopupMenuItem(
                  onTap: () {
                    alertAssignTestView(context, onConfirm);
                    //waitingDialog(context);
                  },
                  padding: EdgeInsets.zero,
                  child: Center(
                      child: Text(AppText.txtAssignTest.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Resizable.font(context, 20),
                              color: const Color(0xffB71C1C)))),
                )
            ],
            icon: const Icon(Icons.more_vert),
          )),
    );
  }
}
