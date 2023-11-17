import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseTeacherNote extends StatelessWidget {
  const CollapseTeacherNote({super.key, required this.onPress, required this.state});
  final Function() onPress;
  final int state;
  @override
  Widget build(BuildContext context) {
    return Row( children: [
      Text(AppText.txtTeacherNote.text,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 18))),
      IconButton(
          onPressed: onPress,
          splashRadius: Resizable.size(context, 10),
          icon: Icon(
            state % 2 == 0
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ))
    ]);
  }
}
