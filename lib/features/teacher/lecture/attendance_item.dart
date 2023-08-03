import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class AttendanceItem extends StatelessWidget {
  final StudentModel studentModel;
  final int attendId;
  final List<String> items;
  const AttendanceItem(this.studentModel, this.attendId,
      {required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownAttendanceCubit(attendId),
        child: BlocBuilder<DropdownAttendanceCubit, int>(
            builder: (c, s) => Container(
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
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 3,
                          child: Text(
                            studentModel.name,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20)),
                          )),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                  flex: 2,
                                  child: DropDownWidget(
                                      attendId, studentModel.userId,
                                      items: items))
                            ],
                          )),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                )));
  }
}

class DropDownWidget extends StatelessWidget {
  final int attendId, userId;
  final List<String> items;
  const DropDownWidget(this.attendId, this.userId,
      {required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownAttendanceCubit(attendId),
        child: BlocBuilder<DropdownAttendanceCubit, int>(
            builder: (c, s) => DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    buttonPadding: EdgeInsets.symmetric(
                        vertical: Resizable.size(context, 0),
                        horizontal: Resizable.padding(context, 10)),
                    buttonDecoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: Resizable.size(context, 2),
                              color: s > 0 ? greyColor.shade100 : primaryColor)
                        ],
                        border: Border.all(
                            color: s > 0 ? greyColor.shade100 : primaryColor),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1000)),
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
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w500))))
                        .toList(),
                    value: items[s],
                    onChanged: (v) {
                      s = items.indexOf(v.toString());
                      BlocProvider.of<DropdownAttendanceCubit>(c)
                          .update(items.indexOf(v.toString()), userId, c);
                      if (items.length == 7) {
                        BlocProvider.of<SessionCubit>(c).updateTimekeeping(s);
                      }
                    },
                    buttonHeight: Resizable.size(context, 20),
                    buttonWidth: double.maxFinite,
                  ),
                )));
  }
}

class DropdownAttendanceCubit extends Cubit<int> {
  final int attendId;
  DropdownAttendanceCubit(this.attendId) : super(attendId);

  update(int attendId, int id, context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    await teacherRepository.updateTimekeeping(
        id,
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)),
        attendId);
    emit(attendId);
    debugPrint(
        '=============> attendId : $id === $attendId === ${this.attendId}');
  }
}
