import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_learned_lesson_item.dart';
import 'expand_learned_lesson_item.dart';

class ExpandedOverviewStudentItem extends StatelessWidget {
  final StudentClassModel stdClass;
  const ExpandedOverviewStudentItem(this.stdClass, {Key? key, required this.cubit}) : super(key: key);
  final ClassOverviewCubit cubit;
  @override
  Widget build(BuildContext context) {
    int index = cubit.listStdClass!.indexOf(stdClass);
    return Column(
            children: [
              Container(
                height: Resizable.size(context, 0.5),
                width: double.maxFinite,
                color: const Color(0xffE0E0E0),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              Padding(padding: EdgeInsets.only(
                  left: Resizable.padding(context, 50),
                  right: Resizable.padding(context, 50),
                  bottom: Resizable.padding(context, 10)), child: Row(
                children: [
                  Expanded(
                      flex: 6,
                      child: Container()),
                  Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Expanded(
                              flex:8,
                              child: Container()),
                          Expanded(
                              flex:3,
                              child: Text(AppText.txtDoingTime.text, style: TextStyle(
                                  color: const Color(0xff757575),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17)))),
                          Expanded(
                              flex:1,
                              child: Container()),
                          Expanded(
                              flex:2,
                              child: Text(AppText.txtIgnore.text, style: TextStyle(
                                  color: const Color(0xff757575),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17)))),
                          Expanded(
                              flex:1,
                              child: Container())
                        ],
                      ))
                ],
              ),)
              ,
              for (int i = 0; i<cubit.listStdDetail[index]["attendance"].length; i++)
                BlocProvider(
                    create: (context) => DropdownCubit(),
                    child: BlocBuilder<DropdownCubit, int>(
                      builder: (c, state) => Container(
                          margin: EdgeInsets.only(
                              left: Resizable.padding(context, 25),
                              right: Resizable.padding(context, 32),
                              bottom: Resizable.padding(context, 10)),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 15),
                              vertical: Resizable.padding(context, 5)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: Resizable.size(context, 0.5),
                                  color: state % 2 == 0
                                      ? greyColor.shade100
                                      : Colors.black),
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 5))),
                          child: AnimatedCrossFade(
                              firstChild: CollapseLearnedLesson(cubit.listStdDetail[index]["title"][i], cubit.listStdDetail[index]["attendance"][i], cubit.listStdDetail[index]["hw"][i],cubit.listStdDetail[index]["doingTime"][i], cubit.listStdDetail[index]["ignore"][i]),
                              secondChild: Column(
                                children: [
                                  CollapseLearnedLesson(cubit.listStdDetail[index]["title"][i], cubit.listStdDetail[index]["attendance"][i], cubit.listStdDetail[index]["hw"][i],cubit.listStdDetail[index]["doingTime"][i], cubit.listStdDetail[index]["ignore"][i]),
                                  ExpandLearnedLesson(cubit.listStdDetail[index]["spNote"][i], cubit.listStdDetail[index]["teacherNote"][i])
                                ],
                              ),
                              crossFadeState: state % 2 == 1
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration:
                              const Duration(milliseconds: 100))),
                    ))
            ],
          );
  }
}



