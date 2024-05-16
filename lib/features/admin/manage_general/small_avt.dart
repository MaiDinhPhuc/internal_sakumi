import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SmallAvatar extends StatelessWidget {
  final String? url;
  const SmallAvatar(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Resizable.size(context, 16),
      backgroundColor: greyColor.shade300,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child:
              url == ''
                  ? Image.asset("assets/images/ic_avt.png")
                  : Image.network(
                      '$url',
                      fit: BoxFit.cover,
                      height: Resizable.size(context, 32),
                      width: Resizable.size(context, 32),
                      errorBuilder: (_, __, ___) => Container(),
                    )
          ),
    );
  }
}
