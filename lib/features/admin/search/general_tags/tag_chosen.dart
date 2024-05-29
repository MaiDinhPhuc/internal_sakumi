import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';

import '../../../../configs/color_configs.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/resizable.dart';
import '../../../../widget/chip_tag.dart';
import 'add_tag_filter_cubit.dart';

class TagChosen extends StatelessWidget {
  const TagChosen(
      {super.key, required this.addTagFilterCubit});

  final AddTagFilterCubit addTagFilterCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(
            color: grey2,
          )
      ),
      child: Builder(builder: (context) {
        List<Widget> children = [];
        var list = [...addTagFilterCubit.listChooseTags];
        for (var item in list) {
          children.add(ChipTag(
            onTap: () {

            },
            onDelete: () {
              addTagFilterCubit.deleteTag(item);
            },
            name: item.name,
            color: item.background,
            description: Functions.getValue(addTagFilterCubit.notes, item.id)
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
      }),
    );
  }
}
