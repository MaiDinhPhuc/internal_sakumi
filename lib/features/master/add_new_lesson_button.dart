import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class AddNewLessonButton extends StatelessWidget {
  const AddNewLessonButton(this.onPress,this.isEdit,{super.key});
  final Function() onPress;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: Resizable.size(context, 100)),
      child: SubmitButton(
          onPressed: onPress,
          title: isEdit ? AppText.btnUpdate.text : AppText.btnAdd.text),
    );
  }
}
