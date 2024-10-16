import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'meeting_item_list.dart';
import 'meeting_items_cubit.dart';

class MeetingItemDialog extends StatelessWidget {
  MeetingItemDialog({super.key}) : cubit = MeetingItemsCubit();
  final MeetingItemsCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingItemsCubit, int>(
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
                                    child: MeetingItemList(cubit: cubit)),
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
                                                          enabled: cubit.isEdit,
                                                          onChange:
                                                              (String? value) {
                                                            cubit.updateItem(cubit
                                                                .procedureNow!
                                                                .copyWith(
                                                                    title:
                                                                        value));
                                                          },
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
                                                        child: HtmlEditor(
                                                          key: Key("${cubit.index
                                                              .toString()} + ${cubit.isEdit}"),
                                                          controller:
                                                              cubit.contentCon[
                                                                  cubit.index],
                                                          otherOptions: OtherOptions(
                                                            height: Resizable.size(
                                                                context, 340),
                                                          ),
                                                          htmlEditorOptions:
                                                              HtmlEditorOptions(
                                                                disabled: !cubit.isEdit,
                                                            hint:
                                                                'Your text here...',
                                                            initialText: cubit
                                                                        .procedureNow ==
                                                                    null
                                                                ? ""
                                                                : cubit
                                                                    .procedureNow!
                                                                    .content,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: Resizable.padding(
                                                          context,
                                                          10)),
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
                                                              onPressed: () async {
                                                                if (cubit
                                                                    .isEdit) {
                                                                  var content = await cubit.contentCon[cubit.index].getText();
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
                                                                      content:content,
                                                                      files: [],
                                                                      type:
                                                                          'meeting',
                                                                      status:
                                                                          true, isProgress: false);

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
