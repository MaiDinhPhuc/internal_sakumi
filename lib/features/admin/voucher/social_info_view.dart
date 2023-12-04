import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/voucher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SocialInfoView extends StatelessWidget {
  SocialInfoView({Key? key}) : super(key: key);

  var listSocialInfo = [
    SocialInfoModel(
        'assets/images/ic_facebook.png', 'Tiếng Nhật Mỗi Ngày', '@PORO.nihongo'),
    SocialInfoModel(
        'assets/images/ic_facebook.png', 'Nhật Ngữ Sakumi', '@PORO.SAKUMI'),
    SocialInfoModel('assets/images/ic_youtube.png', 'Tiếng Nhật Mỗi Ngày',
        '@tiengnhatmoingayofficial'),
    SocialInfoModel(
        'assets/images/ic_tiktok.png', 'ngan.sakumi', '@ngan.sakumi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...listSocialInfo
            .map((model) => Row(
          children: [
            Image.asset(model.image,
                width: Resizable.size(context, 15),
                height: Resizable.size(context, 15)),
            SizedBox(width: Resizable.size(context, 2)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(model.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 11),
                        color: Colors.black)),
                SizedBox(height: Resizable.size(context, 2)),
                Text(model.link,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 11),
                        color: const Color(0xff757575)))
              ],
            )
          ],
        ))
            .toList()
      ],
    );
  }
}