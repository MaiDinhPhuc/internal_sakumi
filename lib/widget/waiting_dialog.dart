import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

Future<void> waitingDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WaitingAlert());
}

Future<void> notificationDialog(BuildContext context, String content) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NotifyAlert(content));
}

Future<void> selectionDialog(BuildContext context, String firsTitle,
    String secondTitle, Function() firstFunction, Function() secondFunction) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            child: Container(
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                width: Resizable.width(context) / 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Resizable.padding(context, 20)),
                      child: Text(AppText.txtPleaseSelect.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w700)),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: DottedBorderButton(
                                firsTitle,
                                isManageGeneral: true,
                                onPressed: firstFunction)),
                        SizedBox(width: Resizable.size(context, 20)),
                        Expanded(
                            child: DottedBorderButton(
                                secondTitle,
                                isManageGeneral: true, onPressed: secondFunction)),
                      ],
                    ),
                  ],
                )));
      });
}

class WaitingAlert extends StatelessWidget {
  const WaitingAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
              height: Resizable.size(context, 50),
              width: Resizable.size(context, 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(Resizable.size(context, 5)),
              ),
              child: Transform.scale(
                scale: 0.75,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
        ));
  }
}

class NotifyAlert extends StatelessWidget {
  final String content;
  const NotifyAlert(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        alignment: Alignment.center,
        child: Container(
          width: Resizable.size(context, 200),
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                  EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                  child: Text(content,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)))),
              Align(
                alignment: Alignment.bottomRight,
                child: DialogButton(AppText.txtOK.text,
                    onPressed: () => Navigator.pop(context)),
              )
            ],
          ),
        ));
  }
}

