import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_overview.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/status_class_item.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_class_item_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../manage_student/card_student_class_item.dart';
import 'detail_teacher_class.dart';

class ItemTeacherClass extends StatelessWidget {
  ItemTeacherClass({super.key, required this.teacherClass, required this.cubit})
      : itemCubit =
            TeacherClassItemCubit(teacherClass.classId, cubit, teacherClass);
  final TeacherClassModel teacherClass;
  final TeacherInfoCubit cubit;
  final TeacherClassItemCubit itemCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropdownCubit()),
          BlocProvider.value(value: itemCubit..loadData()),
        ],
        child: BlocBuilder<TeacherClassItemCubit, int>(builder: (cc,s){
          return BlocBuilder<DropdownCubit, int>(
            builder: (c, state) => Container(
              margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: state % 2 == 0 ? greyColor.shade100 : Colors.black),
                  borderRadius:
                  BorderRadius.circular(Resizable.size(context, 5))),
              child: AnimatedCrossFade(
                  firstChild: CardStudentClassItem(
                      widget: StudentClassOverview(
                        model: itemCubit.classModel!,
                        courseTitle: itemCubit.courseModel == null
                            ? ""
                            : "${itemCubit.courseModel!.name} ${itemCubit.courseModel!.level} ${itemCubit.courseModel!.termName}",
                        lessonPercent: itemCubit.getLessonPercent(),
                        lessonCountTitle: itemCubit.countTitle == null
                            ? ""
                            : itemCubit.countTitle!,
                        attendancePercent: itemCubit.getAttendancePercent(),
                        hwPercent: itemCubit.getHwPercent(),
                      ),
                      onPressed: () {
                        BlocProvider.of<DropdownCubit>(c).update();
                      },
                      widgetStatus: StatusTeacherClass(
                          status: itemCubit.classModel == null
                              ? "InProgress"
                              : itemCubit.classModel!.classStatus)),
                  secondChild: CardStudentClassItem(
                      isExpand: true,
                      widget: Column(
                        children: [
                          StudentClassOverview(
                            model: itemCubit.classModel!,
                            courseTitle: itemCubit.courseModel == null
                                ? ""
                                : "${itemCubit.courseModel!.name} ${itemCubit.courseModel!.level} ${itemCubit.courseModel!.termName}",
                            lessonPercent: itemCubit.getLessonPercent(),
                            lessonCountTitle: itemCubit.countTitle == null
                                ? ""
                                : itemCubit.countTitle!,
                            attendancePercent: itemCubit.getAttendancePercent(),
                            hwPercent: itemCubit.getHwPercent(),
                          ),
                          DetailTeacherClass(itemCubit: itemCubit)
                        ],
                      ),
                      onPressed: () {
                        BlocProvider.of<DropdownCubit>(c).update();
                      },
                      widgetStatus: StatusTeacherClass(
                          status: itemCubit.classModel == null
                              ? "InProgress"
                              : itemCubit.classModel!.classStatus)),
                  crossFadeState: state % 2 == 1
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 100)),
            ),
          );
        },));
  }
}
