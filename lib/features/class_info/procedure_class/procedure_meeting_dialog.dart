import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:html' as html;
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/meeting_item_list.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_meeting_dialog_cubit.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ProcedureMeetingDialog extends StatelessWidget {
  ProcedureMeetingDialog(
      {super.key,
      required this.procedureClassModel,
      required this.type,
      required this.procedureClassCubit,
      required this.itemCubit})
      : cubit = ProcedureMeetingDialogCubit(procedureClassCubit, itemCubit);
  final ProcedureMeetingDialogCubit cubit;
  final ProcedureClassModel procedureClassModel;
  final String type;
  final ProcedureClassCubit procedureClassCubit;
  final ProcedureClassItemCubit itemCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcedureMeetingDialogCubit, int>(
        bloc: cubit..init(procedureClassModel),
        builder: (c, s) {
          return s == 0
              ? const WaitingAlert()
              : Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(Resizable.padding(context, 15)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Resizable.padding(context, 7)),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Meeting Items".toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Icon(Icons.clear,
                                          size: Resizable.size(context, 28),
                                          color: primaryColor)),
                                )
                              ],
                            )),
                        SizedBox(height: Resizable.padding(context, 10)),
                        Expanded(
                            flex: 15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: MeetingItemListV2(
                                      cubit: cubit,
                                      type: type,
                                      isCustom: itemCubit.procedure!.isCustom,
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          cubit.procedureNow == null
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: Resizable.padding(
                                                          context, 10)),
                                                  padding: EdgeInsets.all(
                                                      Resizable.padding(
                                                          context, 10)),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffEEEEEE),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Resizable.padding(
                                                                  context, 5))),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: Resizable.padding(
                                                          context, 10)),
                                                  padding: EdgeInsets.all(
                                                      Resizable.padding(
                                                          context, 10)),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffEEEEEE),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Resizable.padding(
                                                                  context, 5))),
                                                  child: Column(
                                                    children: [
                                                      InputItem(
                                                          enabled: false,
                                                          controller: cubit
                                                                  .titleConList[
                                                              cubit.index],
                                                          title: AppText
                                                              .txtTitle.text,
                                                          isExpand: false),
                                                      InputItem(
                                                          enabled: false,
                                                          controller:
                                                              cubit.desConList[
                                                                  cubit.index],
                                                          title: AppText
                                                              .txtDescription
                                                              .text,
                                                          isExpand: true),
                                                      Container(
                                                        height: Resizable.size(
                                                            context, 340),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius
                                                                .circular(Resizable
                                                                    .padding(
                                                                        context,
                                                                        5))),
                                                        child: SingleChildScrollView(
                                                            child: Html(
                                                                data: cubit.procedureNow ==
                                                                    null ||
                                                                    cubit
                                                                        .procedureNow!.content.isEmpty
                                                                    ? "Không có nội dung"
                                                                    : cubit
                                                                    .procedureNow!
                                                                    .content,
                                                                onLinkTap:
                                                                    (url, _,
                                                                    __) {
                                                                  html.window.open(
                                                                      url!,
                                                                      '_blank');
                                                                })),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              Resizable.padding(
                                                                  context, 10)),
                                                    ],
                                                  ),
                                                )
                                        ],
                                      ),
                                    ))
                              ],
                            ))
                      ],
                    ),
                  ));
        });
  }
}
