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
                Text(AppText.txtAddReportImage.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: const Color(0xff757575))),
                SizedBox(height: Resizable.padding(context, 5)),
                if (cubit.listPickerImage.isNotEmpty)
                  SizedBox(
                      height: Resizable.size(context, 250),
                      child: ListView.builder(
                        itemCount: cubit.listPickerImage.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 5)),
                        itemBuilder: (_, i) => Padding(
                            padding: EdgeInsets.only(
                                right: Resizable.padding(context, 10)),
                            child:
                                Stack(alignment: Alignment.topRight, children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 10)),
                                child: cubit
                                        .checkIsUrl(cubit.listPickerImage[i])
                                    ? Image.network(
                                        fit: BoxFit.fill,
                                        '${cubit.listPickerImage[i]}',
                                        height: Resizable.size(context, 250),
                                        width: Resizable.size(context, 200),
                                        errorBuilder: (_, __, ___) =>
                                            Container(),
                                      )
                                    : Image.memory(cubit.listPickerImage[i],
                                        height: Resizable.size(context, 250),
                                        width: Resizable.size(context, 200),
                                        fit: BoxFit.fill),
                              ),
                              Container(
                                  height: Resizable.size(context, 20),
                                  width: Resizable.size(context, 25),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            Resizable.size(context, 10)),
                                        bottomLeft: Radius.circular(
                                            Resizable.size(context, 10))),
                                  ),
                                  child: GestureDetector(
                                      onTap: () async {
                                        cubit.removeImage(
                                            cubit.listPickerImage[i]);
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: Resizable.size(context, 18),
                                        color: Colors.white,
                                      )))
                            ])),
                      )),
                DottedBorderButton(AppText.txtAddImage.text,
                    onPressed: () async {
                  await cubit.pickImage();
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
              Text(AppText.txtClassType.text,
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
