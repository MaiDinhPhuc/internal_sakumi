import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_info_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TeacherInfoCubit extends Cubit<int> {
  TeacherInfoCubit() : super(0);

  TeacherModel? teacher;
  UserModel? user;

  List<TeacherClassModel>? teacherClasses;
  List<ClassModel>? classes;
  List<CourseModel>? courses;
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;
  List<StudentClassModel>? stdClasses;

  List<TeacherInfoModel>? listTeacherInfo;

  String name = "";
  String teacherCode = "";
  String phone = "";
  String note = "";

  loadStudent(int teacherId,SearchCubit searchController) async {
    if(searchController.students!=null){
      teacher = searchController.teachers!.firstWhere((e) => e.userId == teacherId);
      user = searchController.users!.firstWhere((e) => e.id == teacherId);
    }else{
      teacher = await FireBaseProvider.instance.getTeacherById(teacherId);
      user = await FireBaseProvider.instance.getUserById(teacherId);
    }

    name = teacher!.name;
    teacherCode = teacher!.teacherCode;
    phone = teacher!.phone;
    note = teacher!.note;
    emit(state + 1);
    loadInFoTeacherInSystem(teacherId);
  }

  loadInFoTeacherInSystem(int teacherId) async {
    teacherClasses =
        await FireBaseProvider.instance.getTeacherClassById(teacherId);
    var listClassId = teacherClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassForTeacher(listClassId);
    listTeacherInfo = await TeacherInfoModel.loadInfo(teacherClasses!, classes!,
        courses, stdLessons, stdTests, lessonResults, lessons, stdClasses);
    emit(state + 1);
    stdClasses = await FireBaseProvider.instance.getStudentClassByListId(listClassId);
    listTeacherInfo = await TeacherInfoModel.loadInfo(teacherClasses!, classes!,
        courses, stdLessons, stdTests, lessonResults, lessons, stdClasses);
    emit(state + 1);
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.courseId) == false) {
        listCourseIds.add(i.courseId);
      }
    }
    courses = await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    listTeacherInfo = await TeacherInfoModel.loadInfo(teacherClasses!, classes!,
        courses, stdLessons, stdTests, lessonResults, lessons, stdClasses);
    emit(state + 1);
    stdLessons =
        await FireBaseProvider.instance.getAllStudentLessonsInListClassId(listClassId);
    stdTests = await FireBaseProvider.instance.getListStudentTestByIDs(listClassId);
    lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(listClassId);
    listTeacherInfo = await TeacherInfoModel.loadInfo(teacherClasses!, classes!,
        courses, stdLessons, stdTests, lessonResults, lessons, stdClasses);
    emit(state + 1);
    lessons =
        await FireBaseProvider.instance.getLessonsByListCourseId(listCourseIds);
    listTeacherInfo = await TeacherInfoModel.loadInfo(teacherClasses!, classes!,
        courses, stdLessons, stdTests, lessonResults, lessons, stdClasses);
    emit(state + 1);
  }

  changeNote(String newValue) {
    note = newValue;
    emit(state + 1);
  }

  changePhone(String newValue) {
    phone = newValue;
    emit(state + 1);
  }

  changeTeacherCode(String newValue) {
    teacherCode = newValue;
    emit(state + 1);
  }

  changeName(String newValue) {
    name = newValue;
    emit(state + 1);
  }
}
