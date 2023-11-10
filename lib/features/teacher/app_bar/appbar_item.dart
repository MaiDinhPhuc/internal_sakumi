import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/routes.dart';

class AppBarItem extends StatelessWidget {
  const AppBarItem(
      {super.key,
      required this.title,
      required this.role,
      required this.color,
      required this.id,
      required this.classId});
  final String title, role,classId;
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
                          "${role == "teacher" ? Routes.teacher : Routes.admin}/overview/class=$classId");
                      break;
                    case 1:
                      await Navigator.pushNamed(context,
                          "${role == "teacher" ? Routes.teacher : Routes.admin}/lesson/class=$classId");
                      break;
                    case 2:
                      await Navigator.pushNamed(context,
                          "${role == "teacher" ? Routes.teacher : Routes.admin}/test/class=$classId");
                      break;
                    case 3:
                      await Navigator.pushNamed(
                          context, "${Routes.teacher}/grading/class=$classId");
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
