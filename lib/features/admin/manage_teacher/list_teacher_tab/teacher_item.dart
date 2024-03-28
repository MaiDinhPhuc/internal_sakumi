import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_detail_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_item_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/card_item.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class TeacherItem extends StatelessWidget {
  TeacherItem({super.key, required this.teacherModel}) : cubit = TeacherDetailCubit(teacherModel);
  final TeacherModel teacherModel;
  final TeacherDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropdownCubit()),
          BlocProvider.value(value: cubit),
        ],
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardTeacherItem(
                  widget: TeacherItemView(
                    teacherModel: teacherModel,
                    cubit: cubit,
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.admin}/teacherInfo/teacher=${teacherModel.userId}");
                  },
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: Container()),
              secondChild: CardTeacherItem(
                  isExpand: true,
                  widget: Column(
                    children: [
                      TeacherItemView(
                        teacherModel: teacherModel,
                        cubit: cubit,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: Resizable.size(context, 1),
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 15)),
                              color: const Color(0xffD9D9D9),
                            ),
                            Text(AppText.titleNoteFromSupport.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 19))),
                            NoteWidget(teacherModel.note),
                            Container(
                              height: Resizable.size(context, 1),
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 15)),
                              color: const Color(0xffD9D9D9),
                            )
                          ],
                        ),
                      ),
                      BlocBuilder<TeacherDetailCubit, int>(
                          bloc: cubit,
                          builder: (c, s) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: Resizable.size(context, 80),
                                      child: CircleProgress(
                                        title: cubit.levelUpPercent == null
                                            ? '0%'
                                            : '${cubit.levelUpPercent!.toStringAsFixed(0)} %',
                                        lineWidth: Resizable.size(context, 5),
                                        percent: cubit.levelUpPercent == null
                                            ? 0
                                            : cubit.levelUpPercent! / 100,
                                        radius: Resizable.size(context, 30),
                                        fontSize: Resizable.font(context, 20),
                                      ),
                                    ),
                                    Text(AppText.txtUpPercent.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: Resizable.font(context, 24)))
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: Resizable.size(context, 80),
                                        child: CircleProgress(
                                          title: cubit.attendancePercent == null
                                              ? '0%'
                                              : '${(cubit.attendancePercent! * 100).toStringAsFixed(0)} %',
                                          lineWidth: Resizable.size(context, 5),
                                          percent: cubit.attendancePercent == null
                                              ? 0
                                              : cubit.attendancePercent!,
                                          radius: Resizable.size(context, 30),
                                          fontSize: Resizable.font(context, 20),
                                        )),
                                    Text(AppText.txtRateOfAttendance.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: Resizable.font(context, 24)))
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: Resizable.size(context, 80),
                                        child: CircleProgress(
                                          title: cubit.hwPercent == null
                                              ? '0%'
                                              : '${(cubit.hwPercent! * 100).toStringAsFixed(0)} %',
                                          lineWidth: Resizable.size(context, 5),
                                          percent: cubit.hwPercent == null
                                              ? 0
                                              : cubit.hwPercent!,
                                          radius: Resizable.size(context, 30),
                                          fontSize: Resizable.font(context, 20),
                                        )),
                                    Text(AppText.txtRateOfSubmitHomework.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: Resizable.font(context, 24)))
                                  ],
                                )
                              ],
                            );
                          })
                    ],
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.admin}/teacherInfo/teacher=${teacherModel.userId}");
                  },
                  onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                  widgetStatus: Container()),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
