import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseTeacherItem extends StatelessWidget {
  const CollapseTeacherItem({super.key, required this.teacher, required this.onPress, required this.state});
  final TeacherModel teacher;
  final Function() onPress;
  final int state;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SmallAvatar(teacher.url),
            SizedBox(width: Resizable.padding(context, 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Resizable.font(context, 16),
                        color: Colors.black)),
                SizedBox(height: Resizable.padding(context, 3)),
                Text(teacher.teacherCode,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Resizable.font(context, 13),
                        color: const Color(0xff757575)))
              ],
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(AppText.textDetail.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 18))),
          IconButton(
              onPressed: onPress,
              splashRadius: Resizable.size(context, 10),
              icon: Icon(
                state % 2 == 1
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ))
        ])
      ],
    );
  }
}
