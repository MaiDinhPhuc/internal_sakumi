import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_new_lesson_button.dart';
import 'input_2_filed.dart';
import 'manage_course_cubit.dart';

void alertAddNewTest(BuildContext context, TestModel? testModel, bool isEdit,
    ManageCourseCubit cubit) {
  TextEditingController titleCon =
      TextEditingController(text: testModel == null ? " " : testModel.title);
  TextEditingController courseIdCon = TextEditingController(
      text: testModel == null ? "" : testModel.courseId.toString());
  TextEditingController idCon = TextEditingController(
      text: testModel == null ? "" : testModel.id.toString());
  TextEditingController difficultCon = TextEditingController(
      text: testModel == null ? "" : testModel.difficulty.toString());
  TextEditingController desCon = TextEditingController(
      text: testModel == null ? "" : testModel.description);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: Form(
                key: formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20)),
                            child: Text(
                              isEdit
                                  ? AppText.txtEditTest.text.toUpperCase()
                                  : AppText.txtAddNewTest.text.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          )),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                              child: Column(children: [
                            InputItem(
                                onChange: (String? value) {
                                  debugPrint(value);
                                },
                                controller: titleCon,
                                title: AppText.txtTitle.text,
                                isExpand: true),
                            Input2Field(
                                title1: AppText.txtCourseId.text,
                                title2: AppText.txtTestId.text,
                                con1: courseIdCon,
                                con2: idCon,
                                enable: isEdit ? false : true),
                            InputItem(
                                onChange: (String? value) {
                                  debugPrint(desCon.text);
                                },
                                controller: difficultCon,
                                title: AppText.txtDifficult.text,
                                isExpand: false),
                            InputItem(
                                onChange: (String? value) {
                                  debugPrint(desCon.text);
                                },
                                controller: desCon,
                                title: AppText.txtDescription.text,
                                isExpand: true),
                          ]))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: isEdit
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isEdit)
                                    DeleteButton(
                                        onPressed: () async {
                                          await FireBaseProvider.instance
                                              .deleteTest(
                                            int.parse(idCon.text),
                                            int.parse(courseIdCon.text),
                                          );
                                          Navigator.pop(context);
                                          cubit.loadTestInCourse(
                                              cubit.selector);
                                        },
                                        title: AppText.txtDeleteLesson.text),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                                Resizable.size(context, 100)),
                                        margin: EdgeInsets.only(
                                            right:
                                                Resizable.padding(context, 20)),
                                        child: DialogButton(
                                            AppText.textCancel.text
                                                .toUpperCase(),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                      ),
                                      AddNewLessonButton(() async {
                                        if (formKey.currentState!.validate()) {
                                          if (!isEdit) {
                                            final bool check = await FireBaseProvider
                                                .instance
                                                .addNewTest(TestModel(
                                                    id: int.parse(
                                                        idCon.text),
                                                    courseId: int.parse(
                                                        courseIdCon.text),
                                                    description: desCon.text,
                                                    title: titleCon.text,
                                                    difficulty:
                                                        int.parse(difficultCon.text)));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              if (check == true) {
                                                cubit.loadTestInCourse(
                                                    cubit.selector);
                                              } else {
                                                notificationDialog(
                                                    context,
                                                    AppText
                                                        .txtPleaseCheckListTest
                                                        .text);
                                              }
                                            }
                                          } else {
                                            await FireBaseProvider.instance
                                                .updateTestInfo(TestModel(
                                                id: int.parse(
                                                    idCon.text),
                                                courseId: int.parse(
                                                    courseIdCon.text),
                                                description: desCon.text,
                                                title: titleCon.text,
                                                difficulty:
                                                int.parse(difficultCon.text)));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              cubit.loadTestInCourse(
                                                  cubit.selector);
                                            }
                                          }
                                        } else {
                                          print('Form is invalid');
                                        }
                                      }, isEdit)
                                    ],
                                  )
                                ],
                              )))
                    ],
                  ),
                )));
      });
}
