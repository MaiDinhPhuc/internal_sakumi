import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_tag/custom_button_v1.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/add_tag_filter_dialog.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';

import '../../../../configs/text_configs.dart';
import '../../../../services/custom_firebase_firestore.dart';
import '../../../../utils/resizable.dart';
import '../../../../widget/chip_tag.dart';

class TagFilterPart1 extends StatelessWidget {
  const TagFilterPart1({super.key});


  @override
  Widget build(BuildContext context) {
    final tagFilterCubit = context.watch<TagFilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Resizable.size(context, 50),
          padding: EdgeInsets.all(Resizable.padding(context, 15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.txtTagManager.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              CustomButtonV1(
                onPressed: () async {
                  showDialog(context: context, builder: (context) {
                    return AddTagFilterDialog(
                      listOldTags: tagFilterCubit.listFilterTags,
                      onFinish: (tags) {
                        tagFilterCubit.changeListTag(tags);
                        Navigator.pop(context);
                      },
                    );
                  });
                },
                title: '+ ${AppText.txtAddTag.text}',
                textColor: darkPrimaryColor,
                backgroundColor: Colors.white,
                border: darkPrimaryColor,
                fontWeight: FontWeight.w500,
                paddingHorizontal: 15,
              )
            ],
          ),
        ),
        Divider(
          color: grey2,
          endIndent: Resizable.padding(context, 15),
          indent: Resizable.padding(context, 15),
        ),
        Expanded(
            child: tagFilterCubit.listFilterTags.isEmpty
                ? const Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                      'Team hãy thêm tag để có thể tìm kiếm thông tin nhanh hơn.',
                      textAlign: TextAlign.center,
                                        ),
                    ))
                : Builder(builder: (context) {
              List<Widget> children = [];

              var list = [...tagFilterCubit.listFilterTags];
              for (var item in list) {
                children.add(ChipTag(
                  onTap: () {

                  },
                  onDelete: () {
                    tagFilterCubit.deleteTag(item);
                  },
                  name: item.name,
                  color: item.background,
                  description: item.description,
                ));
              }
              return SingleChildScrollView(
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                child: Wrap(
                  runSpacing: Resizable.padding(context, 5),
                  spacing: Resizable.padding(context, 5),
                  children: [...children],
                ),
              );
            }),)
      ],
    );
  }
}
