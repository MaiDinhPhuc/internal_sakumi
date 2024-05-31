import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'browse_download_item.dart';
import 'browse_download_item_layout.dart';
import 'manage_browse_download_cubit.dart';

class BrowseDownloadView extends StatelessWidget {
  const BrowseDownloadView({super.key, required this.cubit});

  final ManageBrowseDownloadCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 10)),
              child: BrowseDownloadItemLayout(
                  widgetTitle: Text(
                    AppText.txtTitle.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetSensei: Text(
                    AppText.txtSensei.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetClassCode: Text(
                    AppText.txtClassCode.text,
                    style:TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetRequestDate: Text(
                    AppText.txtRequestDate.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetAcceptDate: Text(
                    AppText.txtAcceptDate.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetDownloadDate: Text(
                    AppText.txtDownloadDate.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 17),
                        color: greyColor.shade600),
                  ),
                  widgetButton: Container())),
          SizedBox(height: Resizable.size(context, 5)),
          ...cubit.listBrowseDownload!
              .map((e) => BrowseDownloadItem(cubit: cubit, model: e)),
        ],
      ),
    );
  }
}
