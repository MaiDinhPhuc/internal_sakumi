import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/lesson/lesson_item_cubit_v2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

class ConfirmDeleteCustomLesson extends StatelessWidget {
  const ConfirmDeleteCustomLesson(this.cubit,
      {Key? key, required this.lessonModel})
      : super(key: key);

  final LessonItemCubitV2 cubit;
  final LessonModel lessonModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmDeleteCustomLesson.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      titlePadding:
      EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset(
        'assets/images/ic_delete.png',
        height: Resizable.size(context, 120),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            onPress: () {
              Navigator.pop(context);
            },
            bgColor: Colors.white,
            foreColor: Colors.black,
            text: AppText.txtBack.text),
        CustomButton(
            onPress: () async {
              cubit.updateClass(cubit.cubit, lessonModel);
              Navigator.pop(context);
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}