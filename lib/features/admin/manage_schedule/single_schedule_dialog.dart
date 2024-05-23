import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_single_schedule_cubit.dart';
import 'info_single_schedule_view.dart';
import 'manage_schedule_cubit.dart';

class SingleScheduleDialog extends StatelessWidget {
  SingleScheduleDialog({super.key, this.schedule, required this.cubit}) : addCubit = AddSingleScheduleCubit(schedule);
  final ManageScheduleCubit cubit;
  final AddSingleScheduleCubit addCubit;
  final ScheduleModel? schedule;

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
                            child: InfoSingleScheduleView(addCubit: addCubit)),
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
                                             if(addCubit.date == null ){
                                                notificationDialog(
                                                    context,
                                                    AppText
                                                        .txtNoChooseDate.text);
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
                                                      .addNewSingleSchedule(
                                                      cubit);
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

class ChangeTeacherScheduleDialog extends StatelessWidget {
  ChangeTeacherScheduleDialog({super.key, this.schedule, required this.cubit, required this.date, required this.classId, required this.oldTeacherId}) : addCubit = AddSingleScheduleCubit(schedule);
  final ManageScheduleCubit cubit;
  final AddSingleScheduleCubit addCubit;
  final ScheduleModel? schedule;
  final DateTime date;
  final int classId, oldTeacherId;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSingleScheduleCubit, int>(
        bloc: addCubit..changeTeacherLoad(classId, date),
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
                            child: InfoChangeTeacherScheduleView(addCubit: addCubit)),
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
                                              if(addCubit.date == null ){
                                                notificationDialog(
                                                    context,
                                                    AppText
                                                        .txtNoChooseDate.text);
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
                                                      .addNewSingleSchedule(
                                                      cubit);
                                                  ScheduleModel newSchedule = ScheduleModel(
                                                      id: DateTime.now().millisecondsSinceEpoch,
                                                      teacherId: oldTeacherId,
                                                      status: "teacher_off",
                                                      classId: classId,
                                                      type: "single",
                                                      date: date.millisecondsSinceEpoch,
                                                      calendar: {},
                                                      startDate: 0,
                                                      endDate: 0,
                                                      time: "");

                                                  await FireBaseProvider.instance.addNewSchedule(newSchedule);
                                                  await cubit.addSchedule(newSchedule);
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
