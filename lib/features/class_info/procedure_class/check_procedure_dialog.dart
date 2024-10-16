import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'check_procedure_cubit.dart';

class CheckProcedureDialog extends StatelessWidget {
  CheckProcedureDialog(
      {super.key, required this.type, required this.procedureClassCubit})
      : cubit = CheckProcedureCubit();

  final CheckProcedureCubit cubit;

  final ProcedureClassCubit procedureClassCubit;

  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckProcedureCubit, int>(
        bloc: cubit..init(procedureClassCubit.getProcedureClass(), type),
        builder: (c, s) {
          return cubit.listProcedure == null
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Resizable.padding(context, 0)),
                                  child: Column(
                                    children: [
                                      ...List.generate(
                                          cubit.listProcedure!.length,
                                          (index) => BlocProvider(
                                              key: Key(
                                                  "${cubit.listProcedure![index].id}"),
                                              create: (c) => CheckBoxCubit()
                                                ..load(cubit.listChoose
                                                    .contains(
                                                        cubit.listProcedure![
                                                            index])),
                                              child: BlocBuilder<CheckBoxCubit,
                                                  bool?>(
                                                builder: (cc, state) =>
                                                    CheckboxListTile(
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: Resizable
                                                                    .padding(
                                                                        context,
                                                                        30)),
                                                        controlAffinity:
                                                            ListTileControlAffinity
                                                                .leading,
                                                        value: state ?? false,
                                                        onChanged: (v) {
                                                          if (v! == true) {
                                                            cubit.choose(cubit
                                                                    .listProcedure![
                                                                index]);
                                                          } else {
                                                            cubit.remove(cubit
                                                                    .listProcedure![
                                                                index]);
                                                          }
                                                          BlocProvider.of<
                                                                  CheckBoxCubit>(cc)
                                                              .update(v);
                                                        },
                                                        title: Text(
                                                            "${cubit.listProcedure![index].title}\n${cubit.listProcedure![index].des}")),
                                              ))),
                                      SizedBox(
                                          height: Resizable.size(context, 50))
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                minWidth: Resizable.size(
                                                    context, 100)),
                                            margin: EdgeInsets.only(
                                                right: Resizable.padding(
                                                    context, 20)),
                                            child: DialogButton(
                                                AppText.txtOK.text
                                                    .toUpperCase(),
                                                onPressed: () {
                                              Navigator.pop(context);
                                              waitingDialog(context);
                                              for (var i in cubit.listChoose) {

                                                List<Map> info = [];

                                                for(var j in i.items){
                                                  info.add({
                                                    'item_id' : j,
                                                    'progress': 0,
                                                    'check' : false
                                                  });
                                                }

                                                ProcedureClassModel
                                                    procedureClass =
                                                    ProcedureClassModel(
                                                        id: DateTime.now().millisecondsSinceEpoch + i.id,
                                                        procedureId:
                                                            i.id,
                                                        info: info,
                                                        type: type,
                                                        classId: procedureClassCubit.classId);

                                                procedureClassCubit.addNewProcedureClass(procedureClass);
                                              }
                                              procedureClassCubit.emitState();
                                              Navigator.pop(context);
                                            }),
                                          )
                                        ],
                                      )
                                    ],
                                  )))
                        ],
                      )));
        });
  }
}
