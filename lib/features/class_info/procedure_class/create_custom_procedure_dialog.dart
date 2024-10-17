import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/check_item_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_dialog_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_item_in_dialog.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class CreateCustomProcedureDialog extends StatelessWidget {
  CreateCustomProcedureDialog({super.key, required this.procedureClassCubit, required this.type}) : dialogCubit = ProcedureDialogCubit();
  final ProcedureClassCubit procedureClassCubit;
  final ProcedureDialogCubit dialogCubit;
  final String type;
  @override
  Widget build(BuildContext context) {
    TextEditingController titleCon = TextEditingController(
        text: "");
    TextEditingController desCon = TextEditingController(
        text: "");
    return BlocBuilder<ProcedureDialogCubit, int>(
        bloc: dialogCubit..loadAllItem(type, []),
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
                             "Thêm quy trình".toUpperCase(),
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
                                              type: type);
                                        });
                                  })
                            ]))),
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
                                              context, 10)),
                                      child: DialogButton(
                                          AppText.textCancel.text
                                              .toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    ),
                                    AddNewLessonButton(() async {
                                      if (titleCon.text.isEmpty) {
                                        notificationDialog(context,
                                            "Tiêu đề không được trống!");
                                      } else {


                                        waitingDialog(context);
                                        var id = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        ProcedureModel procedure =
                                        ProcedureModel(
                                            id:  id,
                                            des: desCon.text,
                                            title: titleCon.text,
                                            items: dialogCubit
                                                .listChooseItem
                                                .map((e) => e.id)
                                                .toList(),
                                            type: type,
                                            status: true,
                                            isCustom: true);
                                        await FireBaseProvider.instance.addNewProcedure(procedure);
                                        List<Map> info = [];
                                        for (var i in dialogCubit
                                            .listChooseItem
                                            .map((e) => e.id)
                                            .toList()) {
                                          info.add({
                                            'item_id' : i,
                                            'progress': 0,
                                            'check' : false
                                          });
                                        }
                                        ProcedureClassModel
                                        procedureClass =
                                        ProcedureClassModel(
                                            id: id + 1000,
                                            procedureId: id,
                                            info: info,
                                            type: type,
                                            classId: procedureClassCubit.classId, report: '');

                                        procedureClassCubit.addNewProcedureClass(procedureClass);

                                        procedureClassCubit.emitState();
                                        if(context.mounted){
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        }

                                      }
                                    }, false)
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
