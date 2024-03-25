import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class SubCourseCubit extends Cubit<int> {
  SubCourseCubit(this.classId) : super(0) {
    loadData();
  }

  final int classId;

  ClassModel? classModel;

  ClassModel? subClassModel;

  int subClassId = 0;

  bool loading = true;

  List<LessonModel>? lessons;

  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? listStdClass;
  List<StudentModel> students = [];

  loadData() async {
    classModel = await FireBaseProvider.instance.getClassById(classId);
    subClassId = classModel!.subClassId;
    emit(state + 1);
    loadDetail();
  }

  addNewSubCourse(int courseId) async {
    int subClassId = DateTime.now().millisecondsSinceEpoch;

    ClassModel subClass = ClassModel(
        classId: subClassId,
        courseId: courseId,
        description: "",
        endTime: 0,
        startTime: 0,
        note: "",
        classCode: "Tự học",
        classStatus: "InProgress",
        classType: 1,
        link: "",
        customLessons: [],
        informal: true,
        isSubClass: true,
        subClassId: 0);

    ClassModel classModel = ClassModel(
        classId: classId,
        courseId: this.classModel!.courseId,
        description: this.classModel!.description,
        endTime: this.classModel!.endTime,
        startTime: this.classModel!.startTime,
        note: this.classModel!.note,
        classCode: this.classModel!.classCode,
        classStatus: this.classModel!.classStatus,
        classType: this.classModel!.classType,
        link: this.classModel!.link,
        customLessons: this.classModel!.customLessons,
        informal: this.classModel!.informal,
        isSubClass: false,
        subClassId: subClassId);

    await FireBaseProvider.instance.updateClassInfo(classModel);

    await FireBaseProvider.instance.createNewClass(subClass);

    this.subClassId = subClassId;

    this.classModel = classModel;

    subClassModel = subClass;

    emit(state + 1);
    loadDetail();
  }

  loadDetail() async {
    if (subClassId != 0) {
      subClassModel ??= await FireBaseProvider.instance.getClassById(subClassId);

      if (subClassModel!.customLessons.isEmpty) {
        await DataProvider.lessonByCourseId(
            subClassModel!.courseId, loadLessonInClass);
      } else {
        await DataProvider.lessonByCourseAndClassId(
            subClassModel!.courseId, classId, loadLessonInClass);

        var lessonId = lessons!.map((e) => e.lessonId).toList();

        if (subClassModel!.customLessons.isNotEmpty) {
          for (var i in subClassModel!.customLessons) {
            if (!lessonId.contains(i['custom_lesson_id'])) {
              lessons!.add(LessonModel(
                  lessonId: i['custom_lesson_id'],
                  courseId: -1,
                  description: i['description'],
                  content: "",
                  title: i['title'],
                  btvn: -1,
                  vocabulary: 0,
                  listening: 0,
                  kanji: 0,
                  grammar: 0,
                  flashcard: 0,
                  alphabet: 0,
                  order: 0,
                  reading: 0,
                  enable: true,
                  customLessonInfo: i['lessons_info'],
                  isCustom: true));
            }
          }
        }
      }

      await DataProvider.stdLessonByClassId(
          subClassId, loadStdLessonInClass);

      await DataProvider.stdClassByClassId(classId, loadStudentClass);

      var listStdId = listStdClass!.map((e) => e.userId).toList();
      for (var i in listStdId) {
        DataProvider.studentById(i, loadStudentInfo);
      }

      loading = false;

      emit(state + 1);
    }
  }

  addNewLesson(LessonModel lesson) {
    lessons!.add(lesson);
    emit(state + 1);
  }

  loadStdLessonInClass(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    if (students.length == listStdClass!.length) {
      emit(state + 1);
    }
  }
}
