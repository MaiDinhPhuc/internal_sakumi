import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/grading_item_layout.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/test_item.dart';
import 'package:internal_sakumi/features/teacher/grading_v2/grading_cubit_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'btvn_item.dart';

class ListGradingItem extends StatelessWidget {
  const ListGradingItem({super.key, required this.cubit});
  final GradingCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((cubit.isBTVN && cubit.filterListLesson().isNotEmpty) || (!cubit.isBTVN && cubit.filterListTest().isNotEmpty))
        Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 80)),
            child: GradingItemLayout(
                title: Padding(padding: EdgeInsets.only(left:Resizable.padding(context, 15) ),child: Text(AppText.titleSubject.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17)))),
                receivedNUmber: Text(AppText.textNumberResultReceive.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                gradingNumber: Text(AppText.txtGradingNumber.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                button: Container(), dropdown: Container())),
        SizedBox(height: Resizable.padding(context, 10)),
        if (cubit.isBTVN && cubit.filterListLesson().isNotEmpty)
          ...cubit.filterListLesson().map((e) => BTVNItem(e, cubit: cubit)),
        if (!cubit.isBTVN && cubit.filterListTest().isNotEmpty)
          ...cubit
              .filterListTest()
              .map((e) => TestGradingItem(e, cubit: cubit)),
        if ((cubit.isBTVN && cubit.filterListLesson().isEmpty) ||
            !cubit.isBTVN && cubit.filterListTest().isEmpty)
          Padding(
            padding: EdgeInsets.only(top: Resizable.padding(context, 50)),
            child: Text(
                AppText.txtNotGradingItem.text),
          )
      ],
    );
  }
}
