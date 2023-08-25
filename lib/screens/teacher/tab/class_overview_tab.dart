import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/collapse_overview_student_item.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/features/teacher/overview/statistic_class_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import '../../../utils/text_utils.dart';

class ClassOverViewTab extends StatelessWidget {
  const ClassOverViewTab(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ClassOverviewCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                index: 0,
                classId: TextUtils.getName(position: 2),
                name: name,
              ),
              BlocBuilder<ClassOverviewCubit, int>(builder: (c, _) {
                var cubit = BlocProvider.of<ClassOverviewCubit>(c);
                return cubit.classModel == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 150)),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 20)),
                              child: Text(
                                  '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 30))),
                            ),
                            StatisticClassView(cubit),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  AppText.titleListStudent.text.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 20),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff757575))),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 10)),
                              height: Resizable.size(context, 1),
                              width: double.maxFinite,
                              color: const Color(0xffE0E0E0),
                            ),
                            OverviewItemRowLayout(
                                icon: Container(color: Colors.green),
                                name: Text(AppText.txtName.text,
                                    style: TextStyle(
                                        color: const Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 17))),
                                attend: Text(AppText.txtRateOfAttendance.text,
                                    style: TextStyle(
                                        color: const Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 17))),
                                submit: Text(
                                    AppText.txtRateOfSubmitHomework.text,
                                    style: TextStyle(
                                        color: const Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 17))),
                                point: Text(AppText.txtAveragePoint.text,
                                    style: TextStyle(
                                        color: const Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 17))),
                                dropdown: Opacity(
                                  opacity: 0,
                                  child: CircleProgress(
                                    title: '%',
                                    lineWidth: Resizable.size(context, 3),
                                    percent: 0,
                                    radius: Resizable.size(context, 15),
                                    fontSize: Resizable.font(context, 14),
                                  ),
                                ),
                                evaluate: Text(AppText.txtEvaluate.text,
                                    style: TextStyle(
                                        color: const Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 17)))),
                            // BlocProvider(
                            //     create: (context) =>
                            //         DropdownCubit(),
                            //     child: BlocBuilder<
                            //         DropdownCubit, int>(
                            //       builder: (c, state) =>
                            //           Stack(
                            //             children: [
                            //               Container(
                            //                   alignment: Alignment
                            //                       .centerLeft,
                            //                   padding: EdgeInsets.symmetric(
                            //                       horizontal:
                            //                       Resizable.padding(
                            //                           context, 15),
                            //                       vertical:
                            //                       Resizable.padding(
                            //                           context, 8)),
                            //                   decoration: BoxDecoration(
                            //                       border: Border.all(
                            //                           width: Resizable.size(
                            //                               context, 1),
                            //                           color: state % 2 == 0
                            //                               ? greyColor
                            //                               .shade100
                            //                               : Colors
                            //                               .black),
                            //                       borderRadius:
                            //                       BorderRadius.circular(Resizable.size(context, 5))),
                            //                   child: cubit.students == null
                            //                       ? Transform.scale(
                            //                     scale: 0.75,
                            //                     child:
                            //                     const CircularProgressIndicator(),
                            //                   )
                            //                       : AnimatedCrossFade(
                            //                       firstChild: Container(),
                            //                       secondChild: Column(
                            //                         children: [
                            //                           Container(),
                            //                           Container()
                            //                         ],
                            //                       ),
                            //                       crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            //                       duration: const Duration(milliseconds: 100))),
                            //               Positioned.fill(
                            //                   child: Material(
                            //                     color: Colors
                            //                         .transparent,
                            //                     child: InkWell(
                            //                         onDoubleTap:
                            //                             () {},
                            //                         onTap: (){},
                            //                         borderRadius:
                            //                         BorderRadius.circular(
                            //                             Resizable.size(
                            //                                 context,
                            //                                 5))),
                            //                   )),
                            //               Container(
                            //                 padding: EdgeInsets.symmetric(
                            //                     horizontal:
                            //                     Resizable.padding(
                            //                         context, 15),
                            //                     vertical:
                            //                     Resizable.padding(
                            //                         context, 8)),
                            //                 child: OverviewItemRowLayout(
                            //                     icon: Container(),
                            //                     name: Container(),
                            //                     attend: Container(),
                            //                     submit: Container(),
                            //                     point: Container(),
                            //                     dropdown:
                            //                     IconButton(
                            //                         onPressed:
                            //                             () {
                            //                           BlocProvider.of<DropdownCubit>(
                            //                               c)
                            //                               .update();
                            //                         },
                            //                         splashRadius:
                            //                         Resizable.size(
                            //                             context,
                            //                             15),
                            //                         icon: Icon(
                            //                           state % 2 == 0
                            //                               ? Icons
                            //                               .keyboard_arrow_down
                            //                               : Icons
                            //                               .keyboard_arrow_up,
                            //                         )), evaluate: Container()),
                            //               )
                            //             ],
                            //           ),
                            //     ))
                          ],
                        ),
                      )));
              })
            ],
          ),
        ));
  }
}
