import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../manage_general/list_student/alert_edit_student_profile.dart';
import 'load_student_cubit.dart';

class StudentInfoItem extends StatelessWidget {
  const StudentInfoItem({super.key, required this.cubit, required this.index});
  final LoadListStudentCubit cubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical:
          Resizable.padding(context, 5)),
      child: BlocProvider(
          create: (context) => DropdownCubit(),
          child: BlocBuilder<DropdownCubit, int>(
            builder: (c, state) => Stack(
              children: [
                Container(
                    alignment:
                    Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(
                                context, 1),
                            color: state % 2 == 0
                                ? greyColor
                                .shade100
                                : Colors.black),
                        borderRadius: BorderRadius.circular(
                            Resizable.size(
                                context, 5))),
                    child: AnimatedCrossFade(
                        firstChild: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable
                                  .padding(
                                  context,
                                  20),
                              vertical: Resizable
                                  .padding(
                                  context,
                                  15)),
                          child: StudentItemRowLayout(
                              name:
                              cubit.listData[index]
                                  .name,
                              phone:
                              cubit.listData[index]
                                  .phone,
                              code: cubit.listData[
                              index]
                                  .studentCode),
                        ),
                        secondChild: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  Resizable.padding(
                                      context,
                                      20),
                                  vertical: Resizable
                                      .padding(
                                      context,
                                      15)),
                              child: StudentItemRowLayout(
                                  name: cubit.listData[
                                  index]
                                      .name,
                                  phone: cubit.listData[
                                  index]
                                      .phone,
                                  code: cubit.listData[
                                  index]
                                      .studentCode),
                            ),
                            const Text('kkkkkkk')
                          ],
                        ),
                        crossFadeState: state % 2 == 1
                            ? CrossFadeState
                            .showSecond
                            : CrossFadeState
                            .showFirst,
                        duration: const Duration(
                            milliseconds: 100))),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () =>alertEditStudentProfile(c,cubit.listData[index], index),
                          borderRadius:
                          BorderRadius.circular(
                              Resizable.size(
                                  context, 5))),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      right: Resizable.padding(
                          context, 10),
                      top: Resizable.padding(
                          context, 8)),
                  alignment:
                  Alignment.centerRight,
                  child: IconButton(
                      onPressed: () => BlocProvider
                          .of<DropdownCubit>(
                          c)
                          .update(),
                      splashRadius:
                      Resizable.size(
                          context, 15),
                      icon: Icon(
                        state % 2 == 0
                            ? Icons
                            .keyboard_arrow_down
                            : Icons
                            .keyboard_arrow_up,
                      )),
                )
              ],
            ),
          )),
    );
  }
}
