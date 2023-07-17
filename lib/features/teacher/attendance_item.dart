import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class AttendanceItem extends StatelessWidget {
  final StudentModel studentModel;
  final int attendId;
  final DropdownAttendanceCubit cubit;
  var items = [
    AppText.txtNotTimeKeeping.text,
    AppText.txtPresent.text,
    AppText.txtInLate.text,
    AppText.txtOutSoon.text,
    '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
    AppText.txtPermitted.text,
    AppText.txtAbsent.text,
  ];
  AttendanceItem(this.studentModel, this.attendId, {Key? key})
      : cubit = DropdownAttendanceCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownAttendanceCubit, int>(
        bloc: cubit,
        builder: (c, s) => Container(
              margin: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 200),
                  left: Resizable.padding(context, 200)),
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 8)),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: greyColor.shade100),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 3,
                      child: Text(
                        studentModel.name,
                        style: TextStyle(fontSize: Resizable.font(context, 20)),
                      )),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                              flex: 2,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  buttonPadding: EdgeInsets.symmetric(
                                      vertical: Resizable.size(context, 0),
                                      horizontal:
                                          Resizable.padding(context, 10)),
                                  buttonDecoration: BoxDecoration(
                                      border: Border.all(
                                          color: s == 0
                                              ? primaryColor
                                              : Colors.black),
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  dropdownElevation: 0,
                                  dropdownDecoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  itemHeight: Resizable.size(context, 25),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item,
                                              style: TextStyle(
                                                  fontSize: Resizable.font(
                                                      context, 18),
                                                  fontWeight: //item == items[s]
                                                      // ? FontWeight.w800
                                                      // :
                                                      FontWeight.w500))))
                                      .toList(),
                                  value: items[attendId],
                                  onChanged: (v) {
                                    cubit.update(items.indexOf(v.toString()),
                                        studentModel.userId);
                                  },
                                  buttonHeight: Resizable.size(context, 20),
                                  buttonWidth: double.maxFinite,
                                ),
                              ))
                        ],
                      )),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            ));
  }
}

class DropdownAttendanceCubit extends Cubit<int> {
  DropdownAttendanceCubit() : super(0);

  load(int id, context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    await teacherRepository.getStudentLesson(
        id, int.parse(TextUtils.getName()));
  }

  update(int attendId, int id) async {
    await FirebaseFirestore.instance
        .collection('student_lesson')
        .doc("student_${id}_lesson_${int.parse(TextUtils.getName())}")
        .update({
      'time_keeping': attendId,
    });
    emit(attendId);
  }
}
