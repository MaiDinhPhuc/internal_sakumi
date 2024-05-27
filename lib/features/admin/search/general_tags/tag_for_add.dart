import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/manage_tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/chip_tag.dart';

import '../../../../configs/text_configs.dart';
import '../../../../model/tag_model.dart';
import '../../../../utils/dialogs.dart';
import '../../../../widget/tag_info.dart';
import '../../manage_tag/custom_button_v1.dart';
import 'add_tag_filter_dialog.dart';



class TagForAdd extends StatelessWidget {
  TagForAdd({super.key, required this.type, required this.cubit});

  final int type;
  final TagForAddCubit cubit;
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: grey2,
        ),
        SizedBox(
          height: Resizable.padding(context, 5),
        ),
        BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            return SizedBox(
              height: Resizable.size(context, 20),
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView(
                  controller: controller,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...cubit.listTags.map((e) => Padding(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 5)),
                      child: ChipTag(
                        onTap: () {},
                        color: e.background,
                        name: e.name,
                        description: e.description,
                        onDelete: () {
                          cubit.deleteTag(e);
                        },
                      ),
                    )),
                    CustomButtonV1(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddTagFilterDialog(
                                listOldTags: cubit.listTags,
                                onFinish: (tags) async  {
                                  final value = await cubit.changeListTag(tags);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            });
                      },
                      title: AppText.txtAddTag.text,
                      prefixIcon: Icon(Icons.add,
                          color: primaryColor,
                          size: Resizable.size(context, 10)),
                      textColor: darkPrimaryColor,
                      backgroundColor: Colors.white,
                      border: darkPrimaryColor,
                      fontWeight: FontWeight.w500,
                      paddingHorizontal: 15,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: Resizable.padding(context, 5),
        ),
        const Divider(
          color: grey2,
        )
      ],
    );
  }
}

class TagForAddCubit extends Cubit<int> {
  TagForAddCubit(this.type) : super(0);
  final int type;
  List<TagModel> listTags = [];

  Future<List<TagModel>> getTags(List<int> list) async {
    List<Future<TagModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getTagById(item));
    }
    List<TagModel> tags = await Future.wait(futures);
    return tags;
  }

  Future<bool> changeListTag(List<TagModel> value) async {
    listTags = [...value];
    emit(state + 1);
    return true;
  }

  Future<bool> deleteTag(TagModel tag) async {
    listTags.remove(tag);
    emit(state +1);
    return true;
  }
  Future<bool> addListTags(int ownId) async {
    var result = false;
    var manageTags = ManageTagModel(
      date: DateTime.now().millisecondsSinceEpoch,
      type: type,
      ownId: ownId,
      tags: listTags.map((e) => e.id).toList(),
    );
    result = await FireBaseProvider.instance.addManageTag(manageTags);
    return result;
  }
  load() async {
    emit(state + 1);
  }
}
