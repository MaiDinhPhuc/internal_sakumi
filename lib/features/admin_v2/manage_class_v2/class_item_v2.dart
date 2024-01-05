import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/class_status_item_admin.dart';
import 'package:internal_sakumi/features/class_info/class_status_item_admin_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/chart_view.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/card_item.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

import 'class_cubit_v2.dart';
import 'class_detail_cubit.dart';
import 'class_overview_v2.dart';

class ClassItemV2 extends StatelessWidget {
  ClassItemV2({super.key, required this.classModel, required this.classCubit})
      : cubit = ClassDetailCubit(classModel);
  final ClassModel classModel;
  final ClassDetailCubit cubit;
  final ClassCubit classCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropdownCubit()),
          BlocProvider.value(value: cubit),
        ],
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardItem(
                  widget: ClassOverViewV2(
                    classModel: classModel,
                    cubit: cubit,
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.admin}/overview/class=${classModel.classId}");
                  },
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: StatusClassItemAdminV2(
                      classModel: classModel,
                      color: classModel.getColor(),
                      icon: classModel.getIcon(), classCubit: classCubit)),
              secondChild: CardItem(
                  isExpand: true,
                  widget: Column(
                    children: [
                      ClassOverViewV2(
                        classModel: classModel,
                        cubit: cubit,
                      ),
                      ChartView(
                        attendances: cubit.attChart ?? [],
                        hws:  cubit.hwChart ?? [],
                        stds:  cubit.stds ==
                            null
                            ? [1,0,0,0,0]
                            :  cubit.stds!,
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
                            Row(
                              children: [
                                Text(AppText.txtLastLesson.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))),
                                SizedBox(width: Resizable.padding(context, 10)),
                                Text(cubit.lastLesson == null ? "" : cubit.lastLesson!,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 19))),
                              ],
                            ),
                            Container(
                              height: Resizable.size(context, 1),
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 15)),
                              color: const Color(0xffD9D9D9),
                            ),
                            Text(AppText.titleClassDes.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 19))),
                            NoteWidget(classModel.description),
                            Text(AppText.titleClassNote.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 19))),
                            NoteWidget(classModel.note)
                          ],
                        ),
                      )
                    ],
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.admin}/overview/class=${classModel.classId}");
                  },
                  onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                  widgetStatus: StatusClassItemAdminV2(
                      classCubit: classCubit,
                      classModel: classModel,
                      color: classModel.getColor(),
                      icon: classModel.getIcon())),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
