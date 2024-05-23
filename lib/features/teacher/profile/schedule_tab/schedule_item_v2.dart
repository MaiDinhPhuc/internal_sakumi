import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/CRUD/delete_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/confirm_delete_schedule.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/cyclic_schedule_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/manage_schedule_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/single_schedule_dialog.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CyclicScheduleItem extends StatelessWidget {
  const CyclicScheduleItem(
      {super.key,
      required this.cubit,
      required this.scheduleModel,
      required this.index});
  final ManageScheduleCubit cubit;
  final ScheduleModel scheduleModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return scheduleModel.status != "cancel"
        ? PopupMenuButton(
            itemBuilder: (context) => [
                  ...cubit.listCyclicMenu.map((e) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: InkWell(
                        onTap: () {
                          if (e == "Huỷ lịch dạy") {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ConfirmDeleteSchedule(onPress: () {
                                    cubit.removeSchedule(scheduleModel);
                                    Delete.cancelSchedule(scheduleModel);
                                    Navigator.of(context).pop();
                                  });
                                });
                          }
                          if (e == "Chỉnh sửa") {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (context) => CyclicScheduleDialog(
                                    cubit: cubit, schedule: scheduleModel));
                          }
                          if (e == "Đổi giáo viên") {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    ChangeTeacherScheduleDialog(
                                      cubit: cubit,
                                      date: cubit.listDate[index],
                                      classId: scheduleModel.classId, oldTeacherId: scheduleModel.teacherId,
                                    ));
                          }
                          if (e == "Học viên nghỉ") {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ConfirmDeleteSchedule(
                                      onPress: () async {
                                    var newSchedule = ScheduleModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        teacherId: scheduleModel.teacherId,
                                        status: "student_drop",
                                        classId: scheduleModel.classId,
                                        type: "single",
                                        calendar: {},
                                        date: cubit.listDate[index]
                                            .millisecondsSinceEpoch,
                                        time: "",
                                        startDate: 0,
                                        endDate: 0);
                                    cubit.addSchedule(newSchedule);
                                    Navigator.of(context).pop();
                                    await FireBaseProvider.instance
                                        .addNewSchedule(newSchedule);
                                  });
                                });
                          }
                          if (e == "Lớp học nghỉ") {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ConfirmDeleteSchedule(
                                      onPress: () async {
                                    var newSchedule = ScheduleModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        teacherId: scheduleModel.teacherId,
                                        status: "class_drop",
                                        classId: scheduleModel.classId,
                                        type: "single",
                                        calendar: {},
                                        date: cubit.listDate[index]
                                            .millisecondsSinceEpoch,
                                        time: "",
                                        startDate: 0,
                                        endDate: 0);
                                    cubit.addSchedule(newSchedule);
                                    Navigator.of(context).pop();
                                    await FireBaseProvider.instance
                                        .addNewSchedule(newSchedule);
                                  });
                                });
                          }
                        },
                        child: Container(
                            height: Resizable.size(context, 33),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(e,
                                      style: TextStyle(
                                          fontWeight: e == "Huỷ lịch dạy"
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: Resizable.font(context, 15),
                                          color: e == "Huỷ lịch dạy"
                                              ? Colors.red
                                              : Colors.black)),
                                ],
                              ),
                            )),
                      )))
                ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Resizable.size(context, 10)),
              ),
            ),
            child: Container(
                width: Resizable.size(context, 130),
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 5),
                    vertical: Resizable.padding(context, 3)),
                decoration: BoxDecoration(
                    color: const Color(0xffE3F2FD),
                    border: Border.all(
                        width: Resizable.size(context, 1),
                        color: const Color(0xff90CAF9)),
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5),
                          vertical: Resizable.padding(context, 2)),
                      decoration: BoxDecoration(
                          color: const Color(0xff90CAF9),
                          border: Border.all(
                              width: Resizable.size(context, 1),
                              color: const Color(0xff90CAF9)),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 15))),
                      child: Text(
                        textAlign: TextAlign.center,
                        cubit.getCyclicTime(index, scheduleModel),
                        style: TextStyle(
                            color: const Color(0xff0D47A1),
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                      textAlign: TextAlign.center,
                      cubit.getClassCode(scheduleModel.classId).toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Resizable.font(context, 20),
                          fontWeight: FontWeight.w600),
                    ))),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 5),
                              vertical: Resizable.padding(context, 2)),
                          decoration: BoxDecoration(
                              color: const Color(0xff90CAF9),
                              border: Border.all(
                                  width: Resizable.size(context, 1),
                                  color: const Color(0xff90CAF9)),
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 15))),
                          child: Text(
                            textAlign: TextAlign.center,
                            cubit.getTeacherName(scheduleModel.teacherId),
                            style: TextStyle(
                                color: const Color(0xff0D47A1),
                                fontSize: Resizable.font(context, 16),
                                fontWeight: FontWeight.w700),
                          ),
                        ))
                      ],
                    )
                  ],
                )))
        : Container(
            width: Resizable.size(context, 130),
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 5),
                vertical: Resizable.padding(context, 3)),
            decoration: BoxDecoration(
                color: const Color(0xffFDE3E3),
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: const Color(0xffFBBBBB)),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 5),
                      vertical: Resizable.padding(context, 2)),
                  decoration: BoxDecoration(
                      color: const Color(0xffFBBBBB),
                      border: Border.all(
                          width: Resizable.size(context, 1),
                          color: const Color(0xffFBBBBB)),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 15))),
                  child: Text(
                    textAlign: TextAlign.center,
                    cubit.getCyclicTime(index, scheduleModel),
                    style: TextStyle(
                        color: const Color(0xffA10D0D),
                        fontSize: Resizable.font(context, 16),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  textAlign: TextAlign.center,
                  cubit.getClassCode(scheduleModel.classId).toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w600),
                ))),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5),
                          vertical: Resizable.padding(context, 2)),
                      decoration: BoxDecoration(
                          color: const Color(0xffFBBBBB),
                          border: Border.all(
                              width: Resizable.size(context, 1),
                              color: const Color(0xffFBBBBB)),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 15))),
                      child: Text(
                        textAlign: TextAlign.center,
                        cubit.getTeacherName(scheduleModel.teacherId),
                        style: TextStyle(
                            color: const Color(0xffA10D0D),
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w700),
                      ),
                    ))
                  ],
                )
              ],
            ));
  }
}

class SingleScheduleItem extends StatelessWidget {
  const SingleScheduleItem(
      {super.key,
      required this.cubit,
      required this.scheduleModel,
      required this.index});
  final ManageScheduleCubit cubit;
  final ScheduleModel scheduleModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return scheduleModel.status == "cancel"
        ? Container(
            width: Resizable.size(context, 130),
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 5),
                vertical: Resizable.padding(context, 3)),
            decoration: BoxDecoration(
                color: cubit.getSingleLightColor(scheduleModel),
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: cubit.getSingleMediumColor(scheduleModel)),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 5),
                      vertical: Resizable.padding(context, 2)),
                  decoration: BoxDecoration(
                      color: cubit.getSingleMediumColor(scheduleModel),
                      border: Border.all(
                          width: Resizable.size(context, 1),
                          color: cubit.getSingleMediumColor(scheduleModel)),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 15))),
                  child: Text(
                    textAlign: TextAlign.center,
                    cubit.getSingleTime(scheduleModel),
                    style: TextStyle(
                        color: cubit.getSingleDarkColor(scheduleModel),
                        fontSize: Resizable.font(context, 16),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  textAlign: TextAlign.center,
                  cubit.getClassCode(scheduleModel.classId).toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w600),
                ))),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5),
                          vertical: Resizable.padding(context, 2)),
                      decoration: BoxDecoration(
                          color: cubit.getSingleMediumColor(scheduleModel),
                          border: Border.all(
                              width: Resizable.size(context, 1),
                              color: cubit.getSingleMediumColor(scheduleModel)),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 15))),
                      child: Text(
                        textAlign: TextAlign.center,
                        cubit.getTeacherName(scheduleModel.teacherId),
                        style: TextStyle(
                            color: cubit.getSingleDarkColor(scheduleModel),
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w700),
                      ),
                    ))
                  ],
                )
              ],
            ))
        : PopupMenuButton(
            itemBuilder: (context) => scheduleModel.status == "cancel"
                ? [
                    ...cubit.listSingleMenu.map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () {
                            if (e == "Huỷ lịch dạy") {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ConfirmDeleteSchedule(onPress: () {
                                      cubit.removeSchedule(scheduleModel);
                                      Delete.cancelSchedule(scheduleModel);
                                      Navigator.of(context).pop();
                                    });
                                  });
                            }
                            if (e == "Chỉnh sửa") {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) => SingleScheduleDialog(
                                      cubit: cubit, schedule: scheduleModel));
                            }
                          },
                          child: Container(
                              height: Resizable.size(context, 33),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e,
                                        style: TextStyle(
                                            fontWeight: e == "Chỉnh sửa"
                                                ? FontWeight.w500
                                                : FontWeight.w700,
                                            fontSize:
                                                Resizable.font(context, 15),
                                            color: e == "Huỷ lịch dạy"
                                                ? Colors.red
                                                : Colors.black)),
                                  ],
                                ),
                              )),
                        )))
                  ]
                : [
                    PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ConfirmDeleteSchedule(onPress: () {
                                    cubit.removeSchedule(scheduleModel);
                                    Delete.cancelSchedule(scheduleModel);
                                    Navigator.of(context).pop();
                                  });
                                });
                          },
                          child: Container(
                              height: Resizable.size(context, 33),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Huỷ lịch dạy",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                Resizable.font(context, 15),
                                            color: Colors.red)),
                                  ],
                                ),
                              )),
                        ))
                  ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Resizable.size(context, 10)),
              ),
            ),
            child: Container(
                width: Resizable.size(context, 130),
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 5),
                    vertical: Resizable.padding(context, 3)),
                decoration: BoxDecoration(
                    color: cubit.getSingleLightColor(scheduleModel),
                    border: Border.all(
                        width: Resizable.size(context, 1),
                        color: cubit.getSingleMediumColor(scheduleModel)),
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5),
                          vertical: Resizable.padding(context, 2)),
                      decoration: BoxDecoration(
                          color: cubit.getSingleMediumColor(scheduleModel),
                          border: Border.all(
                              width: Resizable.size(context, 1),
                              color: cubit.getSingleMediumColor(scheduleModel)),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 15))),
                      child: Text(
                        textAlign: TextAlign.center,
                        cubit.getSingleTime(scheduleModel),
                        style: TextStyle(
                            color: cubit.getSingleDarkColor(scheduleModel),
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                      textAlign: TextAlign.center,
                      cubit.getClassCode(scheduleModel.classId).toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Resizable.font(context, 20),
                          fontWeight: FontWeight.w600),
                    ))),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 5),
                              vertical: Resizable.padding(context, 2)),
                          decoration: BoxDecoration(
                              color: cubit.getSingleMediumColor(scheduleModel),
                              border: Border.all(
                                  width: Resizable.size(context, 1),
                                  color: cubit
                                      .getSingleMediumColor(scheduleModel)),
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 15))),
                          child: Text(
                            textAlign: TextAlign.center,
                            cubit.getTeacherName(scheduleModel.teacherId),
                            style: TextStyle(
                                color: cubit.getSingleDarkColor(scheduleModel),
                                fontSize: Resizable.font(context, 16),
                                fontWeight: FontWeight.w700),
                          ),
                        ))
                      ],
                    )
                  ],
                )));
  }
}
