import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import '../manage_general_cubit.dart';

class ConfirmChangeClassStatus extends StatelessWidget {
  const ConfirmChangeClassStatus(this.classModel, this.newStatus,this.cubit,{Key? key}) : super(key: key);
  final ClassModel classModel;
  final String newStatus;
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppText.txtConfirmChangeStatus.text.replaceAll("@", classModel.classCode).replaceAll("#", newStatus).replaceAll("%", classModel.classStatus), style: const TextStyle(
          fontWeight: FontWeight.bold
      ),),
      titlePadding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset('assets/images/ic_edit.png' , height: Resizable.size(context, 120),),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(onPress: (){
          Navigator.pop(context);
        }, bgColor: Colors.white, foreColor: Colors.black, text: AppText.txtBack.text),

        CustomButton(onPress: () async{
          FirebaseFirestore.instance
              .collection('class')
              .doc('class_${classModel.classId}_course_${classModel.courseId}')
              .update({
            'class_status': newStatus
          }).whenComplete(() {
            cubit.loadAfterChangeClassStatus(classModel, newStatus, context);
            Navigator.pop(context);
          });
        }, bgColor: primaryColor.shade500, foreColor: Colors.white, text: AppText.txtAgree.text),
      ],
    );
  }
}