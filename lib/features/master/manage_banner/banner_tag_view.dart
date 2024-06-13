import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_banner/manage_banner_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import '../../../widget/chip_tag.dart';
import '../../admin/manage_general/dotted_border_button.dart';
import '../../admin/search/general_tags/add_tag_filter_dialog.dart';
import 'banner_option_cubit.dart';

class BannerTagView extends StatelessWidget {
  const BannerTagView({super.key, required this.bannerOptionCubit, required this.manageBannerCubit});

  final BannerOptionCubit bannerOptionCubit;
  final ManageBannerCubit manageBannerCubit;
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: manageBannerCubit.banners.isEmpty ? Colors.transparent : greyAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(Resizable.padding(context, 15)),
      child: SingleChildScrollView(
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (manageBannerCubit.banners.isNotEmpty)
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
                      for (var item in bannerOptionCubit.tags) {
                        children.add(SizedBox(
                          height: Resizable.size(context, 20),
                          child: FittedBox(
                            child: ChipTag(
                              onTap: () {},
                              onDelete: () {
                                bannerOptionCubit.deleteTagItem(item);
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
                                  listOldTags: bannerOptionCubit.tags,
                                  notes: const {},
                                  isFilter: true,
                                  onFinish: (tags, notes) async  {
                                    final value = await bannerOptionCubit.changeListTag(tags);
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
          ],
        ),
      ),
    );
  }
}
