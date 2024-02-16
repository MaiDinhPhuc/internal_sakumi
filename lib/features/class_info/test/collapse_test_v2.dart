import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'detail_test_cubit_v2.dart';

class CollapseTestV2 extends StatelessWidget {
  const CollapseTestV2(
      {super.key, required this.detailCubit, required this.index});
  final DetailTestV2 detailCubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TestItemRowLayout(
          test: Padding(
              padding: EdgeInsets.only(left: Resizable.padding(context, 10)),
              child: Text(
                  '${AppText.textLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 20)))),
          name: Text(detailCubit.testModel.title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 16))),
          submit: CircleProgress(
            title: '${(detailCubit.getSubmitPercent() * 100).toStringAsFixed(0)} %',
            lineWidth: Resizable.size(context, 3),
            percent: detailCubit.getSubmitPercent(),
            radius: Resizable.size(context, 16),
            fontSize: Resizable.font(context, 14),
          ),
          mark: detailCubit.getGPA() == 0
              ? Container()
              : Container(
              height: Resizable.size(context, 30),
              width: Resizable.size(context, 30),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: greyColor.shade100),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                    detailCubit.getGPA().toStringAsFixed(1),
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: Resizable.font(context, 18),
                        fontWeight: FontWeight.w800),
                  ))),
          status: detailCubit.checkGrading() == null
              ? Container()
              : Container(
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 4),
                  horizontal: Resizable.padding(context, 10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10000),
                  color: detailCubit.checkGrading() == true
                      ? greenColor
                      : redColor),
              child: Text(
                (detailCubit.checkGrading() == true
                    ? AppText.txtMarked.text
                    : AppText.txtNotMark.text)
                    .toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w800),
              )),
          dropdown: Container(),
        ),
        Text(detailCubit.testModel.description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 16)))
      ],
    );
  }
}
