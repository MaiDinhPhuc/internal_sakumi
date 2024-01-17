import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_course_cubit.dart';

class DetailLessonCubit extends Cubit<int> {
  DetailLessonCubit() : super(0);

  LessonModel? lessonModel;
  int? vocabulary,
      btvn,
      alphabet,
      kanji,
      grammar,
      listening,
      flashcard,
      reading;

  load(LessonModel lesson) {
    vocabulary = lesson.vocabulary;
    btvn = lesson.btvn;
    alphabet = lesson.alphabet;
    kanji = lesson.kanji;
    grammar = lesson.grammar;
    listening = lesson.listening;
    flashcard = lesson.flashcard;
    reading = lesson.reading;
    lessonModel = lesson;
    emit(state + 1);
  }

  update(String type, int value, ManageCourseCubit cubit) async {
    switch (type) {
      case "vocabulary":
        vocabulary = value;
      case "btvn":
        btvn = value;
      case "alphabet":
        alphabet = value;
      case "kanji":
        kanji = value;
      case "grammar":
        grammar = value;
      case "listening":
        listening = value;
      case "flashcard":
        flashcard = value;
      case "reading":
        reading = value;
    }
    emit(state + 1);
    await FireBaseProvider.instance.updateLessonInfo(LessonModel(
        lessonId: lessonModel!.lessonId,
        courseId: lessonModel!.courseId,
        description: lessonModel!.description,
        content: lessonModel!.content,
        title: lessonModel!.title,
        btvn: btvn!,
        vocabulary: vocabulary!,
        listening: listening!,
        kanji: kanji!,
        grammar: grammar!,
        flashcard: flashcard!,
        alphabet: alphabet!,
        order: lessonModel!.order,
        reading: reading!,
        enable: lessonModel!.enable,
        customLessonInfo: [],
        isCustom: false));
    await cubit.updateLesson(LessonModel(
        lessonId: lessonModel!.lessonId,
        courseId: lessonModel!.courseId,
        description: lessonModel!.description,
        content: lessonModel!.content,
        title: lessonModel!.title,
        btvn: btvn!,
        vocabulary: vocabulary!,
        listening: listening!,
        kanji: kanji!,
        grammar: grammar!,
        flashcard: flashcard!,
        alphabet: alphabet!,
        order: lessonModel!.order,
        reading: reading!,
        enable: lessonModel!.enable,
        customLessonInfo: [],
        isCustom: false));
  }
}
