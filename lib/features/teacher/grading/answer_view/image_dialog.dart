import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
        child: Container(
          width: MediaQuery.of(context).size.width *0.5,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 7,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Resizable.size(context, 10))),
                      child: Image.network(
                        url,
                        fit:  BoxFit.contain,
                        height: Resizable.size(context, 400),
                        width: Resizable.size(context, 400),
                        errorBuilder: (_, __, ___) => Container(),
                      ))),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: Resizable.padding(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                minWidth:
                                Resizable.size(context, 100)),
                            child: DialogButton(
                                AppText.textCancel.text.toUpperCase(),
                                onPressed: () =>
                                    Navigator.pop(context)),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}
