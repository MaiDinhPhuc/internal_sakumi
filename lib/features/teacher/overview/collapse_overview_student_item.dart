import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_confirm_change_student_status.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class CollapseOverviewStudentItem extends StatelessWidget {
  final String role;
  final int stdId;
  const CollapseOverviewStudentItem(this.stdId,this.role, {Key? key, required this.cubit, required this.dataCubit}) : super(key: key);
  final ClassOverviewCubit cubit;
  final DataCubit dataCubit;
  @override
  Widget build(BuildContext context) {
    int index = cubit.listStdClass!.indexOf(cubit.listStdClass!.firstWhere((e) => e.userId == stdId));
    return Container(
        padding: EdgeInsets.only(
          right: Resizable.padding(context, 15),
        ),
        child: OverviewItemRowLayout(
            icon: role == "admin" ? BlocProvider(
              create: (context)=>MenuPopupCubit(),
              child: BlocBuilder<MenuPopupCubit, int>(
                builder: (c, s){
                  var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
                  return PopupMenuButton(itemBuilder: (context) => [
                    ...cubit.listStudentStatusMenu.map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: BlocProvider(create: (context)=>CheckBoxFilterCubit(cubit.listStdClass![index].status == e),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (c,state){
                          return InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              if(cubit.listStdClass![index].status != e){
                                showDialog(
                                    context: context,
                                    builder: (context) => ConfirmChangeStudentStatusOverView(e,cubit.listStdClass![index],cubit.students![index],cubit,popupCubit, dataCubit: dataCubit,));
                              }
                            },
                            child: Container(
                                height: Resizable.size(
                                    context, 33),
                                decoration: BoxDecoration(
                                    color: state? primaryColor: Colors.white
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Resizable.padding(
                                      context, 10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(vietnameseSubText(e), style: TextStyle(fontSize: Resizable.font(
                                          context, 15),color:state? Colors.white : Colors.black)),
                                      if(state)
                                        const Icon(Icons.check, color: Colors.white,)
                                    ],
                                  ),
                                )
                            ),
                          );
                        }))
                    ))
                  ],
                    child: Tooltip(
                        padding: EdgeInsets.all(Resizable.padding(context, 10)),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                                color: Colors.black, width: Resizable.size(context, 1)),
                            borderRadius:
                            BorderRadius.circular(Resizable.padding(context, 5))),
                        richMessage: WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: vietnameseSubText(cubit.listStdClass![index].status),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: EdgeInsets.all(Resizable.padding(context, 10)),
                            decoration: BoxDecoration(
                                color: cubit.listStdClass![index].color,
                                borderRadius:
                                BlocProvider.of<DropdownCubit>(context).state % 2 ==
                                    0
                                    ? BorderRadius.horizontal(
                                    left: Radius.circular(
                                        Resizable.padding(context, 5)))
                                    : BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Resizable.padding(context, 5)))),
                            child: Image.asset(
                                'assets/images/ic_${cubit.listStdClass![index].icon}.png'),
                          ),
                        )),
                  );
                },
              ),
            ) : Tooltip(
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.black, width: Resizable.size(context, 1)),
                    borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5))),
                richMessage: WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: vietnameseSubText(cubit.listStdClass![index].status),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 18),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: EdgeInsets.all(Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        color: cubit.listStdClass![index].color,
                        borderRadius:
                        BlocProvider.of<DropdownCubit>(context).state % 2 ==
                            0
                            ? BorderRadius.horizontal(
                            left: Radius.circular(
                                Resizable.padding(context, 5)))
                            : BorderRadius.only(
                            topLeft: Radius.circular(
                                Resizable.padding(context, 5)))),
                    child: Image.asset(
                        'assets/images/ic_${cubit.listStdClass![index].icon}.png'),
                  ),
                )),
            name: Text(cubit.students!.firstWhere((e) => e.userId == stdId).name,
                style: TextStyle(
                    fontSize: Resizable.font(context, 20),
                    color: const Color(0xff131111),
                    fontWeight: FontWeight.w500)),
            attend: CircleProgress(
                    title:
                        '${(cubit.listStdDetail[index]["attendancePercent"] * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: cubit.listStdDetail[index]["attendancePercent"],
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
            submit:CircleProgress(
                    title:
                        '${(cubit.listStdDetail[index]["hwPercent"] * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: cubit.listStdDetail[index]["hwPercent"],
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
            point: Container(),
            // cubit.stdPoints![index] == 0
            //         ? Container()
            //         : CircleAvatar(
            //             radius: Resizable.size(context, 16),
            //             child: Text(cubit.stdPoints![index].toStringAsFixed(1)),
            //           ),
            dropdown: IconButton(
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(context).update();
                },
                splashRadius: Resizable.size(context, 15),
                icon: Icon(
                  BlocProvider.of<DropdownCubit>(context).state % 2 == 0
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                )),
            evaluate: Container(
              width: Resizable.size(context, 20),
              height: Resizable.size(context, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Text('A', //TODO ADD ALGORITHM
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: Resizable.font(context, 30))),
            )));
  }
}
