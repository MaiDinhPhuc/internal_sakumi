import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_item_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_overview.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_status_item.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'card_student_class_item.dart';
import 'detail_student_class.dart';

class ItemStudentClass extends StatelessWidget {
  ItemStudentClass({super.key, required this.cubit, required this.stdClass, required this.classModel})
      : itemCubit = StudentClasItemCubit(cubit, stdClass, classModel);
  final StudentInfoCubit cubit;
  final StudentClasItemCubit itemCubit;
  final StudentClassModel stdClass;
  final ClassModel classModel;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropdownCubit()),
          BlocProvider.value(value: itemCubit..loadData()),
        ],
        child: BlocBuilder<StudentClasItemCubit, int>(builder: (c, s) {
          return BlocBuilder<DropdownCubit, int>(
              builder: (c, state) => Container(
                  margin:
                      EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: Resizable.size(context, 1),
                          color: state % 2 == 0
                              ? greyColor.shade100
                              : Colors.black),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  child: AnimatedCrossFade(
                      firstChild: CardStudentClassItem(
                          widget: StudentClassOverview(
                            model: itemCubit.classModel,
                            courseTitle: itemCubit.courseModel == null
                                ? ""
                                : "${itemCubit.courseModel!.name} ${itemCubit.courseModel!.level} ${itemCubit.courseModel!.termName}",
                            lessonPercent: itemCubit.getLessonPercent(),
                            lessonCountTitle: itemCubit.courseModel == null
                                ? ""
                                : itemCubit.countTitle!,
                            attendancePercent: itemCubit.getAttendancePercent(),
                            hwPercent: itemCubit.lessons == null
                                ? 0
                                : itemCubit.getHwPercent(),
                          ),
                          onPressed: () {
                            BlocProvider.of<DropdownCubit>(c).update();
                          },
                          widgetStatus: StatusClassItem(
                              status: itemCubit.stdClass.classStatus,
                              color: itemCubit.getColor(),
                              icon: itemCubit.getIcon()), onTap: () {}),
                      secondChild: Column(
                        children: [
                          CardStudentClassItem(
                              widget: StudentClassOverview(
                                model: itemCubit.classModel,
                                courseTitle: itemCubit.courseModel == null
                                    ? ""
                                    : "${itemCubit.courseModel!.name} ${itemCubit.courseModel!.level} ${itemCubit.courseModel!.termName}",
                                lessonPercent: itemCubit.getLessonPercent(),
                                lessonCountTitle: itemCubit.courseModel == null
                                    ? ""
                                    : itemCubit.countTitle!,
                                attendancePercent:
                                    itemCubit.getAttendancePercent(),
                                hwPercent: itemCubit.lessons == null
                                    ? 0
                                    : itemCubit.getHwPercent(),
                              ),
                              onPressed: () {
                                BlocProvider.of<DropdownCubit>(c).update();
                              },
                              widgetStatus: StatusClassItem(
                                  status: itemCubit.stdClass.classStatus,
                                  color: itemCubit.getColor(),
                                  icon: itemCubit.getIcon()), onTap: () {}),
                          DetailStudentClassInfo(itemCubit: itemCubit)
                        ],
                      ),
                      crossFadeState: state % 2 == 1
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 100))));
        }));
  }
}
