import 'package:flutter/Material.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_status_item.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'add_new_report_dialog.dart';
import 'confirm_delete_report.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({super.key, required this.reportModel, required this.cubit, required this.role});
  final ReportModel reportModel;
  final TeacherReportCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
        alignment: Alignment.centerLeft,
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10),vertical: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: greyColor.shade600),
            borderRadius:
                BorderRadius.all(Radius.circular(Resizable.size(context, 5))),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reportModel.title.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: Resizable.font(context, 20))),
                    SizedBox(height: Resizable.padding(context, 5)),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled_outlined, size: Resizable.size(context, 20),color: greyColor.shade600),
                        SizedBox(width: Resizable.padding(context, 5)),
                        Text(cubit.convertDate(reportModel.id),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: greyColor.shade600,
                                fontSize: Resizable.font(context, 18))),
                        SizedBox(width: Resizable.padding(context, 20)),
                        Icon(Icons.person, size: Resizable.size(context, 20),color: greyColor.shade600),
                        SizedBox(width: Resizable.padding(context, 5)),
                        Text(reportModel.createName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: greyColor.shade600,
                                fontSize: Resizable.font(context, 18))),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ReportStatusItem(reportModel.status),
                    if(role == 'admin')
                      SizedBox(
                      height: Resizable.size(context, 15),
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        splashRadius: Resizable.size(context, 15),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 5)),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AddNewReportDialog(reportCubit: cubit, isEdit: true, reportModel: reportModel));
                            },
                            padding: EdgeInsets.zero,
                            child: Center(
                                child: Text(AppText.txtEditReport.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                        Resizable.font(context, 20),
                                        color: Colors.black))),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ConfirmDeleteReport(
                                        onPress: () {
                                          cubit.removeReport(reportModel.id);
                                          Navigator.of(context).pop();
                                        });
                                  });
                            },
                            padding: EdgeInsets.zero,
                            child: Center(
                                child: Text(AppText.txtDeleteReport.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                        Resizable.font(context, 20),
                                        color: Colors.red))),
                          )
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    )
                  ],
                )
              ],
            ),
            const Divider(thickness: 1),
            Text(reportModel.content,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: Resizable.font(context, 20))),
            if(reportModel.images.isNotEmpty)
              SizedBox(
                  height: Resizable.size(context,250),
                  child: ListView.builder(
                    itemCount: reportModel.images.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 5)),
                    itemBuilder: (_, i) => Padding(
                        padding: EdgeInsets.only(
                            right: Resizable.padding(context, 10)),
                        child:
                        ClipRRect(
                          key: Key(reportModel.id.toString()),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 10)),
                          child: cubit
                              .checkIsUrl(reportModel.images[i])
                              ? ImageNetwork(
                            fitWeb: BoxFitWeb.fill,
                            image: reportModel.images[i],
                            height: Resizable.size(context, 250),
                            width: Resizable.size(context, 200),
                          )
                              : Image.memory(reportModel.images[i],
                              height: Resizable.size(context, 250),
                              width: Resizable.size(context, 200),
                              fit: BoxFit.fill),
                        )),
                  ))
          ],
        ));
  }
}
