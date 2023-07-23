import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/attendance_item.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ClassificationItem extends StatelessWidget {
  final int index;
  final StudentModel studentModel;
  final List<String> firstItems, secondItems;
  const ClassificationItem(this.studentModel, this.index,
      {required this.firstItems, required this.secondItems, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownAttendanceCubit(index),
        child: BlocBuilder<DropdownAttendanceCubit, int>(
            builder: (c, s) => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: Resizable.padding(context, 10),
                          right: Resizable.padding(context, 150),
                          left: Resizable.padding(context, 150)),
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20),
                          vertical: Resizable.padding(context, 8)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: Resizable.size(context, 1),
                              color: greyColor.shade100),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 5))),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                              flex: 6,
                              child: Text(
                                studentModel.name,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 20)),
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 9,
                                      child: DropDownWidget(
                                          index, studentModel.userId,
                                          items: firstItems)),
                                  Expanded(flex: 1, child: Container()),
                                ],
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 9,
                                      child: DropDownWidget(
                                          index, studentModel.userId,
                                          items: secondItems))
                                ],
                              )),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                    ),
                  ],
                )));
  }
}
