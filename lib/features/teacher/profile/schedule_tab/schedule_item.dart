import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/manage_schedule_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem(
      {super.key, required this.cubit, required this.scheduleModel});
  final ScheduleTabCubit cubit;
  final ScheduleModel scheduleModel;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 5),
            vertical: Resizable.padding(context, 3)),
        decoration: BoxDecoration(
            color: scheduleModel.type == "single"
                ? const Color(0xffFDE3E3)
                : const Color(0xffE3F2FD),
            border: Border.all(
                width: Resizable.size(context, 1),
                color: scheduleModel.type == "single"
                    ? const Color(0xffFDE3E3)
                    : const Color(0xffE3F2FD)),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 5),
                  vertical: Resizable.padding(context, 2)),
              decoration: BoxDecoration(
                  color: scheduleModel.type == "single"
                      ? const Color(0xffFBBBBB)
                      : const Color(0xff90CAF9),
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: scheduleModel.type == "single"
                          ? const Color(0xffFBBBBB)
                          : const Color(0xff90CAF9)),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 15))),
              child: Text(
                scheduleModel.type == "single"
                    ? "Nghỉ"
                    : "${scheduleModel.startTime} - ${scheduleModel.endTime}",
                style: TextStyle(
                    color: scheduleModel.type == "single"
                        ? const Color(0xffA10D0D)
                        : const Color(0xff0D47A1),
                    fontSize: Resizable.font(context, 16),
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
                child: Center(
                    child: Text(
              cubit.getClassCode(scheduleModel.classId).toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Resizable.font(context, 20),
                  fontWeight: FontWeight.w600),
            )))
          ],
        ));
  }
}

class ScheduleItemV2 extends StatelessWidget {
  const ScheduleItemV2(
      {super.key, required this.cubit, required this.scheduleModel});
  final ManageScheduleCubit cubit;
  final ScheduleModel scheduleModel;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 5),
            vertical: Resizable.padding(context, 3)),
        decoration: BoxDecoration(
            color: scheduleModel.type == "single"
                ? const Color(0xffFDE3E3)
                : const Color(0xffE3F2FD),
            border: Border.all(
                width: Resizable.size(context, 1),
                color: scheduleModel.type == "single"
                    ? const Color(0xffFDE3E3)
                    : const Color(0xffE3F2FD)),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 5),
                  vertical: Resizable.padding(context, 2)),
              decoration: BoxDecoration(
                  color: scheduleModel.type == "single"
                      ? const Color(0xffFBBBBB)
                      : const Color(0xff90CAF9),
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: scheduleModel.type == "single"
                          ? const Color(0xffFBBBBB)
                          : const Color(0xff90CAF9)),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 15))),
              child: Text(
                scheduleModel.type == "single"
                    ? "Nghỉ"
                    : "${scheduleModel.startTime} - ${scheduleModel.endTime}",
                style: TextStyle(
                    color: scheduleModel.type == "single"
                        ? const Color(0xffA10D0D)
                        : const Color(0xff0D47A1),
                    fontSize: Resizable.font(context, 16),
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
                child: Center(
                    child: Text(
              cubit.getClassCode(scheduleModel.classId).toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Resizable.font(context, 20),
                  fontWeight: FontWeight.w600),
            ))),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 5),
                  vertical: Resizable.padding(context, 2)),
              decoration: BoxDecoration(
                  color: scheduleModel.type == "single"
                      ? const Color(0xffFBBBBB)
                      : const Color(0xff90CAF9),
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: scheduleModel.type == "single"
                          ? const Color(0xffFBBBBB)
                          : const Color(0xff90CAF9)),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 15))),
              child: Text(
                cubit.getTeacherName(scheduleModel.teacherId),
                style: TextStyle(
                    color: scheduleModel.type == "single"
                        ? const Color(0xffA10D0D)
                        : const Color(0xff0D47A1),
                    fontSize: Resizable.font(context, 16),
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ));
  }
}
