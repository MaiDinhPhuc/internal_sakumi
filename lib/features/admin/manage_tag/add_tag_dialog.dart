import 'dart:math';

import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_tag_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';
import 'package:internal_sakumi/model/tag_model.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/enum.dart';
import '../../../utils/resizable.dart';
import '../manage_general/input_form/input_field.dart';
import 'custom_button_v1.dart';

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({super.key, required this.manageTagCubit, this.tagModel});

  final ManageTagCubit manageTagCubit;
  final TagModel? tagModel;

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TagModel? tag;
  Color pickerColor = Colors.black;

  bool get isEdit => widget.tagModel != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      nameCon.text = widget.tagModel!.name;
      codeCon.text = widget.tagModel!.code;
      desCon.text = widget.tagModel!.description;
    }
  }

  void changeColor(Color value) {
    setState(() => pickerColor = value);
  }

  void showColorPicker(BuildContext context, AddTagCubit addTagCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${AppText.btnChooseColor.text}!',
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            CustomButtonV1(
                onPressed: () {
                  Navigator.pop(context);
                },
                border: Colors.black,
                textColor: Colors.black,
                backgroundColor: Colors.white,
                title: AppText.btnCancel.text),
            SizedBox(
              width: Resizable.padding(context, 3),
            ),
            CustomButtonV1(
                onPressed: () {
                  if (addTagCubit.colors.contains(pickerColor)) {
                    Fluttertoast.showToast(msg: AppText.txtColorExist.text);
                    return;
                  }
                  addTagCubit.addNewColor(pickerColor);
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                backgroundColor: primaryColor,
                title: AppText.txtChoose.text),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTagCubit()..load(widget.tagModel),
      child: BlocConsumer<AddTagCubit, int>(
        listener: (context, state) {
          final addTagCubit = context.read<AddTagCubit>();
          if (addTagCubit.status == SubmitStatus.success) {
            if (addTagCubit.isDelete) {
              widget.manageTagCubit.deleteTag(widget.tagModel!);
              Fluttertoast.showToast(msg: AppText.txtDeleteTagSuccess.text);
            } else {
              widget.manageTagCubit.updateTag(tag!, isEdit);
              Fluttertoast.showToast(
                  msg: isEdit
                      ? AppText.txtUpdateTagSuccess.text
                      : AppText.txtAddTagSuccess.text);
            }
          } else if (addTagCubit.status == SubmitStatus.error) {
            Fluttertoast.showToast(msg: AppText.txtError.text);
          }
        },
        builder: (context, state) {
          return BlocBuilder<AddTagCubit, int>(
            builder: (context, state) {
              final addTagCubit = context.read<AddTagCubit>();
              return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 16))),
                  child: Container(
                      padding: EdgeInsets.all(Resizable.padding(context, 20)),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 10)),
                              child: Text(
                                isEdit
                                    ? AppText.btnEditTag.text.toUpperCase()
                                    : AppText.btnAddTag.text.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: InputItem(
                                      title: AppText.txtNameTag.text,
                                      controller: nameCon,
                                      errorText:
                                          AppText.txtPleaseInputTagName.text),
                                ),
                                SizedBox(
                                  width: Resizable.padding(context, 10),
                                ),
                                Flexible(
                                  child: InputItem(
                                    title: AppText.txtCode.text,
                                    controller: codeCon,
                                    enabled: isEdit ? false : true,
                                    onValidate: (value) {
                                      if (isEdit) return null;
                                      if (value == null || value.isEmpty) {
                                        return AppText
                                            .txtPleaseInputTagCode.text;
                                      }
                                      if (widget.manageTagCubit
                                          .checkCodeTagExist(value)) {
                                        return AppText.txtCodeExist.text;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            InputItem(
                              title: AppText.txtDescription.text,
                              controller: desCon,
                              onValidate: (value) {
                                return null;
                              },
                              isExpand: true,
                            ),
                            ...[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(AppText.txtColor.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                              ),
                              SizedBox(
                                height: Resizable.size(context, 30),
                                child: Builder(builder: (context) {
                                  var widgets = <Widget>[];
                                  widgets.addAll(addTagCubit.colors.map((e) {
                                    final index = addTagCubit.colors.indexOf(e);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          addTagCubit.setCurrentColor(index);
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: Resizable.size(context, 25),
                                          height: Resizable.size(context, 25),
                                          padding: EdgeInsets.all(
                                              Resizable.padding(context, 1)),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    offset: const Offset(0, 3),
                                                    blurRadius: 3)
                                              ]),
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: e,
                                              ),
                                              if (index ==
                                                  addTagCubit.currentColor)
                                                const Positioned.fill(
                                                    child: Center(
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList());
                                  widgets.add(InkWell(
                                    onTap: () {
                                      showColorPicker(context, addTagCubit);
                                    },
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Container(
                                      width: Resizable.size(context, 25),
                                      height: Resizable.size(context, 25),
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 1)),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffd9d9d9),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ));
                                  return ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [...widgets],
                                  );
                                }),
                              )
                            ],
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Row(
                              mainAxisAlignment: isEdit
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.end,
                              children: [
                                if (isEdit)
                                  CustomButtonV1(
                                      onPressed: () async {
                                        deleteHandler(addTagCubit, context);
                                      },
                                      textColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      title: AppText.btnRemove.text),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButtonV1(
                                          onPressed: () {
                                            if (addTagCubit.status !=
                                                SubmitStatus.none) {
                                              return;
                                            }
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
                                            if (isEdit) {
                                              editHandler(addTagCubit, context);
                                            } else {
                                              addHandler(addTagCubit, context);
                                            }
                                          },
                                          textColor: Colors.white,
                                          backgroundColor: primaryColor,
                                          title: isEdit
                                              ? AppText.btnUpdate.text
                                              : AppText.btnAddNew.text),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (addTagCubit.status == SubmitStatus.loading)
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(addTagCubit.isDelete
                                        ? AppText.txtLoadingDelete.text
                                        : isEdit
                                            ? AppText.txtLoadingUpdate.text
                                            : AppText.txtLoadingAdd.text),
                                    SizedBox(
                                      width: Resizable.padding(context, 10),
                                    ),
                                    SizedBox(
                                        height: Resizable.padding(context, 20),
                                        width: Resizable.padding(context, 20),
                                        child: const CircularProgressIndicator(
                                          color: primaryColor,
                                        )),
                                  ],
                                ),
                              )
                          ],
                        ),
                      )));
            },
          );
        },
      ),
    );
  }

  addHandler(AddTagCubit addTagCubit, BuildContext context) async {
    if (addTagCubit.status != SubmitStatus.none) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      tag = TagModel(
          id: DateTime.now().millisecondsSinceEpoch,
          groupId: widget.manageTagCubit
              .listGroupTags[widget.manageTagCubit.currentIndex].id,
          name: nameCon.text,
          background: addTagCubit.colors[addTagCubit.currentColor].value,
          description: desCon.text,
          code: codeCon.text);
      await addTagCubit.addTag(tag!);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  editHandler(AddTagCubit addTagCubit, BuildContext context) async {
    if (addTagCubit.status != SubmitStatus.none) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      tag = widget.tagModel!.copyWith(
        name: nameCon.text,
        background: addTagCubit.colors[addTagCubit.currentColor].value,
        description: desCon.text,
      );
      if (tag!.name == widget.tagModel!.name &&
          tag!.description == widget.tagModel!.description &&
          tag!.background == widget.tagModel!.background) {
        Fluttertoast.showToast(msg: AppText.txtDataNotChange.text);
        return;
      }
      await addTagCubit.update(tag!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  deleteHandler(AddTagCubit addTagCubit, BuildContext context) {
    if (addTagCubit.status != SubmitStatus.none) {
      return;
    }
    Dialogs.alertDelete(context, AppText.txtConfirmDeleteTag.text, () async {
      Navigator.pop(context);
      await addTagCubit.delete(widget.tagModel!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    });
  }
}
