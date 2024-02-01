import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/routes.dart';

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
                      await Navigator.pushNamed(context,
                          '${Routes.admin}/searchGeneral');
                      break;
                    case 1:
                      await Navigator.pushNamed(context,
                          '${Routes.admin}/manageClasses');
                      break;
                    case 2:
                      await Navigator.pushNamed(context,
                          '${Routes.admin}/manageTags');
                      break;
                    case 3:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/manageStatistics');
                      break;
                    case 4:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/manageFeedbacks');
                      break;
                    case 5:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/tools');
                      break;
                    case 6:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/voucher');
                      break;
                    case 7:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/manageTeachers');
                      break;
                    case 8:
                      await Navigator.pushNamed(
                          context, '${Routes.admin}/manageBills');
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
