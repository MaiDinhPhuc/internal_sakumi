import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_overview.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/status_class_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/teacher_info_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../manage_student/card_student_class_item.dart';
import 'detail_teacher_class.dart';

class ItemTeacherClass extends StatelessWidget {
  const ItemTeacherClass({super.key, required this.teacherInFo});
  final TeacherInfoModel teacherInFo;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: BlocBuilder<DropdownCubit, int>(
        builder: (c, state) => Container(
          margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  width: Resizable.size(context, 1),
                  color: state % 2 == 0 ? greyColor.shade100 : Colors.black),
              borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
          child: AnimatedCrossFade(
              firstChild: CardStudentClassItem(
                  widget: StudentClassOverview(
                    model: teacherInFo.classModel!,
                    courseTitle: teacherInFo.courseModel == null
                        ? ""
                        : "${teacherInFo.courseModel!.name} ${teacherInFo.courseModel!.level} ${teacherInFo.courseModel!.termName}",
                    lessonPercent: teacherInFo.getLessonPercent(),
                    lessonCountTitle: teacherInFo.courseModel == null
                        ? ""
                        : "${teacherInFo.lessonResults?.length ?? 0}/${teacherInFo.courseModel!.lessonCount}",
                    attendancePercent: teacherInFo.getAttendancePercent(),
                    hwPercent: teacherInFo.getHwPercent(),
                  ),
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: StatusTeacherClass(
                      status: teacherInFo.classModel == null
                          ? "InProgress"
                          : teacherInFo.classModel!.classStatus,
                      color: teacherInFo.getColor(),
                      icon: teacherInFo.getIcon())),
              secondChild: CardStudentClassItem(
                  isExpand: true,
                  widget: Column(
                    children: [
                      StudentClassOverview(
                        model: teacherInFo.classModel!,
                        courseTitle: teacherInFo.courseModel == null
                            ? ""
                            : "${teacherInFo.courseModel!.name} ${teacherInFo.courseModel!.level} ${teacherInFo.courseModel!.termName}",
                        lessonPercent: teacherInFo.getLessonPercent(),
                        lessonCountTitle: teacherInFo.courseModel == null
                            ? ""
                            : "${teacherInFo.lessonResults?.length ?? 0}/${teacherInFo.courseModel!.lessonCount}",
                        attendancePercent: teacherInFo.getAttendancePercent(),
                        hwPercent: teacherInFo.getHwPercent(),
                      ),
                      DetailTeacherClass(teacherInFo: teacherInFo)
                    ],
                  ),
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: StatusTeacherClass(
                      status: teacherInFo.classModel == null
                          ? "InProgress"
                          : teacherInFo.classModel!.classStatus,
                      color: teacherInFo.getColor(),
                      icon: teacherInFo.getIcon())),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ),
      ),
    );
  }
}
