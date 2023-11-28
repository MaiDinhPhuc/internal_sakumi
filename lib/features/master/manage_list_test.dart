import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/master/test_item.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_item_exist.dart';
import 'alert_new_test.dart';
import 'manage_course_cubit.dart';

class ManageListTest extends StatelessWidget {
  const ManageListTest(this.cubit, {super.key});
  final ManageCourseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: !cubit.canAdd
            ? Container()
            : cubit.listTest == null
                ? Transform.scale(
                    scale: 0.75,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      ...(cubit.listTest!)
                          .map((e) => TestItem(
                                e,
                                cubit: cubit,
                              ))
                          .toList(),
                      SizedBox(height: Resizable.padding(context, 5)),
                      if (cubit.listTest!.isNotEmpty || cubit.canAdd == true)
                        Material(
                            color: Colors.transparent,
                            child: DottedBorderButton(
                                AppText.btnAddNewTest.text.toUpperCase(),
                                isManageGeneral: true, onPressed: () async {
                              selectionDialog(
                                  context,
                                  AppText.txtAddManual.text,
                                  AppText.txtAddFromJson.text, () {
                                Navigator.pop(context);
                                alertAddNewTest(context, null, false, cubit);
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
                                      await TestModel.check(decodedBytes);
                                  if (check) {
                                    await FireBaseProvider.instance
                                        .addTestFromJson(decodedBytes);
                                    Navigator.pop(context);
                                    cubit.loadTestInCourse(cubit.selector);
                                  } else {
                                    Navigator.pop(context);
                                    alertItemExist(
                                        context, AppText.txtTestExist.text);
                                  }
                                }
                              });
                            })),
                    ],
                  ));
  }
}
