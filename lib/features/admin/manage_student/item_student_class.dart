import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_overview.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_status_item.dart';
import 'package:internal_sakumi/model/student_info_model.dart';

import 'card_student_class_item.dart';
import 'detail_student_class.dart';

class ItemStudentClass extends StatelessWidget {
  const ItemStudentClass({super.key, required this.stdInFo});
  final StudentInfoModel stdInFo;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: BlocBuilder<DropdownCubit, int>(
        builder: (c, state) => AnimatedCrossFade(
            firstChild: CardStudentClassItem(
                widget: StudentClassOverview(
                  model: stdInFo.classModel!,
                  courseTitle: stdInFo.courseModel == null ? "" :"${stdInFo.courseModel!.name} ${stdInFo.courseModel!.level} ${stdInFo.courseModel!.termName}",
                  lessonPercent: stdInFo.getLessonPercent(),
                  lessonCountTitle: stdInFo.courseModel == null ? "" :  "${stdInFo.lessonResults?.length ?? 0}/${stdInFo.courseModel!.lessonCount}",
                  attendancePercent: stdInFo.getAttendancePercent(),
                  hwPercent: stdInFo.getHwPercent(),
                ),
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(c).update();
                },
                widgetStatus: StatusClassItem(
                    status: stdInFo.stdClass == null ? "InProgress": stdInFo.stdClass!.classStatus,
                    color: stdInFo.getColor(),
                    icon: stdInFo.getIcon())),
            secondChild: Column(
              children: [
                CardStudentClassItem(
                    isExpand: true,
                    widget: Column(
                      children: [
                        StudentClassOverview(
                          model: stdInFo.classModel!,
                          courseTitle: stdInFo.courseModel == null ? "" : "${stdInFo.courseModel!.name} ${stdInFo.courseModel!.level} ${stdInFo.courseModel!.termName}",
                          lessonPercent: stdInFo.getLessonPercent(),
                          lessonCountTitle:  stdInFo.courseModel == null ? "" :  "${stdInFo.lessonResults?.length ?? 0}/${stdInFo.courseModel!.lessonCount}",
                          attendancePercent: stdInFo.getAttendancePercent(),
                          hwPercent: stdInFo.getHwPercent(),
                        ),
                        DetailStudentClassInfo(stdInFo: stdInFo)
                      ],
                    ),
                    onPressed: () {
                      BlocProvider.of<DropdownCubit>(c).update();
                    },
                    widgetStatus: StatusClassItem(
                        status: stdInFo.stdClass == null ? "InProgress": stdInFo.stdClass!.classStatus,
                        color: stdInFo.getColor(),
                        icon: stdInFo.getIcon()))
              ],
            ),
            crossFadeState: state % 2 == 1
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 100)),
      ),
    );
  }
}
