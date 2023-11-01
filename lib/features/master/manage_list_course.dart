import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_add_new_course.dart';
import 'alert_item_exist.dart';
import 'manage_course_cubit.dart';

class ManageListCourse extends StatelessWidget {
  final ManageCourseCubit cubit;
  const ManageListCourse(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TitleWidget(AppText.txtListCourse.text.toUpperCase()),
          ...(cubit.listCourseNow!)
              .map(
                (e) => Row(
              children: [
                Container(
                  color: e.courseId == cubit.selector
                      ? primaryColor
                      : Colors.transparent,
                  width: Resizable.size(context, 4),
                  margin: EdgeInsets.only(
                      right: Resizable.padding(context, 5),
                      bottom: Resizable.padding(context, 10)),
                ),
                Expanded(
                    child: Card(
                        margin: EdgeInsets.only(
                            right: Resizable.padding(context, 10),
                            bottom: Resizable.padding(context, 10)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5)),
                            side: BorderSide(
                                color: cubit.selector != e.courseId
                                    ? const Color(0xffE0E0E0)
                                    : Colors.black,
                                width: Resizable.size(context, 1))),
                        elevation: cubit.selector == e.courseId
                            ? Resizable.size(context, 2)
                            : 0,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5)),
                            onTap: () {
                              if(e.courseId != cubit.selector){
                                cubit.selectedCourse(e.courseId);
                              }
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                    Resizable.padding(context, 10),
                                    horizontal:
                                    Resizable.padding(context, 15)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${e.courseId} - ${e.title} ${e.termName} ${e.code}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                          Resizable.font(context, 17)),
                                    ),
                                    InkWell(
                                        borderRadius: BorderRadius.circular(
                                            Resizable.size(context, 100)),
                                        onTap: () {
                                          alertAddNewCourse(context,e,true, cubit);
                                        },
                                        child: Image.asset(
                                            'assets/images/ic_edit.png',
                                            height:
                                            Resizable.size(context, 20),
                                            width: Resizable.size(
                                                context, 20)))
                                  ],
                                )))))
              ],
            ),
          )
              .toList(),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 10)),
              child: DottedBorderButton(
                  AppText.btnAddNewCourse.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                selectionDialog(context, AppText.txtAddManual.text, AppText.txtAddFromJson.text, () {
                  Navigator.pop(context);
                  alertAddNewCourse(context,null,false, cubit);
                }, () async {
                  Navigator.pop(context);
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    waitingDialog(context);
                    Uint8List uInt8list = Uint8List.fromList(result.files.single.bytes!.toList());
                    const utf8Decoder = Utf8Decoder(allowMalformed: true);
                    final decodedBytes = utf8Decoder.convert(uInt8list);
                    bool check = await CourseModel.check(decodedBytes);
                    if(check){
                      await FireBaseProvider.instance.addCourseFromJson(decodedBytes);
                      Navigator.pop(context);
                      cubit.loadAfterAddCourseFromJson();
                    }else{
                      Navigator.pop(context);
                      alertItemExist(context, AppText.txtCourseExist.text);
                    }
                  }
                });
              })),
          SizedBox(height: Resizable.size(context, 50))
        ],
      ),
    );
  }
}