import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/card_student_class_item.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_overview.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/status_class_item.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_class_item_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/card_item.dart';

import 'detail_teacher_class.dart';

class ItemTeacherClass extends StatelessWidget {
  ItemTeacherClass({super.key, required this.classModel, required this.cubit})
      : itemCubit = TeacherClassItemCubit(cubit, classModel);
  final ClassModel classModel;
  final TeacherInfoCubit cubit;
  final TeacherClassItemCubit itemCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropdownCubit()),
          BlocProvider.value(value: itemCubit),
        ],
        child: BlocBuilder<TeacherClassItemCubit, int>(
          builder: (cc, s) {
            return BlocBuilder<DropdownCubit, int>(
              builder: (c, state) => Container(
                margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: Resizable.size(context, 1),
                        color:
                            state % 2 == 0 ? greyColor.shade100 : Colors.black),
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5))),
                child: AnimatedCrossFade(
                    firstChild: CardStudentClassItem(
                        canTap: true,
                        widget: StudentClassOverview(
                          model: itemCubit.classModel,
                          courseTitle: itemCubit.title ?? "",
                          lessonPercent: itemCubit.lessonResults == null
                              ? 0
                              : itemCubit.lessonResults!.length /
                                  itemCubit.lessonCount!,
                          lessonCountTitle:
                              '${itemCubit.lessonCountTitle} ${AppText.txtLesson.text.toLowerCase()}',
                          attendancePercent: itemCubit.attendancePercent == null
                              ? 0
                              : itemCubit.attendancePercent!,
                          hwPercent: itemCubit.hwPercent == null
                              ? 0
                              : itemCubit.hwPercent!,
                        ),
                        onPressed: () {
                          BlocProvider.of<DropdownCubit>(c).update();
                        },
                        widgetStatus: StatusTeacherClass(
                            status: itemCubit.classModel.classStatus),
                        onTap: () async {
                          await Navigator.pushNamed(context,
                              "${Routes.admin}/overview/class=${classModel.classId}");
                        }),
                    secondChild: CardStudentClassItem(
                        canTap: true,
                        isExpand: true,
                        widget: Column(
                          children: [
                            StudentClassOverview(
                              model: itemCubit.classModel,
                              courseTitle: itemCubit.title ?? "",
                              lessonPercent: itemCubit.lessonResults == null
                                  ? 0
                                  : itemCubit.lessonResults!.length /
                                      itemCubit.lessonCount!,
                              lessonCountTitle:
                                  '${itemCubit.lessonCountTitle} ${AppText.txtLesson.text.toLowerCase()}',
                              attendancePercent:
                                  itemCubit.attendancePercent == null
                                      ? 0
                                      : itemCubit.attendancePercent!,
                              hwPercent: itemCubit.hwPercent == null
                                  ? 0
                                  : itemCubit.hwPercent!,
                            ),
                            DetailTeacherClass(itemCubit: itemCubit)
                          ],
                        ),
                        onPressed: () {
                          BlocProvider.of<DropdownCubit>(c).update();
                        },
                        widgetStatus: StatusTeacherClass(
                            status: itemCubit.classModel.classStatus),
                        onTap: () async {
                          await Navigator.pushNamed(context,
                              "${Routes.admin}/overview/class=${classModel.classId}");
                        }),
                    crossFadeState: state % 2 == 1
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 100)),
              ),
            );
          },
        ));
  }
}
