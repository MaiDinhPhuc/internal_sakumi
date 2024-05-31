import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/manage_browse_download_cubit.dart';
import 'package:internal_sakumi/features/class_info/lesson/sensei_item_v2.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'browse_download_item_layout.dart';

class BrowseDownloadItem extends StatelessWidget {
  const BrowseDownloadItem({super.key, required this.cubit, required this.model});

  final ManageBrowseDownloadCubit cubit;
  final BrowseDownloadModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 3),
          horizontal: Resizable.padding(context, 10)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 10),
          vertical: Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: BrowseDownloadItemLayout(
        widgetTitle: Text(
          cubit.getTitle(model.lessonId),
          style: TextStyle(
              fontSize: Resizable.size(context, 14),
              fontWeight: FontWeight.w700),
        ),
        widgetSensei: SenseiItemBrowseDownload(teacher: cubit.getTeacher(model.teacherId)) ,
        widgetClassCode: Text(
          cubit.getClassCode(model.classId),
          style: TextStyle(fontSize: Resizable.size(context, 14), fontWeight: FontWeight.w600),
        ),
        widgetRequestDate: Text(
          cubit.convertDate(model.submitTime),
          style: TextStyle(fontSize: Resizable.size(context, 14), fontWeight: FontWeight.w600),
        ),
        widgetAcceptDate: Text(
            cubit.convertDate(model.acceptTime).isEmpty ? "Chưa accept" :cubit.convertDate(model.acceptTime),
          style: TextStyle(fontSize: Resizable.size(context, 14), fontWeight: FontWeight.w600),
        ),
        widgetDownloadDate: Text(
          cubit.convertDate(model.downloadTime).isEmpty ? "Chưa download" :cubit.convertDate(model.downloadTime),
          style: TextStyle(fontSize: Resizable.size(context, 14), fontWeight: FontWeight.w600),
        ),
        widgetButton: ElevatedButton(
          onPressed: () {
            if(model.acceptTime == 0){
              int time = DateTime.now().millisecondsSinceEpoch;
              Update.updateBrowseDownload(model.copyWith(status: 'accept', acceptTime: time));
              cubit.updateRequest(model.copyWith(status: 'accept', acceptTime: time));
            }
          },
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      Resizable.padding(context, 3)))),
              backgroundColor: MaterialStateProperty.all(
                 model.acceptTime != 0
                      ? darkPrimaryColor
                      : primaryColor),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 10)))),
          child: Text(model.acceptTime != 0 ?  AppText.txtAccept.text : AppText.txtNotAccept.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 16),
                  color: Colors.white)),
        )
      ),
    );
  }
}
