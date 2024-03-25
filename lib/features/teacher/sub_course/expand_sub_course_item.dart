import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/sub_course/skill_item_sub_course.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_item_layout.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_sub_course_item_cubit.dart';

class ExpandSubCourseItem extends StatelessWidget {
  const ExpandSubCourseItem(
      {super.key,
      required this.lesson,
      required this.detailCubit,
      required this.role});
  final LessonModel lesson;
  final DetailSubCourseItemCubit detailCubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 15)),
        child: Column(
          children: [
            Container(
              height: Resizable.size(context, 1),
              margin: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 15)),
              color: const Color(0xffD9D9D9),
            ),
            DetailSubCourseItemLayout(
              name: Padding(
                  padding: EdgeInsets.only(left: Resizable.padding(context, 5)),
                  child: Text(AppText.txtName.text,
                      style: TextStyle(
                          color: const Color(0xff757575),
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17)))),
              flashCard: Text("FlashCard",
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              hw: Text(AppText.txtHw.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              vocabulary: Text(AppText.titleVocabulary.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              grammar: Text(AppText.titleGrammar.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              reading: Text(AppText.txtReading.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              kanji: Text(AppText.titleKanji.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              listening: Text(AppText.titleListening.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
              alphabet: Text(AppText.txtAlphabet.text,
                  style: TextStyle(
                      color: const Color(0xff757575),
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 17))),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 8)),
              child: detailCubit.students == null
                  ? const CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...detailCubit.students!.map((e) =>
                            DetailSubCourseItemLayout(
                              name: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    overlayColor: MaterialStateProperty.all(
                                        primaryColor.withAlpha(30)),
                                    onTap: () async {
                                      if (role == "admin") {
                                        await Navigator.pushNamed(context,
                                            "${Routes.admin}/studentInfo/student=${e.userId}");
                                      }
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(
                                            Resizable.size(context, 5)),
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 20),
                                              fontWeight: FontWeight.w500),
                                        )),
                                  )),
                              flashCard: SkillItemSubCourse(
                                  isExist: lesson.flashcard == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_flashcard'),
                                  isCustom: lesson.isCustom),
                              hw: SkillItemSubCourse(
                                  isExist: lesson.btvn == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_btvn'),
                                  isCustom: lesson.isCustom),
                              vocabulary: SkillItemSubCourse(
                                  isExist: lesson.vocabulary == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_vocabulary'),
                                  isCustom: lesson.isCustom),
                              grammar: SkillItemSubCourse(
                                  isExist: lesson.grammar == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_grammar'),
                                  isCustom: lesson.isCustom),
                              reading: SkillItemSubCourse(
                                  isExist: lesson.reading == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_reading'),
                                  isCustom: lesson.isCustom),
                              kanji: SkillItemSubCourse(
                                  isExist: lesson.kanji == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_kanji'),
                                  isCustom: lesson.isCustom),
                              listening: SkillItemSubCourse(
                                  isExist: lesson.listening == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_listening'),
                                  isCustom: lesson.isCustom),
                              alphabet: SkillItemSubCourse(
                                  isExist: lesson.alphabet == 1,
                                  time: detailCubit.getTime(
                                      e.userId, 'time_alphabet'),
                                  isCustom: lesson.isCustom),
                            ))
                      ],
                    ),
            )
          ],
        ));
  }
}
