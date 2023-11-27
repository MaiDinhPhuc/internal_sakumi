import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

import 'grading_cubit.dart';
import 'grading_item_layout.dart';

class ExpandTestItem extends StatelessWidget {
  const ExpandTestItem({super.key, required this.cubit, required this.testId});
  final GradingCubit cubit;
  final int testId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradingItemLayout(
            title: Padding(
                padding: EdgeInsets.only(left: Resizable.padding(context, 50)),
                child: Text(AppText.txtName.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17)))),
            receivedNUmber: Text(AppText.txtDoingTime.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff757575),
                    fontSize: Resizable.font(context, 17))),
            gradingNumber: Text(AppText.txtPoint.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff757575),
                    fontSize: Resizable.font(context, 17))),
            button: Text(AppText.txtNumberIgnore.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff757575),
                    fontSize: Resizable.font(context, 17))),
            dropdown: Container()),
        SizedBox(height:  Resizable.padding(context, 10)),
        ...cubit.students!.map((e) => Container(
            alignment: Alignment.centerLeft,
            margin:
            EdgeInsets.only(bottom: Resizable.padding(context, 5)),
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 15),
                vertical: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: greyColor.shade100),
                borderRadius:
                BorderRadius.circular(Resizable.size(context, 5))),
            child: GradingItemLayout(
                title: Padding(
                    padding:
                    EdgeInsets.only(left: Resizable.padding(context, 10)),
                    child: Row(
                      children: [
                        SmallAvatar(e.url),
                        SizedBox(width: Resizable.padding(context, 10)),
                        Text(e.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff131111),
                                fontSize: Resizable.font(context, 17)))
                      ],
                    )),
                receivedNUmber: Text(cubit.getTestTime(e.userId, testId),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                gradingNumber: TrackingItem(cubit.getTestPoint(e.userId, testId),
                    isSubmit: true),
                button: Text(cubit.getNumberIgnoreTest(e.userId, testId),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                dropdown: Container())))
      ],
    );
  }
}
