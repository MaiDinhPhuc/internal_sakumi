import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile/log_out_dialog.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(
          horizontal: 3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppText.txtLogout.text,
                    style: TextStyle(
                        color: greyColor.shade600,
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 16)),
                SizedBox(
                    width: Resizable.padding(
                        context, 5)),
                Icon(Icons.logout , color: primaryColor.shade500,)
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
                  showDialog(
                      context: context,
                      builder: (context) => const LogOutDialog());
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
    );
  }
}
