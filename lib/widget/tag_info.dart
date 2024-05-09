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

import '../configs/text_configs.dart';
import '../features/admin/manage_tag/custom_button_v1.dart';
import '../features/admin/search/general_tags/add_tag_filter_dialog.dart';
import '../model/tag_model.dart';
import '../utils/dialogs.dart';


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}


class TagInfo extends StatelessWidget {
  TagInfo({super.key, required this.type, required this.ownId});

  final int type;
  final int ownId;
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
        BlocProvider(
          create: (context) => TagInfoCubit(type, ownId)..load(),
          child: BlocBuilder<TagInfoCubit, int>(
            builder: (context, state) {
              if (state == 0) {
                return SizedBox(
                  height: Resizable.size(context, 20),
                  child: Center(
                    child: Transform.scale(
                        scale: 0.6, child: const CircularProgressIndicator()),
                  ),
                );
              }
              final cubit = context.read<TagInfoCubit>();
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
                                Dialogs.alertDelete(context,
                                   type == 3 ?  AppText.txtConfirmDeleteTagFromClass.text : type == 2 ? AppText.txtConfirmDeleteTagFromStudent.text : AppText.txtConfirmDeleteTagFromTeacher.text ,
                                    () async {
                                  bool value = await cubit.deleteTag(e);
                                  if (context.mounted) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtDeleteSuccess.text);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtError.text);
                                    }
                                    Navigator.pop(context);
                                  }
                                });
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

class TagInfoCubit extends Cubit<int> {
  TagInfoCubit(this.type, this.ownId) : super(0);
  final int type;
  final int ownId;
  List<TagModel> listTags = [];
  ManageTagModel? manageTags;

  Future<List<TagModel>> getTags(List<int> list) async {
    List<Future<TagModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getTagById(item));
    }
    List<TagModel> tags = await Future.wait(futures);
    return tags;
  }

  Future<bool> changeListTag(List<TagModel> value) async {
    var result = false;
    if (manageTags != null) {
      result =
          await FireBaseProvider.instance.addManageTag(manageTags!.copyWith(
        tags: value.map((e) => e.id).toList(),
      ));
    } else {
      manageTags = ManageTagModel(
        date: DateTime.now().millisecondsSinceEpoch,
        type: type,
        ownId: ownId,
        tags: value.map((e) => e.id).toList(),
      );
      result = await FireBaseProvider.instance.addManageTag(manageTags!);
    }
    if (result) {
      listTags = [...value];
      emit(state + 1);
    }
    return result;
  }

  Future<bool> deleteTag(TagModel tag) async {
    var result = false;
    if (manageTags != null) {
      var tags = [...listTags];
      tags.remove(tag);
      if (tags.isEmpty) {
        result =
            await FireBaseProvider.instance.deleteManageTag(manageTags!.date);
        manageTags = null;
      } else {
        result =
            await FireBaseProvider.instance.addManageTag(manageTags!.copyWith(
          tags: tags.map((e) => e.id).toList(),
        ));
      }

      if (result) {
        listTags.remove(tag);
        emit(state + 1);
      }
    }
    return result;
  }

  load() async {
    manageTags =
        await FireBaseProvider.instance.getManageTagByIdAndType(ownId, type);
    if (manageTags != null) {
      listTags = await getTags(manageTags!.tags.map((e) => e as int).toList());
    }

    emit(state + 1);
  }
}
