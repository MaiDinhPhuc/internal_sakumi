import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherHomeButton extends StatelessWidget {
  const TeacherHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin:
      const EdgeInsets.symmetric(horizontal: 3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    'assets/images/ic_home.png',
                    scale: 60),
                SizedBox(
                    width: Resizable.padding(
                        context, 5)),
                Text(AppText.titleHome.text,
                    style: TextStyle(
                        color: greyColor.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
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
                    primaryColor.withAlpha(30)),
                onTap: () async {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                        context, Routes.teacher);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 2),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
