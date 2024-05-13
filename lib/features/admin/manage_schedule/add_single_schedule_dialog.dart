import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_single_schedule_cubit.dart';
import 'info_add_single_schedule.dart';
import 'manage_schedule_cubit.dart';

class AddSingleScheduleDialog extends StatelessWidget {
  AddSingleScheduleDialog(
      {super.key,
      required this.cubit,
      required this.scheduleModel,
      required this.index,
      required this.info})
      : addCubit = AddSingleScheduleCubit();
  final ManageScheduleCubit cubit;
  final AddSingleScheduleCubit addCubit;
  final ScheduleModel scheduleModel;
  final int index;
  final String info;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSingleScheduleCubit, int>(
        bloc: addCubit,
        builder: (c, s) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Form(
                  child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 20)),
                          child: Text(
                            AppText.txtChangeTeacher.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        )),
                    Expanded(
                        flex: 7,
                        child: InfoAddSingleScheduleView(
                            addCubit: addCubit,
                            info:
                                "")),
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
                                        minWidth: Resizable.size(context, 100)),
                                    margin: EdgeInsets.only(
                                        right: Resizable.padding(context, 20)),
                                    child: DialogButton(
                                        AppText.textCancel.text.toUpperCase(),
                                        onPressed: () =>
                                            Navigator.pop(context)),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: Resizable.size(context, 100)),
                                    child: SubmitButton(
                                        onPressed: () async {

                                          if(addCubit.teacherId == null || addCubit.teacherId! == scheduleModel.teacherId){
                                              notificationDialog(
                                                  context, AppText.txtPleaseCheckTeacher.text);
                                          }else{
                                            // var newSchedule = ScheduleModel(
                                            //     id: DateTime.now().millisecondsSinceEpoch,
                                            //     teacherId: addCubit.teacherId!,
                                            //     status: 'teaching',
                                            //     classId: scheduleModel.classId,
                                            //     type: "single",
                                            //     startTime: scheduleModel.startTime,
                                            //     endTime: scheduleModel.endTime,
                                            //     role: [],
                                            //     date: cubit.listDate[index].millisecondsSinceEpoch);
                                            // Create.createSingleSchedule(newSchedule);
                                            // cubit.addSchedule(newSchedule);
                                            Navigator.pop(context);
                                          }
                                        },
                                        title: AppText.btnAdd.text),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              )));
        });
  }
}
