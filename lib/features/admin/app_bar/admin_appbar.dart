import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/navigation/navigation.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'admin_appbar_item.dart';
import 'log_out_button.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: Resizable.padding(context, 10),
          left: Resizable.padding(context, 100),
          right: Resizable.padding(context, 100),
          top: Resizable.padding(context, 10)),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
      ]),
      child: Row(
        children: [
          Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
            ... buttonAdminList
                .map((e) => AdminAppBarItem(
              title: e.button,
              color: index == e.id
                  ? primaryColor
                  : Colors.transparent,
              id: e.id,
            ))
                .toList(),
          ],)),
          const Expanded(
              flex: 3,
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LogOutButton()
            ],
          ))
        ],
      ),
    );
  }
}
List<NavigationModel> buttonAdminList = [
  NavigationModel(0, AppText.titleSearch.text),
  NavigationModel(1, AppText.titleManageClass.text),
  NavigationModel(2, AppText.titleManageTag.text),
  NavigationModel(3, AppText.titleStatistics.text),
  NavigationModel(4, AppText.titleManageFeedBack.text)
];