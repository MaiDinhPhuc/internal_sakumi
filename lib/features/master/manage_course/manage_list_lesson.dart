import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/teacher/alert_view.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_add_new_lesson.dart';
import 'alert_item_exist.dart';
import 'lesson_item.dart';
import 'manage_course_cubit.dart';


class ManageListLesson extends StatelessWidget {
  const ManageListLesson(this.cubit, {super.key});
  final ManageCourseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: !cubit.canAdd
            ? Container()
            : cubit.listLesson == null
                ? Transform.scale(
                    scale: 0.75,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      ...(cubit.listLesson!)
                          .map((e) => LessonItem(e, cubit))
                          .toList(),
                      SizedBox(height: Resizable.padding(context, 5)),
                      if (cubit.listLesson!.isNotEmpty || cubit.canAdd == true)
                        Material(
                            color: Colors.transparent,
                            child: DottedBorderButton(
                                AppText.btnAddNewLesson.text.toUpperCase(),
                                isManageGeneral: true, onPressed: () async {
                              selectionDialog(
                                  context,
                                  AppText.txtAddManual.text,
                                  AppText.txtAddFromJson.text, () async {
                                Navigator.pop(context);
                                alertAddNewLesson(context, null, false, cubit);
                              }, () async {
                                Navigator.pop(context);
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  waitingDialog(context);
                                  Uint8List uInt8list = Uint8List.fromList(
                                      result.files.single.bytes!.toList());
                                  const utf8Decoder =
                                      Utf8Decoder(allowMalformed: true);
                                  final decodedBytes =
                                      utf8Decoder.convert(uInt8list);
                                  bool check =
                                      await LessonModel.check(decodedBytes);
                                  if (check) {
                                    await FireBaseProvider.instance
                                        .addLessonFromJson(decodedBytes);
                                    Navigator.pop(context);
                                    cubit.loadLessonInCourse(cubit.selector);
                                  } else {
                                    Navigator.pop(context);
                                    alertItemExist(
                                        context, AppText.txtLessonExist.text);
                                  }
                                }
                              });
                            })),
                    ],
                  ));
  }
}
