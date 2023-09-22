import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';


class ConfirmDeleteClass extends StatelessWidget {
  const ConfirmDeleteClass(this.classModel, this.onPress,{Key? key}) : super(key: key);
  final ClassModel classModel;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppText.txtConfirmChangeStatus.text.replaceAll("@", classModel.classCode), style: const TextStyle(
          fontWeight: FontWeight.bold
      ),),
      titlePadding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset('assets/images/ic_delete.png' , height: Resizable.size(context, 120),),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(onPress: (){
          Navigator.pop(context);
        }, bgColor: Colors.white, foreColor: Colors.black, text: AppText.txtBack.text),
        CustomButton(onPress: onPress, bgColor: primaryColor.shade500, foreColor: Colors.white, text: AppText.txtAgree.text),
      ],
    );
  }
}