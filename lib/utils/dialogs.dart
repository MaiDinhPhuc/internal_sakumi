import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../configs/color_configs.dart';
import '../configs/text_configs.dart';
import '../features/admin/manage_tag/custom_button_v1.dart';

class Dialogs {
  static void alertDelete(
      BuildContext context, String title, Function() onSubmit , [String description = '']) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: primaryColor,
                      size: Resizable.size(context, 100),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10)),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 20)),
                        )),

                    if(description.isNotEmpty)
                      ...[
                        Text(
                          description,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: darkPrimaryColor,
                              fontSize: Resizable.font(context, 16)),
                        ),
                        SizedBox(height: Resizable.padding(context, 10),),
                      ],
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButtonV1(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            border: Colors.black,
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            title: AppText.btnCancel.text),
                        SizedBox(
                          width: Resizable.padding(context, 15),
                        ),
                        CustomButtonV1(
                            onPressed: onSubmit,
                            textColor: Colors.white,
                            backgroundColor: primaryColor,
                            title: AppText.txtYes.text),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
