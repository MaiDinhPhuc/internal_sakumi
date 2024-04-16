import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_color_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_tag_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';
import 'package:internal_sakumi/model/tag_model.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/enum.dart';
import '../../../utils/resizable.dart';
import '../manage_general/input_form/input_field.dart';
import 'custom_button_v1.dart';

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({super.key, required this.manageTagCubit});

  final ManageTagCubit manageTagCubit;

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TagModel? tag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTagCubit(),
      child: BlocConsumer<AddTagCubit, int>(
        listener: (context, state) {
          final addTagCubit = context.read<AddTagCubit>();
          if (addTagCubit.status == SubmitStatus.success) {
            widget.manageTagCubit
                .updateTag(tag!);
            Fluttertoast.showToast(msg: AppText.txtAddTagSuccess.text);
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
                                AppText.btnAddTag.text.toUpperCase(),
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
                                    onValidate: (value) {
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
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AddColorDialog(
                                              addTagCubit: addTagCubit,
                                            );
                                          });
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
                                        if (addTagCubit.status !=
                                            SubmitStatus.none) {
                                          return;
                                        }
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          tag = TagModel(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              name: nameCon.text,
                                              background: addTagCubit
                                                  .colors[
                                                      addTagCubit.currentColor]
                                                  .value,
                                              description: desCon.text,
                                              code: codeCon.text);

                                          var list = List.from(widget
                                              .manageTagCubit
                                              .listGroupTags[widget
                                                  .manageTagCubit.currentIndex]
                                              .tags);

                                          var tags = list
                                              .map((e) => TagModel.fromMap(e))
                                              .toList();
                                          tags.add(tag!);
                                          await addTagCubit.updateTag(
                                              widget
                                                  .manageTagCubit
                                                  .listGroupTags[widget
                                                      .manageTagCubit
                                                      .currentIndex]
                                                  .id,
                                              tags);

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      textColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      title: AppText.btnAddNew.text),
                                ],
                              ),
                            ),
                            if (addTagCubit.status == SubmitStatus.loading)
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppText.txtLoadingAdd.text),
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
}
