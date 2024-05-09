import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/add_tag_filter_content.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/add_tag_filter_cubit.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_chosen.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';

import '../../../../configs/text_configs.dart';
import '../../../../model/tag_model.dart';
import '../../../../utils/resizable.dart';
import '../../manage_tag/custom_button_v1.dart';
import '../../manage_tag/group_item.dart';

class AddTagFilterDialog extends StatelessWidget {
  const AddTagFilterDialog(
      {super.key, required this.onFinish, required this.listOldTags});

  final Function(List<TagModel>) onFinish;
  final List<TagModel> listOldTags;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        insetPadding:
            EdgeInsets.symmetric(vertical: Resizable.padding(context, 60)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: Container(
            padding: EdgeInsets.all(Resizable.padding(context, 20)),
            width: MediaQuery.of(context).size.width * 0.5,
            child: BlocProvider(
              create: (context) => AddTagFilterCubit(listOldTags)..load(),
              child: BlocBuilder<AddTagFilterCubit, int>(
                builder: (context, state) {
                  if (state == 0) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final addTagFilterCubit = context.read<AddTagFilterCubit>();
                  final isDataChange = areListsDifferent(
                      listOldTags.map((e) => e.id).toList(),
                      addTagFilterCubit.listChooseTags
                          .map((e) => e.id)
                          .toList());
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppText.txtAddTag.text.toUpperCase(),
                          style: TextStyle(
                              fontSize: Resizable.font(context, 22),
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 20),
                      ),
                      SizedBox(
                        height: Resizable.size(context, 160),
                        child: AddTagFilterContent(
                          addTagFilterCubit: addTagFilterCubit,
                        ),
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 20),
                      ),
                      const Divider(
                        color: grey2,
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 10),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppText.txtTagChoosen.text.toUpperCase(),
                          style: TextStyle(
                              fontSize: Resizable.font(context, 22),
                              fontWeight: FontWeight.w700,
                              color: primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 10),
                      ),
                      Expanded(
                          child: TagChosen(
                        addTagFilterCubit: addTagFilterCubit,
                      )),
                      SizedBox(
                        height: Resizable.padding(context, 10),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtonV1(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                border: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                title: AppText.btnCancel.text),
                            SizedBox(
                              width: Resizable.padding(context, 5),
                            ),
                            CustomButtonV1(
                                onPressed: () async {
                                  if (addTagFilterCubit
                                      .listChooseTags.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg:
                                            AppText.txtAtLeast1TagChoosen.text);
                                    return;
                                  }
                                  if (!isDataChange) {
                                    Fluttertoast.showToast(
                                        msg:
                                            AppText.txtDataNotChange.text);
                                    return;
                                  }
                                  await onFinish(
                                      addTagFilterCubit.listChooseTags);
                                },
                                textColor: Colors.white,
                                backgroundColor: primaryColor,
                                title: AppText.btnAdd.text),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            )));
  }
}

bool areListsDifferent(List<int> list1, List<int> list2) {
  // check if both are lists
  if (list1.length != list2.length) {
    return true;
  }

  for (var item in list1) {
    if (!list2.contains(item)) {
      return true;
    }
  }

  return false;
}
