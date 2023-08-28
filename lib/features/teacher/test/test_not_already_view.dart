import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/alert_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TestNotAlreadyView extends StatelessWidget {
  const TestNotAlreadyView(
      {super.key,
      required this.index,
      required this.title,
      required this.onTap});
  final int index;
  final String title;
  final Function() onTap;

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
          status: ElevatedButton(
            onPressed: () => alertAssignTestView(context, onTap),
            style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(greyColor.shade500),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: greyColor.shade500),
                    borderRadius: BorderRadius.circular(
                        Resizable.padding(context, 1000)))),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 27)))),
            child: Text(AppText.txtAssignmentTest.text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 12),
                    color: greyColor.shade500)),
          ),
          mark: Container(),
          dropdown: Container()),
    );
  }
}
