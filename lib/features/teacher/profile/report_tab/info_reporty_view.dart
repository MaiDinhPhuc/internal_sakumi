import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'add_new_report_dialog_cubit.dart';

class ReportInfoView extends StatelessWidget {
  const ReportInfoView(
      {super.key, required this.cubit, this.reportModel, required this.isEdit});
  final AddNewReportCubit cubit;
  final ReportModel? reportModel;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtTitleReport.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: const Color(0xff757575))),
                InputField(
                    controller: cubit.titleCon,
                    errorText: AppText.txtPleaseInputReportTitle.text)
              ],
            ),
          )),
      Padding(
          padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtContentReport.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: const Color(0xff757575))),
                InputField(
                    controller: cubit.contentCon,
                    errorText: AppText.txtPleaseInputReportContent.text,
                    isExpand: true)
              ],
            ),
          )),
      Padding(
          padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtFiles.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: const Color(0xff757575))),
                SizedBox(height: Resizable.padding(context, 5)),
                if (cubit.listPickerFiles.isNotEmpty)
                  SizedBox(
                      height: Resizable.size(context, 50),
                      child: ListView.builder(
                        itemCount: cubit.listPickerFiles.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 5)),
                        itemBuilder: (_, i) => Padding(
                            padding: EdgeInsets.only(
                                right: Resizable.padding(context, 10)),
                            child:
                                Container(
                                    padding: EdgeInsets.all(Resizable.size(context, 3)),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                    children: [
                                      Text(cubit.listPickerFiles[i]['file_name'], style: TextStyle(fontSize: Resizable.size(context, 14), color: primaryColor)),
                                      SizedBox(width: Resizable.size(context, 5)),
                                      InkWell(
                                          radius:10,
                                          onTap: () async {
                                            cubit.removeFile(
                                                cubit.listPickerFiles[i]);
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: Resizable.size(context, 14),
                                            color: primaryColor,
                                          ))
                                    ]
                                ))),
                      )),
                DottedBorderButton(AppText.txtAddFiles.text,
                    onPressed: () async {
                  await cubit.pickFiles();
                })
              ],
            ),
          )),
      Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.titleStatus.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: const Color(0xff757575))),
              InputDropdown(
                  hint: cubit.findReportStatus(),
                  onChanged: (v) {
                    cubit.chooseStatus(v!);
                  },
                  items: List.generate(cubit.listStatus.length,
                          (index) => (cubit.listStatus[index])).toList())
            ],
          )),
          SizedBox(width: Resizable.padding(context, 10)),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.txtRange.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 18),
                          color: const Color(0xff757575))),
                  InputDropdown(
                      hint: cubit.findReportRange(),
                      onChanged: (v) {
                        cubit.chooseRange(v!);
                      },
                      items: List.generate(cubit.listRange.length,
                              (index) => (cubit.listRange[index])).toList())
                ],
              ))
        ],
      ),
      Padding(
          padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtCreatorReport.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: const Color(0xff757575))),
                InputField(
                    controller: cubit.creatorCon,
                    errorText: AppText.txtPleaseInputReportCreator.text)
              ],
            ),
          ))
    ]));
  }
}
