import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_course_suggest/manage_course_suggest_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import '../../../widget/chip_tag.dart';
import '../../admin/manage_general/dotted_border_button.dart';
import '../../admin/search/general_tags/add_tag_filter_dialog.dart';
import 'cs_option_cubit.dart';

class CSTagView extends StatelessWidget {
  const CSTagView({super.key, required this.csOptionCubit, required this.manageCSCubit});

  final CSOptionCubit csOptionCubit;
  final ManageCourseSuggestCubit manageCSCubit;
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: manageCSCubit.courseSuggests.isEmpty ? Colors.transparent : greyAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(Resizable.padding(context, 15)),
      child: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (manageCSCubit.courseSuggests.isNotEmpty)
              Container(
                constraints:
                BoxConstraints(minHeight: Resizable.size(context, 100)),
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Tag',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Divider(
                            color: grey2,
                            indent: Resizable.padding(context, 5),
                            endIndent: Resizable.padding(context, 5),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Resizable.padding(context, 5),
                    ),
                    Builder(builder: (context) {
                      List<Widget> children = [];
                      for (var item in csOptionCubit.tags) {
                        children.add(SizedBox(
                          height: Resizable.size(context, 20),
                          child: FittedBox(
                            child: ChipTag(
                              onTap: () {},
                              onDelete: () {
                                csOptionCubit.deleteTagItem(item);
                              },
                              color: item.background,
                              name: item.name,
                              description: item.description,
                            ),
                          ),
                        ));
                      }
                      children.add(DottedBorderRadiusButton(
                        '+ ${AppText.btnAddTag.text}',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddTagFilterDialog(
                                  listOldTags: csOptionCubit.tags,
                                  notes: const {},
                                  isFilter: true,
                                  onFinish: (tags, notes) async  {
                                    final value = await csOptionCubit.changeListTag(tags);
                                    if (context.mounted) {
                                      if (value) {
                                        Fluttertoast.showToast(
                                            msg: AppText.txtAddTagSuccess.text);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: AppText.txtError.text);
                                      }
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              });
                        },
                      ));
                      return Wrap(
                        runSpacing: Resizable.padding(context, 5),
                        spacing: Resizable.padding(context, 5),
                        children: [...children],
                      );
                    }),
                  ],
                ),
              ),
            if (manageCSCubit.currentCS != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("Khoá học yêu thích",
                    style: TextStyle(fontSize: Resizable.font(context, 20))),
                value: csOptionCubit.favorite,
                onChanged: (newValue) {
                  manageCSCubit.updateFavorite();
                  csOptionCubit.update();
                },
              ),
          ],
        ),
      ),
    );
  }
}