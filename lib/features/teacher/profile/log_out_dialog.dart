import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import '../../../configs/text_configs.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppText.txtTeacherLogOut.text, style: const TextStyle(
        fontWeight: FontWeight.bold
      ),),
      titlePadding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset('assets/images/ic_thumb_up.png' , height: Resizable.size(context, 120),),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(onPress: (){
          Navigator.pop(context);
        }, bgColor: Colors.white, foreColor: Colors.black, text: AppText.txtBack.text),

        CustomButton(onPress: () async{
          FireBaseProvider.instance.logOutUser(context);
        }, bgColor: primaryColor.shade500, foreColor: Colors.white, text: AppText.txtAgree.text),
      ],
    );
  }
}
