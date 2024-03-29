import 'package:flutter/Material.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/utils/resizable.dart';
// import 'dart:ui' as ui;
// import 'dart:html' as html;

class SmallAvatar extends StatelessWidget {
  final String url;
  const SmallAvatar(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Resizable.size(context, 16),
      backgroundColor: const Color(0xffD9D9D9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: //Image.asset("assets/images/ic_avt.png")
        url == '' ? Image.asset("assets/images/ic_avt.png") : //ImageView(url)
        ImageNetwork(
            duration: 100,
            image: url,
            height: Resizable.size(context, 32),
            width: Resizable.size(context, 32),
            onError: Container(),
            onLoading: Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(),
            )),
      ),
    );
  }
}
// class ImageView extends StatelessWidget {
//   final String url;
//   ImageView(this.url, {super.key}) {
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(url, (int id) {
//       var iframe = html.ImageElement();
//       iframe.src = url;
//       return iframe;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return HtmlElementView(viewType: url);
//   }
// }