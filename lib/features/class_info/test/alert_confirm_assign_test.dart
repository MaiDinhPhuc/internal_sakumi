import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

void alertAssignTestView(BuildContext context, Function() onSubmit) {
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
                  Image.asset("assets/images/ic_thumb_up.png",scale: 10),
                  Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),child: Text(
                    AppText.txtSSConfirmAssignTest.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                            shadowColor:
                            MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        Resizable.padding(context, 1000)))),
                            backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal:
                                    Resizable.padding(context, 30)))),
                        child: Text(AppText.txtBack.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 16),
                                color: Colors.black)),
                      ),
                      SubmitButton(
                          onPressed: onSubmit,
                          title: AppText.txtAgree.text)
                    ],
                  )
                ],
              ),
            ));
      });
}
