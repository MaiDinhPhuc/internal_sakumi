import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

void alertGradingDone(BuildContext context, Function() onPressed) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SizedBox(
            height: Resizable.size(context, 100),
            width: Resizable.size(context, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppText.txtGradingDone.text),
                Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 15)),child: ElevatedButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(
                          primaryColor ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 1000)))),
                      backgroundColor: MaterialStateProperty.all(
                          primaryColor ),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 30)))),
                  child: Text(AppText.textBack.text.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 16),
                          color: Colors.white)),
                ),)
              ],
            ),
          ),
        );
      });
}