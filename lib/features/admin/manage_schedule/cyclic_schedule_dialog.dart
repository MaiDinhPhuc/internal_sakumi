import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import '../../../widget/submit_button.dart';
import 'add_cyclic_schedule_cubit.dart';
import 'info_cyclic_schedule_view.dart';
import 'manage_schedule_cubit.dart';

class CyclicScheduleDialog extends StatelessWidget {
  CyclicScheduleDialog({super.key, required this.cubit, this.schedule})
      : addCubit = AddCyclicScheduleCubit(schedule);

  final AddCyclicScheduleCubit addCubit;
  final ManageScheduleCubit cubit;
  final ScheduleModel? schedule;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCyclicScheduleCubit, int>(
        bloc: addCubit,
        builder: (c, s) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Form(
                  child: Container(
                width: MediaQuery.of(context).size.width / 2,
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
                            AppText.txtManageSchedule.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        )),
                    Expanded(
                        flex: 10,
                        child: InfoCyclicScheduleView(addCubit: addCubit)),
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
                                          if (addCubit.listCheckDay
                                              .every((e) => e == false)) {
                                            notificationDialog(
                                                context,
                                                AppText
                                                    .txtNoEmptyChooseDay.text);
                                          }else if(addCubit.startDate == null || addCubit.startDate == null){
                                            notificationDialog(
                                                context,
                                                AppText
                                                    .txtNoChooseStartAndEnd.text);
                                          }
                                          else if (addCubit.teacherId ==
                                              null) {
                                            notificationDialog(
                                                context,
                                                AppText
                                                    .txtNoChooseTeacher.text);
                                          } else if (addCubit.classId == null) {
                                            notificationDialog(context,
                                                AppText.txtNoChooseClass.text);
                                          } else {
                                            waitingDialog(context);
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              await addCubit
                                                  .addNewCyclicSchedule(
                                                  cubit);
                                              await cubit.getSchedule();
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (schedule != null) {
                                                  notificationDialog(
                                                      context,
                                                      AppText
                                                          .txtUpdateScheduleDone
                                                          .text);
                                                } else {
                                                  notificationDialog(
                                                      context,
                                                      AppText.txtAddScheduleDone
                                                          .text);
                                                }

                                              }
                                            }
                                            // await addCubit.checkSchedule();
                                            // if (addCubit.checkExistSchedule) {
                                            //
                                            // } else {
                                            //   if (context.mounted) {
                                            //     Navigator.pop(context);
                                            //     notificationDialog(
                                            //         context,
                                            //         AppText
                                            //             .txtScheduleExist
                                            //             .text);
                                            //   }
                                            // }
                                          }
                                        },
                                        title: schedule == null ?AppText.btnAdd.text : AppText.txtUpdate.text),
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

