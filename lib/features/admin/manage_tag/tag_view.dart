import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_tag_dialog.dart';
import 'package:internal_sakumi/model/tag_model.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import '../manage_general/dotted_border_button.dart';
import 'manage_tag_cubit.dart';

class TagView extends StatelessWidget {
  const TagView({super.key, required this.manageTagCubit});

  final ManageTagCubit manageTagCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            AppText.txtManageTag.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w600,
                color: darkPrimaryColor),
          ),
        ),
        SizedBox(
          height: Resizable.size(context, 10),
        ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: manageTagCubit.listGroupTags.isEmpty ? Colors.transparent : greyAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(Resizable.padding(context, 15)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (manageTagCubit.listGroupTags.isNotEmpty)
                    Container(
                      constraints:
                          BoxConstraints(minHeight: Resizable.size(context, 100)),
                      padding: EdgeInsets.all(Resizable.padding(context, 10)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Tag',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Expanded(
                                child: Divider(
                                  color: greyAccent,
                                  indent: Resizable.padding(context, 5),
                                  endIndent: Resizable.padding(context, 5),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: Resizable.padding(context, 5),),
                          Builder(builder: (context) {
                            List<Widget> children = [];
                            for (var item in manageTagCubit.listCurrentTags) {
                              children.add(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(context: context, builder: (context) {
                                        return AddTagDialog(
                                          manageTagCubit: manageTagCubit,
                                          tagModel: item,
                                        );
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Container(
                                      height: Resizable.size(context, 17),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Resizable.padding(context, 10),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(item.background),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),

                                      child: Center(
                                        child: Text(
                                          item.name,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: Resizable.font(context, 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                            }
                            children.add(DottedBorderRadiusButton(
                              '+ ${AppText.btnAddTag.text}',
                              onPressed: () {
                                  showDialog(context: context, builder: (context) {
                                    return AddTagDialog(
                                      manageTagCubit: manageTagCubit,
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
            ),
          )
      ],
    );
  }
}
