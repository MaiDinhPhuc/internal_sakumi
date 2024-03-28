import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'list_teacher/alert_confirm_change_teacher_class_status.dart';
import 'manage_general_cubit.dart';

class ExpandTeacherItem extends StatelessWidget {
  const ExpandTeacherItem(
      {super.key, required this.cubit, required this.teacher});
  final ManageGeneralCubit cubit;
  final TeacherModel teacher;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: Resizable.size(context, 220),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Phụ trách chính",
                  style: TextStyle(fontSize: Resizable.font(context, 20))),
              value: cubit.getTeacherClass(teacher.userId).responsibility,
              onChanged: (newValue) {
                cubit.updateResponsibility(TeacherClassModel(
                    id: cubit.getTeacherClass(teacher.userId).id,
                    userId: cubit.getTeacherClass(teacher.userId).userId,
                    classId: cubit.getTeacherClass(teacher.userId).classId,
                    classStatus: cubit.getTeacherClass(teacher.userId).classStatus,
                    date: cubit.getTeacherClass(teacher.userId).date,
                    responsibility: newValue!));
              },
            )),
        BlocProvider(
            create: (context) => MenuPopupCubit(),
            child: BlocBuilder<MenuPopupCubit, int>(
              builder: (cc, s) {
                var popupCubit = BlocProvider.of<MenuPopupCubit>(cc);
                return Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    //boxShadow: const [BoxShadow(blurRadius: 5, color:  Color(0xff33691e))],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: PopupMenuButton(
                          itemBuilder: (context) => [
                                ...cubit.listTeacherClassStatus.map((e) =>
                                    PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        child: BlocProvider(
                                            create: (context) =>
                                                CheckBoxFilterCubit(cubit
                                                        .getTeacherClass(
                                                            teacher.userId)
                                                        .classStatus ==
                                                    e),
                                            child: BlocBuilder<
                                                CheckBoxFilterCubit,
                                                bool>(builder: (c, state) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (cubit
                                                          .getTeacherClass(
                                                              teacher.userId)
                                                          .classStatus !=
                                                      e) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            ConfirmChangeTeacherStatus(
                                                                e,
                                                                cubit.getTeacherClass(
                                                                    teacher
                                                                        .userId),
                                                                teacher,
                                                                cubit,
                                                                popupCubit));
                                                  }
                                                },
                                                child: Container(
                                                    height: Resizable.size(
                                                        context, 33),
                                                    decoration: BoxDecoration(
                                                        color: state
                                                            ? primaryColor
                                                            : Colors.white),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Resizable
                                                                      .padding(
                                                                          context,
                                                                          10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              vietnameseSubText(
                                                                  e),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Resizable.font(
                                                                          context,
                                                                          15),
                                                                  color: state
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                          if (state)
                                                            const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            }))))
                              ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Resizable.size(context, 10)),
                            ),
                          ),
                          child: Tooltip(
                              padding: EdgeInsets.all(
                                  Resizable.padding(context, 10)),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color: Colors.black,
                                      width: Resizable.size(context, 1)),
                                  borderRadius: BorderRadius.circular(
                                      Resizable.padding(context, 5))),
                              richMessage: WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Đang dạy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xff33691e),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/ic_in_progress.png',
                                      scale: 50,
                                    ),
                                  ),
                                ),
                              )))),
                );
              },
            ))
      ],
    );
  }
}
