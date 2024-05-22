import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/model/tag_model.dart';

import '../configs/text_configs.dart';
import '../utils/resizable.dart';
import 'chip_tag.dart';

class TagForList extends StatelessWidget {
  const TagForList({super.key, required this.listTags});
  final List<TagModel> listTags;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${AppText.txtTag.text}:',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize:
                Resizable.font(context, 19))),
        SizedBox(
            width: Resizable.padding(context, 10)),
        Expanded(
          child: Builder(builder: (context) {
            List<Widget> children = [];
            var list = [...listTags];
            for (var item in list) {
              children.add(ChipTag(
                onTap: () {},
                name: item.name,
                color: item.background,
                description: item.description,
              ));
            }
            return Padding(
              padding: EdgeInsets.all(
                Resizable.padding(context, 10),
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing:
                Resizable.padding(context, 5),
                spacing:
                Resizable.padding(context, 5),
                children: [...children],
              ),
            );
          }),
        )
      ],
    );
  }
}
