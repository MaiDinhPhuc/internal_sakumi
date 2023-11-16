import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseQuestion extends StatelessWidget {
  const CollapseQuestion({Key? key, required this.onPress, required this.state}) : super(key: key);
  final Function() onPress;
  final int state;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(AppText.titleQuestion.text,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 18))),
      IconButton(
          onPressed: onPress,
          splashRadius: Resizable.size(context, 15),
          icon: Icon(
            state % 2 == 0
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ))
    ]);
  }
}
