import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/attendance_item.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ClassificationItem extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final StudentModel studentModel;
  final List<String> firstItems, secondItems;
  const ClassificationItem(this.studentModel, this.index, this.controller,
      { required this.firstItems, required this.secondItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 10),
          right: Resizable.padding(context, 150),
          left: Resizable.padding(context, 150)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 15)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: Resizable.size(context, 7))
          ],
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 6,
                  child: Text(
                    studentModel.name,
                    style: TextStyle(fontSize: Resizable.font(context, 20)),
                  )),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 9,
                          child: BlocProvider(
                              create: (context) =>
                                  DropdownAttendanceCubit(index),
                              child: BlocBuilder<DropdownAttendanceCubit, int>(
                                  builder: (c, s) => DropDownWidget(
                                      studentModel.userId,
                                      selectorId: s,
                                      items: firstItems,
                                      onPressed: (v) {
                                        s = firstItems.indexOf(v.toString());
                                        debugPrint('==========> index $s === ${controller.text}');
                                        BlocProvider.of<DropdownAttendanceCubit>(c).updateStudentStatus('active_status', s, studentModel.userId, context);
                                      })))),
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
                        child: BlocProvider(
                            create: (context) =>
                                DropdownAttendanceCubit(index),
                            child: BlocBuilder<DropdownAttendanceCubit, int>(
                                builder: (c, s) => DropDownWidget(
                                    studentModel.userId,
                                    selectorId: s,
                                    items: secondItems,
                                    onPressed: (v) {
                                      s = secondItems.indexOf(v.toString());
                                      BlocProvider.of<DropdownAttendanceCubit>(c).updateStudentStatus('learning_status', s, studentModel.userId, c);
                                    })))
                      )
                    ],
                  )),
              Expanded(flex: 1, child: Container()),
            ],
          ),
          Container(
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 8)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: greyColor.shade50,
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5))),
            child: TextFormField(key: Key('oooooooo'),
              controller: controller,
              autofocus: true,
              //initialValue: '',
              onChanged: (v){

              },
              decoration: InputDecoration(
                enabled: true,
                hintText: AppText.txtHintNoteForStudent.text,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 18)),
                fillColor: greyColor.shade50,
                hoverColor: greyColor.shade50,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(Resizable.padding(context, 10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(Resizable.padding(context, 10)),
                ),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.padding(context, 10)),
                    borderSide: BorderSide.none),
              ),
              //onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
