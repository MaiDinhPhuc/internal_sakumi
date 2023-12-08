import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DropDownWidget extends StatelessWidget {
  final int userId, selectorId;
  final List<String> items;
  final Function(String? v) onPressed;
  const DropDownWidget(this.userId,
      {required this.selectorId, required this.items, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        icon: const Icon(Icons.keyboard_arrow_down),
        buttonPadding: EdgeInsets.symmetric(
            vertical: Resizable.size(context, 0),
            horizontal: Resizable.padding(context, 10)),
        buttonDecoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: Resizable.size(context, 2),
                  color: selectorId! > 0 ? greyColor.shade100 : primaryColor)
            ],
            border: Border.all(
                color: selectorId > 0 ? greyColor.shade100 : primaryColor),
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
        value: items[selectorId],
        onChanged: onPressed,
        buttonHeight: Resizable.size(context, 20),
        buttonWidth: double.maxFinite,
      ),
    );
  }
}

class DropdownAttendanceCubit extends Cubit<int> {
  final int userId;
  DropdownAttendanceCubit(this.userId) : super(userId);

  updateAttendance(int attendId, int id,int classId, int lessonId, context) async {
    await FireBaseProvider.instance.updateTimekeeping(
        id,lessonId, classId,
        // int.parse(TextUtils.getName()),
        // int.parse(TextUtils.getName(position: 1)),
        attendId);
    emit(attendId);
  }

  updateStudentStatus(String type, int point, int id)async{

    await FireBaseProvider.instance.updateStudentStatus(id, int.parse(TextUtils.getName(position: 1)), point, type);

    emit(point);
  }
}
