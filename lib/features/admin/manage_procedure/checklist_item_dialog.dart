import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'checklist_item_list.dart';
import 'checklist_items_cubit.dart';

class ChecklistItemDialog extends StatelessWidget {
  ChecklistItemDialog({super.key}) : cubit = CheckListItemsCubit();

  final CheckListItemsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckListItemsCubit, int>(
        bloc: cubit..init(),
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
                                    "Checklist Items".toUpperCase(),
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
                                    flex: 1,
                                    child: ChecklistItemList(cubit: cubit)),
                                Expanded(
                                    flex: 2,
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InputItem(
                                                          enabled: cubit.isEdit,
                                                          controller: cubit
                                                                  .titleConList[
                                                              cubit.index],
                                                          title: AppText
                                                              .txtTitle.text,
                                                          isExpand: false),
                                                      InputItem(
                                                          enabled: cubit.isEdit,
                                                          controller:
                                                              cubit.desConList[
                                                                  cubit.index],
                                                          title: AppText
                                                              .txtDescription
                                                              .text,
                                                          isExpand: true),
                                                      SizedBox(
                                                          width: Resizable.size(
                                                              context, 180),
                                                          child:
                                                              CheckboxListTile(
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                            title: Text(
                                                                "Thanh tiến trình",
                                                                style: TextStyle(
                                                                    fontSize: Resizable.font(
                                                                        context,
                                                                        20))),
                                                            value: cubit
                                                                .checkList[cubit.index],
                                                            onChanged:
                                                                (newValue) {
                                                              if(cubit.isEdit){
                                                                cubit.checkInProgress(newValue!);
                                                              }
                                                            },
                                                          )),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          if (cubit.isEdit)
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  minWidth:
                                                                      Resizable.size(
                                                                          context,
                                                                          100)),
                                                              margin: EdgeInsets.only(
                                                                  right: Resizable
                                                                      .padding(
                                                                          context,
                                                                          10)),
                                                              child: DialogButton(
                                                                  AppText
                                                                      .textCancel
                                                                      .text
                                                                      .toUpperCase(),
                                                                  onPressed:
                                                                      () => cubit
                                                                          .openEdit()),
                                                            ),
                                                          SubmitButton(
                                                              onPressed: () {
                                                                if (cubit
                                                                    .isEdit) {
                                                                  ProcedureItemModel newItem = ProcedureItemModel(
                                                                      id: cubit
                                                                          .procedureNow!
                                                                          .id,
                                                                      title: cubit
                                                                          .titleConList[cubit
                                                                              .index]
                                                                          .text,
                                                                      des: cubit
                                                                          .desConList[cubit
                                                                              .index]
                                                                          .text,
                                                                      content:
                                                                          '',
                                                                      files: [],
                                                                      type:
                                                                          'checklist',
                                                                      status:
                                                                          true,
                                                                      isProgress:
                                                                      cubit
                                                                          .checkList[cubit
                                                                          .index]);

                                                                  cubit.updateDataToFb(
                                                                      newItem);
                                                                } else {
                                                                  cubit
                                                                      .openEdit();
                                                                }
                                                              },
                                                              title: cubit
                                                                      .isEdit
                                                                  ? AppText
                                                                      .btnUpdate
                                                                      .text
                                                                  : AppText
                                                                      .txtEdit
                                                                      .text)
                                                        ],
                                                      )
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
