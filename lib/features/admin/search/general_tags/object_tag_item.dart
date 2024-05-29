import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/functions.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../../model/tag_model.dart';
import '../../../../widget/chip_tag.dart';

class ObjectTagItem extends StatelessWidget {
  const ObjectTagItem({super.key, required this.onTap, required this.title, required this.description, required this.prefixIcon, required this.tags,  required this.notes});
  final Function() onTap;
  final String title;
  final String description;
  final Widget prefixIcon;
  final List<TagModel> tags;
  final Map<int, String> notes;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: Resizable.size(context, 50),
      ),
      margin: EdgeInsets.only(
        bottom: Resizable.padding(context, 5)
      ),
      decoration: BoxDecoration(
        border: Border.all(color: grey2),
        borderRadius: BorderRadius.circular(5),
      ),
      child:Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              prefixIcon,
              Expanded(
                flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: Resizable.padding(context, 2)),
                      Text(
                         description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: const Color(0xFF757575),
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w600))
                    ],
                  )),
              SizedBox(width: Resizable.padding(context, 10),),
              Expanded(
                flex:2,
                child: Builder(builder: (context) {
                List<Widget> children = [];
                var list = [...tags];
                for (var item in list) {
                  children.add(ChipTag(
                    onTap: () {

                    },
                    name: item.name,
                    color: item.background,
                    description: Functions.getValue(notes, item.id),
                  ));
                }
                return Padding(
                  padding: EdgeInsets.all(
                     Resizable.padding(context, 10),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    runSpacing: Resizable.padding(context, 5),
                    spacing: Resizable.padding(context, 5),
                    children: [...children],
                  ),
                );
              }),)
            ],
          ),
        ),
      ),
    );
  }
}

