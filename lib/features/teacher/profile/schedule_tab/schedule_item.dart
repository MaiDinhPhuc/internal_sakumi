import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CyclicScheduleItem extends StatelessWidget {
  const CyclicScheduleItem(
      {super.key, required this.cubit, required this.scheduleModel, required this.index});
  final ScheduleTabCubit cubit;
  final ScheduleModel scheduleModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return scheduleModel.status != "cancel"? Container(
        height: Resizable.size(context, 70),
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
          ],
        )) : Container(
        height: Resizable.size(context, 70),
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
          ],
        ));
  }
}

class SingleScheduleItem extends StatelessWidget {
  const SingleScheduleItem(
      {super.key, required this.cubit, required this.scheduleModel, required this.index});
  final ScheduleTabCubit cubit;
  final ScheduleModel scheduleModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return scheduleModel.status == "cancel"
        ? Container(
        height: Resizable.size(context, 70),
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
                    )))
          ],
        )) : Container(
        height: Resizable.size(context, 70),
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
                    )))
          ],
        ));
  }
}


