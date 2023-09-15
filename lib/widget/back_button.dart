import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Navigator.pop(context);
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
