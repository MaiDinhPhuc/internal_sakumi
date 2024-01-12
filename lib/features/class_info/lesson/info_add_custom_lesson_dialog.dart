import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InfoAddCustomLesson extends StatelessWidget {
  const InfoAddCustomLesson({super.key, required this.desCon, required this.titleCon});
  final TextEditingController desCon, titleCon;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.txtTitle.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: const Color(0xff757575))),
              InputField(
                  controller: titleCon)
            ],
          ),
          InputItem(
              title: AppText.txtDescription.text,
              controller: desCon,
              isExpand: true),
        ],
      ),
    );
  }
}
