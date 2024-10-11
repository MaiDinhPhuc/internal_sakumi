import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/check_item_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_dialog_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_item_in_dialog.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'manage_procedure_cubit.dart';

class ProcedureDialog extends StatelessWidget {
  ProcedureDialog({super.key, required this.cubit, this.procedureModel})
      : dialogCubit = ProcedureDialogCubit();
  final ManageProcedureCubit cubit;
  final ProcedureModel? procedureModel;
  final ProcedureDialogCubit dialogCubit;
  @override
  Widget build(BuildContext context) {
    TextEditingController titleCon = TextEditingController(
        text: procedureModel == null ? "" : procedureModel!.title);
    TextEditingController desCon = TextEditingController(
        text: procedureModel == null ? "" : procedureModel!.des);
    return BlocBuilder<ProcedureDialogCubit, int>(
        bloc: dialogCubit..init(procedureModel),
        builder: (c, s) {
          return s == 0
              ? const WaitingAlert()
              : Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
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
                                procedureModel != null
                                    ? "Chỉnh sửa quy trình".toUpperCase()
                                    : "Thêm quy trình".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            )),
                        Expanded(
                            flex: 10,
                            child: SingleChildScrollView(
                                child: Column(children: [
                              InputItem(
                                  onChange: (String? value) {
                                    debugPrint(value);
                                  },
                                  controller: titleCon,
                                  title: AppText.txtTitle.text,
                                  isExpand: false),
                              InputItem(
                                  onChange: (String? value) {
                                    debugPrint(value);
                                  },
                                  controller: desCon,
                                  title: AppText.txtDescription.text,
                                  isExpand: true),
                              ...dialogCubit.listChooseItem
                                  .map((e) => ProcedureItemInDialog(
                                        item: e,
                                        onRemove: () {
                                          dialogCubit.removeItem(e);
                                        },
                                      )),
                              DottedBorderButton("+ thêm item".toUpperCase(),
                                  isManageGeneral: true, onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return CheckItemDialog(
                                          dialogCubit: dialogCubit,
                                          type: cubit.statusNow);
                                    });
                              })
                            ]))),
                        Expanded(
                            flex: 1,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.padding(context, 20)),
                                child: Row(
                                  mainAxisAlignment: procedureModel != null
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                                  children: [
                                    if (procedureModel != null)
                                      DeleteButton(
                                          onPressed: () async {
                                            ProcedureModel procedure =
                                                ProcedureModel(
                                                    id: procedureModel!.id,
                                                    des: desCon.text,
                                                    title: titleCon.text,
                                                    items: dialogCubit
                                                        .listChooseItem
                                                        .map((e) => e.id)
                                                        .toList(),
                                                    type: cubit.statusNow,
                                                    status: false);
                                            await cubit
                                                .removeProcedure(procedure);
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          title: AppText.btnRemove.text),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minWidth:
                                                  Resizable.size(context, 100)),
                                          margin: EdgeInsets.only(
                                              right: Resizable.padding(
                                                  context, 10)),
                                          child: DialogButton(
                                              AppText.textCancel.text
                                                  .toUpperCase(),
                                              onPressed: () =>
                                                  Navigator.pop(context)),
                                        ),
                                        AddNewLessonButton(() {
                                          if (titleCon.text.isEmpty) {
                                            notificationDialog(context,
                                                "Tiêu đề không được trống!");
                                          } else {
                                            ProcedureModel procedure =
                                                ProcedureModel(
                                                    id: procedureModel == null
                                                        ? DateTime.now()
                                                            .millisecondsSinceEpoch
                                                        : procedureModel!.id,
                                                    des: desCon.text,
                                                    title: titleCon.text,
                                                    items: dialogCubit
                                                        .listChooseItem
                                                        .map((e) => e.id)
                                                        .toList(),
                                                    type: cubit.statusNow,
                                                    status: true);
                                            if (procedureModel == null) {
                                              cubit.addProcedure(procedure);
                                            } else {
                                              cubit.updateProcedure(procedure);
                                            }
                                            Navigator.of(context).pop();
                                          }
                                        }, procedureModel != null)
                                      ],
                                    )
                                  ],
                                )))
                      ],
                    ),
                  ));
        });
  }
}
