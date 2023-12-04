import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_new_lesson_button.dart';
import 'input_2_filed.dart';
import 'manage_course_cubit.dart';

void alertAddNewLesson(BuildContext context, LessonModel? lessonModel,
    bool isEdit, ManageCourseCubit cubit) {
  TextEditingController contCon = TextEditingController(
      text: lessonModel == null ? " " : lessonModel.content);
  TextEditingController titleCon =
      TextEditingController(text: lessonModel == null ? "" : lessonModel.title);
  TextEditingController vocaCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.vocabulary.toString());
  TextEditingController idCourseCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.courseId.toString());
  TextEditingController idLessonCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.lessonId.toString());
  TextEditingController btvnCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.btvn.toString());
  TextEditingController alphaCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.alphabet.toString());
  TextEditingController kanjiCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.kanji.toString());
  TextEditingController grammarCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.grammar.toString());
  TextEditingController listenCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.listening.toString());
  TextEditingController flCardCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.flashcard.toString());
  TextEditingController desCon = TextEditingController(
      text: lessonModel == null ? " " : lessonModel.description.toString());
  TextEditingController orderCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.order.toString());
  TextEditingController readingCon = TextEditingController(
      text: lessonModel == null ? "0" : lessonModel.reading.toString());
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
                                  ? AppText.txtEditLessonInfo.text.toUpperCase()
                                  : AppText.btnAddNewLesson.text.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          )),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                              child: Column(children: [
                            Input2Field(
                              title1: AppText.txtCourseId.text,
                              title2: AppText.txtLessonId.text,
                              con1: idCourseCon,
                              con2: idLessonCon,
                              enable: isEdit ? false : true,
                            ),
                            InputItem(
                                onChange: (String? value) {
                                  debugPrint(value);
                                },
                                controller: titleCon,
                                title: AppText.txtTitle.text,
                                isExpand: true),
                            InputItem(
                                onChange: (String? value) {
                                  debugPrint(value);
                                },
                                controller: contCon,
                                title: AppText.txtContent.text,
                                isExpand: true),
                            Input2Field(
                                title1: "Vocabulary",
                                title2: "BTVN",
                                con1: vocaCon,
                                con2: btvnCon),
                            Input2Field(
                                title1: "Alphabet",
                                title2: "Kanji",
                                con1: alphaCon,
                                con2: kanjiCon),
                            Input2Field(
                                title1: "Grammar",
                                title2: "Listening",
                                con1: grammarCon,
                                con2: listenCon),
                            Input2Field(
                                title1: "FlashCard",
                                title2: "Reading",
                                con1: flCardCon,
                                con2: readingCon),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                                InputField(controller: orderCon)
                              ],
                            ),
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
                                              .deleteLesson(
                                            int.parse(idLessonCon.text),
                                            int.parse(idCourseCon.text),
                                          );
                                          Navigator.pop(context);
                                          cubit.loadLessonInCourse(
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
                                                .addNewLesson(LessonModel(
                                                    lessonId: int.parse(
                                                        idLessonCon.text),
                                                    courseId: int.parse(
                                                        idCourseCon.text),
                                                    description: desCon.text,
                                                    content: contCon.text,
                                                    title: titleCon.text,
                                                    btvn:
                                                        int.parse(btvnCon.text),
                                                    vocabulary:
                                                        int.parse(vocaCon.text),
                                                    listening: int.parse(
                                                        listenCon.text),
                                                    kanji: int.parse(
                                                        kanjiCon.text),
                                                    grammar: int.parse(
                                                        grammarCon.text),
                                                    flashcard: int.parse(flCardCon.text),
                                                    alphabet: int.parse(alphaCon.text),
                                                    order: int.parse(orderCon.text),
                                                    reading: int.parse(readingCon.text)));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              if (check == true) {
                                                cubit.loadLessonInCourse(
                                                    cubit.selector);
                                              } else {
                                                notificationDialog(
                                                    context,
                                                    AppText
                                                        .txtPleaseCheckListLesson
                                                        .text);
                                              }
                                            }
                                          } else {
                                            await FireBaseProvider.instance
                                                .updateLessonInfo(LessonModel(
                                                    lessonId: int.parse(
                                                        idLessonCon.text),
                                                    courseId: int.parse(
                                                        idCourseCon.text),
                                                    description: desCon.text,
                                                    content: contCon.text,
                                                    title: titleCon.text,
                                                    btvn:
                                                        int.parse(btvnCon.text),
                                                    vocabulary:
                                                        int.parse(vocaCon.text),
                                                    listening: int.parse(
                                                        listenCon.text),
                                                    kanji: int.parse(
                                                        kanjiCon.text),
                                                    grammar: int.parse(
                                                        grammarCon.text),
                                                    flashcard: int.parse(
                                                        flCardCon.text),
                                                    alphabet: int.parse(
                                                        alphaCon.text),
                                                    order:
                                                        int.parse(orderCon.text),
                                                    reading: int.parse(readingCon.text)));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              cubit.loadLessonInCourse(
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
