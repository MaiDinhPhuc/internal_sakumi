import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/functions.dart';

class AdminAppBarItem extends StatelessWidget {
  const AdminAppBarItem({super.key, required this.title, required this.color, required this.id});
  final String title;
  final Color color;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: greyColor.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              color: color,
              margin: const EdgeInsets.only(
                  top: 25, bottom: 3, left: 10, right: 10),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                overlayColor:
                MaterialStateProperty.all(primaryColor.withAlpha(30)),
                onTap: () async {
                  switch (id) {
                    case 0:
                      await Functions.goPage('${Routes.admin}/searchGeneral', context);
                      break;
                    case 1:
                      await Functions.goPage('${Routes.admin}/manageClasses', context);
                      break;
                    case 2:
                      await Functions.goPage('${Routes.admin}/manageTags', context);
                      break;
                    case 3:
                      await Functions.goPage('${Routes.admin}/manageStatistics', context);
                      break;
                    case 4:
                      await Functions.goPage('${Routes.admin}/manageFeedbacks', context);
                      break;
                    case 5:
                      await Functions.goPage('${Routes.admin}/tools', context);
                      break;
                    case 6:
                      await Functions.goPage('${Routes.admin}/voucher', context);
                      break;
                    case 7:
                      await Functions.goPage('${Routes.admin}/manageTeachers', context);
                      break;
                    case 8:
                      await Functions.goPage('${Routes.admin}/manageBills', context);
                      break;
                    case 9:
                      await Functions.goPage('${Routes.admin}/manageAdvises', context);
                      break;
                    case 10:
                      await Functions.goPage('${Routes.admin}/manageProcedure', context);
                      break;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
