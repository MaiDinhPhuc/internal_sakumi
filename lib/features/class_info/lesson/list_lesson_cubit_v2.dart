import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ListLessonCubitV2 extends Cubit<int>{
  ListLessonCubitV2(this.classId):super(0){
    loadData();
  }
  final int classId;
  ClassModel? classModel;
  List<TeacherModel> teachers = [];
  List<StudentModel> students = [];
  List<StudentClassModel>? listStdClass;
  List<StudentLessonModel>? stdLessons;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;
  List<int> listTeacherId = [];

  loadData()async{
    classModel = await FireBaseProvider.instance.getClassById(classId);

    emit(state+1);

    if(classModel!.customLessons.isEmpty){
      await DataProvider.lessonByCourseId(classModel!.courseId, loadLessonInClass);
    }else{
      await DataProvider.lessonByCourseAndClassId(classModel!.courseId,classId, loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if(classModel!.customLessons.isNotEmpty){
        for(var i in classModel!.customLessons){
          if(!lessonId.contains(i['custom_lesson_id'])){
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

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classId, loadLessonResult);

    await sortLessons();



    await Future.delayed(const Duration(milliseconds: 500));

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    for(var i in listStdId){
      DataProvider.studentById(i, loadStudentInfo);
    }


    for (var i in lessonResults!) {
      if (!listTeacherId.contains(i.teacherId)) {
        listTeacherId.add(i.teacherId);
      }
    }

    for(var i in listTeacherId){
      DataProvider.teacherById(i, loadTeacherInfo);
    }

  }

  sortLessons(){
    var listId = lessonResults!.map((e) => e.lessonId).toList();

    List<LessonModel> listTemp1 = [];

    for(var i in lessonResults!){
      listTemp1.add(lessons!.firstWhere((e) => e.lessonId == i.lessonId));
    }

    List<LessonModel> listTemp2 = List.of(lessons!).where((e) => !listId.contains(e.lessonId)).toList();

    lessons = listTemp1;

    lessons!.addAll(listTemp2);


    emit(state+1);
  }

  addNewLesson(LessonModel lesson){
    lessons!.add(lesson);
    emit(state+1);
  }

  update()async{

      DataProvider.stdClassByClassId(classId, loadStudentClass);

      DataProvider.stdLessonByClassId(classId, loadStdLesson);

      DataProvider.lessonResultByClassId(classId, loadLessonResult);

      DataProvider.lessonByCourseAndClassId(classModel!.courseId,classId ,loadLessonInClass);
      students = [];
      listTeacherId = [];
      teachers = [];

      var listStdId = listStdClass!.map((e) => e.userId).toList();
      for(var i in listStdId){
        DataProvider.studentById(i, loadStudentInfo);
      }


      for (var i in lessonResults!) {
        if (!listTeacherId.contains(i.teacherId)) {
          listTeacherId.add(i.teacherId);
        }
      }
      for(var i in listTeacherId){
        DataProvider.teacherById(i, loadTeacherInfo);
      }

    }



  loadTeacherInfo(Object student) {
    teachers.add(student as TeacherModel);
    if(teachers.length == listTeacherId.length){
      emit(state+1);
    }
  }


  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    if(students.length == listStdClass!.length){
      emit(state+1);
    }
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }


  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
    emit(state+1);
  }

}