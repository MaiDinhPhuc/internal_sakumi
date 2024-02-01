import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/navigation/navigation.dart';
import 'package:internal_sakumi/routes.dart';
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
          // left: Resizable.padding(context, 100),
          right: Resizable.padding(context, 60),
          top: Resizable.padding(context, 10)),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
      ]),
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
          const LogOutButton()
        ],)
    );
  }
}
List<NavigationModel> buttonAdminList = [
  NavigationModel(0, AppText.titleSearch.text),
  NavigationModel(1, AppText.titleManageClass.text),
  NavigationModel(8, AppText.titleManageBill.text),
  NavigationModel(2, AppText.titleManageTag.text),
  NavigationModel(3, AppText.titleStatistics.text),
  NavigationModel(4, AppText.titleManageFeedBack.text),
  NavigationModel(5, AppText.txtTool.text),
  NavigationModel(6, AppText.txtVoucher.text),
  NavigationModel(7, AppText.titleManageTeacher.text)
];

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 30,
            margin: EdgeInsets.only(
                left: Resizable.padding(context, 20)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded , color: primaryColor.shade500,),
                      SizedBox(
                          width: Resizable.padding(
                              context, 5)),
                      Text(AppText.txtBack.text,
                          style: TextStyle(
                              color: greyColor.shade600,
                              fontWeight:
                              FontWeight.w700,
                              fontSize: 16)),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(100),
                      overlayColor:
                      MaterialStateProperty.all(
                          primaryColor
                              .withAlpha(30)),
                      onTap: ()  {
                        Navigator.pushReplacementNamed(context, '${Routes.admin}/searchGeneral');
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(
                            horizontal: 2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const LogOutButton()
        ],
      ),
    );
  }
}