import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/add_tag_filter_cubit.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';

import '../../../../configs/color_configs.dart';
import '../../../../model/tag_model.dart';
import '../../../../utils/resizable.dart';
import '../../../../widget/chip_tag.dart';
import '../../manage_tag/group_item.dart';

class AddTagFilterContent extends StatelessWidget {
  const AddTagFilterContent(
      {super.key,
      required this.addTagFilterCubit,});

  final AddTagFilterCubit addTagFilterCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 5,
            child: ListView(
              shrinkWrap: true,
              children: [
                ...addTagFilterCubit.listGroupTags.map((e) {
                  final index = addTagFilterCubit.listGroupTags.indexOf(e);
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                    child: GroupItem(
                      isFocus: index == addTagFilterCubit.currentIndex,
                      title: e.name,
                      onEdit: null,
                      onDelete: null,
                      onClick: () {
                        addTagFilterCubit.setCurrentIndex(index);
                      },
                    ),
                  );
                })
              ],
            )),
        SizedBox(
          width: Resizable.padding(context, 10),
        ),
        Expanded(
            flex: 6,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: grey2),
                  borderRadius: BorderRadius.circular(5)),
              child: Builder(builder: (context) {
                List<Widget> children = [];
                var list = [...addTagFilterCubit.listCurrentTags];
                list.removeWhere((element) =>
                    addTagFilterCubit.listChooseTags.map((e) => e.id).contains(element.id));
                for (var item in list) {
                  children.add(ChipTag(
                    onTap: () {
                      addTagFilterCubit.addTag(item);
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
              }),
            )),
      ],
    );
  }
}
