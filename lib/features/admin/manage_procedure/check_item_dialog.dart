import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_dialog_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_meeting_dialog_cubit.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class CheckItemDialog extends StatelessWidget {
  const CheckItemDialog({super.key, required this.dialogCubit, required this.type});
  final ProcedureDialogCubit dialogCubit;
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcedureDialogCubit, int>(
        bloc: dialogCubit..loadAllItem(type,[]),
        builder: (c, s) {
          return dialogCubit.listAllItem == null
              ? const WaitingAlert()
              : Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.4,
                padding: EdgeInsets.all(Resizable.padding(context, 15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 20)),
                          child: Text(
                             "Check Item".toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        )),
                    Expanded(
                        flex: 10,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 0)),
                            child: Column(
                              children: [
                                ...List.generate(
                                    dialogCubit.listAllItem!.length,
                                        (index) => BlocProvider(
                                        key: Key("${dialogCubit.listAllItem![index].id}"),
                                        create: (c) => CheckBoxCubit()
                                          ..load(dialogCubit.check(dialogCubit.listAllItem![index])),
                                        child: BlocBuilder<CheckBoxCubit, bool?>(
                                          builder: (cc, state) => CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: Resizable.padding(context, 30)),
                                              controlAffinity: ListTileControlAffinity.leading,
                                              value: state ?? false,
                                              onChanged: (v) {
                                                if (v! == true) {
                                                  dialogCubit
                                                      .addItem(dialogCubit.listAllItem![index]);
                                                } else {
                                                  dialogCubit.removeItem(dialogCubit.listAllItem![index]);
                                                }
                                                BlocProvider.of<CheckBoxCubit>(cc).update(v);
                                              },
                                              title: Text(
                                                  "${dialogCubit.listAllItem![index].title}\n${dialogCubit.listAllItem![index].des}")),
                                        ))),
                                SizedBox(height: Resizable.size(context, 50))
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: Resizable.padding(context, 20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                          Resizable.size(context, 100)),
                                      margin: EdgeInsets.only(
                                          right: Resizable.padding(
                                              context, 20)),
                                      child: DialogButton(
                                          AppText.txtOK.text
                                              .toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    )
                                  ],
                                )
                              ],
                            )))
                  ],
                )
              ));
        });
  }
}


class CheckItemMeetingDialog extends StatelessWidget {
  const CheckItemMeetingDialog({super.key, required this.type, required this.cubit, required this.list});
  final String type;
  final ProcedureMeetingDialogCubit cubit;
  final List<ProcedureItemModel> list;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>ProcedureDialogCubit()..loadAllItem(type, list),child: BlocBuilder<ProcedureDialogCubit, int>(
        builder: (c, s) {
          var dialogCubit = BlocProvider.of<ProcedureDialogCubit>(c);
          return dialogCubit.listAllItem == null
              ? const WaitingAlert()
              : Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Container(
                  width: MediaQuery.of(context).size.width / 2.4,
                  padding: EdgeInsets.all(Resizable.padding(context, 15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20)),
                            child: Text(
                              "Check Item".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          )),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 0)),
                              child: Column(
                                children: [
                                  ...List.generate(
                                      dialogCubit.listAllItem!.length,
                                          (index) => BlocProvider(
                                          key: Key("${dialogCubit.listAllItem![index].id}"),
                                          create: (c) => CheckBoxCubit()
                                            ..load(dialogCubit.check(dialogCubit.listAllItem![index])),
                                          child: BlocBuilder<CheckBoxCubit, bool?>(
                                            builder: (cc, state) => CheckboxListTile(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: Resizable.padding(context, 30)),
                                                controlAffinity: ListTileControlAffinity.leading,
                                                value: state ?? false,
                                                onChanged: (v) {
                                                  if (v! == true) {
                                                    dialogCubit
                                                        .addItem(dialogCubit.listAllItem![index]);
                                                  } else {
                                                    dialogCubit.removeItem(dialogCubit.listAllItem![index]);
                                                  }
                                                  BlocProvider.of<CheckBoxCubit>(cc).update(v);
                                                },
                                                title: Text(
                                                    "${dialogCubit.listAllItem![index].title}\n${dialogCubit.listAllItem![index].des}")),
                                          ))),
                                  SizedBox(height: Resizable.size(context, 50))
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                            Resizable.size(context, 100)),
                                        margin: EdgeInsets.only(
                                            right: Resizable.padding(
                                                context, 20)),
                                        child: DialogButton(
                                            AppText.txtOK.text
                                                .toUpperCase(),
                                            onPressed: () {
                                              cubit.addItem(dialogCubit.listChooseItem);
                                              Navigator.pop(context);
                                            }),
                                      )
                                    ],
                                  )
                                ],
                              )))
                    ],
                  )
              ));
        }),);
  }
}