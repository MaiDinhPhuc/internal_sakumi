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
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              url,
              fit:  BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(),
            ),
          )
        ));
  }
}
