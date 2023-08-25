import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../utils/resizable.dart';

class InputCustom extends StatelessWidget {
  const InputCustom(
      {Key? key,
      required this.title,
      required this.isFocus,
      required this.isEdit,
      required this.item,
      required this.controller,
      required this.cubit,
      required this.index,
      required this.type,
      required this.focusNode})
      : super(key: key);
  final String title;
  final bool isFocus;
  final bool isEdit;
  final Map<String, dynamic> item;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TeacherProfileCubit cubit;
  final int index;
  final String type;

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        cubit.setFocus(type, index , true);
      }
      else {
        cubit.setFocus(type, index , false);
      }
    });
    controller.addListener(() {
      cubit.checkText(controller.text, index, type);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: Resizable.font(context, 20),
              fontWeight: FontWeight.bold,
              color: greyColor.shade600),
        ),
        SizedBox(
          height: Resizable.size(context, 5),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: (isEdit && isFocus)
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(
                          0, 4), // changes the position of the shadow
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              fillColor: isEdit ? Colors.white : greyColor.shade50,
              filled: true,
              enabled: type == 'info' ? !(isEdit && !item['isEdit']) : true,
              suffixIcon: type == 'info' ? null : GestureDetector(
                onTap: (){
                    cubit.hidePass(index);
                },
                child: Icon(item['isShowPass'] ? Icons.visibility_rounded : Icons.visibility_off_rounded),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 5),
                  vertical: Resizable.padding(context, 5)),
            ),
            style: TextStyle(
                fontSize: Resizable.font(context, 18),
                fontWeight: FontWeight.bold),
            readOnly: type == 'info' ? !isEdit : (!isEdit || !item['isEdit']),
            controller: controller,
            focusNode: focusNode,
            obscureText: type == 'info' ? false : !item['isShowPass'],
            obscuringCharacter: '*',
            validator: (value) {
              return getValidate(value, type);
            },
          ),
        ),
        SizedBox(
          height: Resizable.size(context, 5),
        ),
      ],
    );
  }

  String? getValidate(String? value, String type) {
   if(type == 'info') {
     if (value == null ||
         controller.text.isEmpty ||
         controller.text == null) {
       return 'Dữ liệu không hợp lệ';
     }
   }
   else {
     if (value == null ||
         controller.text.isEmpty ||
         controller.text == null) {
       return 'Mật khẩu trống';
     }
     if(controller.text.length < 6) {
       return 'Mật khẩu có ít nhất 6 kí tự';
     }
     if(index == 2) {
       final againPass = controller.text;
       final newPass = cubit.listPassWordField![1]['controller'].text;
       if(againPass != newPass) return 'Nhập lại mật khẩu không khớp';
     }
   }
    return null;
  }
}
