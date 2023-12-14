import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/master/manage_course/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_course_cubit.dart';

class ExpandLessonItem extends StatelessWidget {
  ExpandLessonItem({super.key, required this.lesson, required this.cubit})
      : detailLessonCubit = DetailLessonCubit();
  final LessonModel lesson;
  final ManageCourseCubit cubit;
  final DetailLessonCubit detailLessonCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: detailLessonCubit..load(lesson),
        builder: (c, s) {
          return detailLessonCubit.lessonModel == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      EdgeInsets.only(right: Resizable.padding(context, 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Vocabulary",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.vocabulary == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "vocabulary", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Alphabet",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.alphabet == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "alphabet", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Grammar",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.grammar == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "grammar", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("FlashCard",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.flashcard == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "flashcard", newValue! ? 1 : 0, cubit);
                                },
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("BTVN",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value:
                                    detailLessonCubit.btvn == 1 ? true : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "btvn", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Kanji",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value:
                                    detailLessonCubit.kanji == 1 ? true : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "kanji", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Listening",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.listening == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "listening", newValue! ? 1 : 0, cubit);
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Reading",
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20))),
                                value: detailLessonCubit.reading == 1
                                    ? true
                                    : false,
                                onChanged: (newValue) {
                                  detailLessonCubit.update(
                                      "reading", newValue! ? 1 : 0, cubit);
                                },
                              )
                            ],
                          )),
                    ],
                  ));
        });
  }
}
