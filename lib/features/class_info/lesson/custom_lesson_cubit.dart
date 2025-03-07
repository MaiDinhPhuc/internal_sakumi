import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'list_lesson_cubit_v2.dart';

class CustomLessonCubit extends Cubit<int> {
  CustomLessonCubit(this.classModel) : super(0) {
    loadData();
  }

  final TextEditingController desCon = TextEditingController();
  final TextEditingController titleCon = TextEditingController();
  ClassModel classModel;

  List<Map> listLessonInfo = [];

  List<CourseModel>? courses;
  List<LessonModel>? lessons;

  loadData() async {
    courses = (await FireBaseProvider.instance.getAllCourseEnable())
        .where((e) => e.courseId != 999999999)
        .toList();
    lessons = await FireBaseProvider.instance.getAllLesson();
    emit(state + 1);
  }

  chooseCourse(String? text, int index) async {
    int courseId = int.parse(text!.split("-")[0]);

    if (listLessonInfo.isEmpty) {
      listLessonInfo.add({"courseId": courseId, 'lessonId' : null});
    } else {
      listLessonInfo[index] = {"courseId": courseId, 'lessonId' : null};
    }
    emit(state+1);
  }

  chooseLesson(String? text, int index) async {
    int lessonId = int.parse(text!.split("-")[0]);
    listLessonInfo[index] = {
      "courseId": listLessonInfo[index]["courseId"],
      "lessonId": lessonId
    };
    emit(state + 1);
  }

  String findCourse(int index) {
    if (listLessonInfo.isEmpty) return AppText.textChooseCourse.text;
    for (var i in courses!) {
      if (i.courseId == listLessonInfo[index]["courseId"]) {
        return '${i.title} ${i.termName} ${i.code}';
      }
    }
    return AppText.textChooseCourse.text;
  }

  String? getCourseValue(int index){
    if(listLessonInfo[index]['courseId'] == -1) return null;
    for(var i in listCourse()){
      int courseId = int.parse(i.split("-")[0]);
      if(listLessonInfo[index]['courseId'] == courseId){
        return i;
      }
    }
  }

  String? getLessonValue(int index){
    if(listLessonInfo[index]['lessonId'] == null) return null;
    for(var i in listLesson()[getCourseValue(index)]!){
      int lessonId = int.parse(i.split("-")[0]);
      if(listLessonInfo[index]['lessonId'] == lessonId){
        return i;
      }
    }
  }

  List<String> listCourse(){
    if(courses == null) return [];

    return List.generate(
        courses!.length,
            (index) =>
        ('${courses![index].courseId}-${courses![index].title} ${courses![index].termName} ${courses![index].code}'))
        .toList();
  }

  Map<String, List<String>> listLesson(){
    if(lessons == null) return {};

    Map<String, List<String>> listLesson = {};

    for(var i in listCourse()){
      int courseId = int.parse(i.split("-")[0]);

      List<String> lessons = [];

      for(var j in this.lessons!){
        if(j.courseId == courseId){
          lessons.add("${j.lessonId}-${j.title}");
        }
      }

      var entries = {
        i: lessons
      };

      listLesson.addAll(entries);
    }

    return listLesson;

  }

  check(int index){

    if(listLessonInfo[index]['courseId'] == -1 && listLessonInfo[index]['lessonId'] == null) return true;

    if(listLessonInfo[index]['courseId'] == -1 || listLessonInfo[index]['lessonId'] == null) return false;

    return true;
  }

  delete(int index) {

    if(listLessonInfo.isNotEmpty && check(index)){
      listLessonInfo.remove(listLessonInfo[index]);
    }
    emit(state + 1);
  }

  addNewCourse() {
    listLessonInfo.add({"courseId": -1, 'lessonId' : null});
    emit(state + 1);
  }

  updateClass(
   ListLessonCubitV2 listLessonCubit) async {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    List<dynamic> listCustomLesson = classModel.customLessons;

    List<Map> list = [];


    for (var i in listLessonInfo) {
      list.add(
          {'course_id': i['courseId'], 'lesson_id': i['lessonId']});
    }

    listCustomLesson.add({
      "custom_lesson_id": millisecondsSinceEpoch,
      "description": desCon.text,
      "title": titleCon.text,
      "lessons_info": list
    });

    ClassModel newClass = ClassModel(
        classId: classModel.classId,
        courseId: classModel.courseId,
        description: classModel.description,
        endTime: classModel.endTime,
        startTime: classModel.startTime,
        note: classModel.note,
        classCode: classModel.classCode,
        classStatus: classModel.classStatus,
        classType: classModel.classType,
        link: classModel.link,
        customLessons: listCustomLesson,
        informal: classModel.informal,
        isSubClass: classModel.isSubClass,
        subClassId: classModel.subClassId, customTests: classModel.customTests);

    Update
        .updateClassInfo(newClass);
    listLessonCubit.updateClass(newClass);
    listLessonCubit.addNewLesson(LessonModel(
        lessonId: millisecondsSinceEpoch,
        courseId: -1,
        description: desCon.text,
        content: "",
        title: titleCon.text,
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
        customLessonInfo: list,
        isCustom: true));
  }

  updateSubCourseClass( SubCourseCubit subCourseCubit) {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    List<dynamic> listCustomLesson = classModel.customLessons;

    List<Map> list = [];
    for (var i in listLessonInfo) {
      list.add(
          {'course_id': i['courseId'], 'lesson_id': i['lessonId']});
    }

    listCustomLesson.add({
      "custom_lesson_id": millisecondsSinceEpoch,
      "description": desCon.text,
      "title": titleCon.text,
      "lessons_info": list
    });

    Update
        .updateClassInfo(ClassModel(
            classId: classModel.classId,
            courseId: classModel.courseId,
            description: classModel.description,
            endTime: classModel.endTime,
            startTime: classModel.startTime,
            note: classModel.note,
            classCode: classModel.classCode,
            classStatus: classModel.classStatus,
            classType: classModel.classType,
            link: classModel.link,
            customLessons: listCustomLesson,
            informal: classModel.informal,
            isSubClass: classModel.isSubClass,
            subClassId: classModel.subClassId, customTests: classModel.customTests))
        .whenComplete(() {
      subCourseCubit.addNewLesson(LessonModel(
          lessonId: millisecondsSinceEpoch,
          courseId: -1,
          description: desCon.text,
          content: "",
          title: titleCon.text,
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
          customLessonInfo: list,
          isCustom: true));
    });
  }
}
