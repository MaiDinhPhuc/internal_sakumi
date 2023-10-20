import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageGeneralCubit extends Cubit<int> {
  ManageGeneralCubit() : super(-1);
  List<ClassModel>? listAllClass;
  List<ClassModel>? listClassNow;
  List<TeacherModel>? listTeacher;
  List<StudentModel>? listStudent;
  List<StudentClassModel>? listStudentClass;
  List<CourseModel>? listAllCourse;
  int selector = -1;
  List<bool> listStateCourse = [];
  List<bool> listStateClassStatus = [true, true, false, false];
  List<bool> listClassType = [true, true];
  bool canAdd = true;

  List<String> listStudentStatusMenu = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];
  List<String> listClassStatusMenu = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel"
  ];
  List<String> listAllClassStatusMenu = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel",
    "Remove"
  ];
  List<String> listClassTypeMenu = ["Lớp Chung", "Lớp 1-1"];

  loadAllClass() async {
    final List<ClassModel> list = await FireBaseProvider.instance.getListClassNotRemove();
    listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    List<int> courseIdsTemp = [];
    for(var i in listAllCourse!){
      courseIdsTemp.add(i.courseId);
    }
    List<ClassModel> listClassEnable = [];
    for(var i in list){
      if(courseIdsTemp.contains(i.courseId)){
        listClassEnable.add(i);
      }
    }
    listAllClass = listClassEnable;
    listClassNow = listAllClass;
    for (int i = 0; i < listAllCourse!.length; i++) {
      listStateCourse.add(false);
    }
    filterClass();
    emit(listAllClass!.first.classId);
  }

  loadAfterAddClass(int index) async {
    // listAllClass = await FireBaseProvider.instance.getListClassNotRemove();
    // listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    final List<ClassModel> list = await FireBaseProvider.instance.getListClassNotRemove();
    listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    List<int> courseIdsTemp = [];
    for(var i in listAllCourse!){
      courseIdsTemp.add(i.courseId);
    }
    List<ClassModel> listClassEnable = [];
    for(var i in list){
      if(courseIdsTemp.contains(i.courseId)){
        listClassEnable.add(i);
      }
    }
    listAllClass = listClassEnable;
    listClassNow = listAllClass;
    for (int i = 0; i < listAllCourse!.length; i++) {
      listStateCourse.add(false);
    }
    listClassNow = listAllClass;
    selector = index;
    canAdd = true;
    emit(selector);
    loadTeacherInClass(selector);
    loadStudentInClass(selector);
  }

  loadAfterChangeClassStatus() async {
    final List<ClassModel> list = await FireBaseProvider.instance.getListClassNotRemove();
    listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    List<int> courseIdsTemp = [];
    for(var i in listAllCourse!){
      courseIdsTemp.add(i.courseId);
    }
    List<ClassModel> listClassEnable = [];
    for(var i in list){
      if(courseIdsTemp.contains(i.courseId)){
        listClassEnable.add(i);
      }
    }
    listAllClass = listClassEnable;
    listClassNow = listAllClass;
    filterClass();
    emit(state + 2);
  }

  selectedClass(int index) {
    selector = index;
    canAdd = true;
    emit(selector);
    loadTeacherInClass(index);
    loadStudentInClass(index);
  }

  filterClass() {
    listClassNow = [];

    List<int> listCourseNow = [];
    if (listStateCourse.every((element) => element == false)) {
      for (int i = 0; i < listStateCourse.length; i++) {
        listCourseNow.add(listAllCourse![i].courseId);
      }
    } else {
      for (int i = 0; i < listStateCourse.length; i++) {
        if (listStateCourse[i] == true) {
          listCourseNow.add(listAllCourse![i].courseId);
        }
      }
    }
    List<String> listCLassStatus = [];
    for (int i = 0; i < listStateClassStatus.length; i++) {
      if (listStateClassStatus[i] == true) {
        listCLassStatus.add(listClassStatusMenu[i]);
      }
    }

    List<ClassModel> listTemp1 = [];

    for (var i in listAllClass!) {
      for (var j in listCourseNow) {
        if (i.courseId == j) {
          listTemp1.add(i);
          break;
        }
      }
    }
    List<ClassModel> listTemp2 = [];
    for (var i in listTemp1) {
      for (var j in listCLassStatus) {
        if (i.classStatus == j) {
          listTemp2.add(i);
        }
      }
    }
    List<int> listType = [];
    if (listClassType[0] == true) {
      listType.add(0);
    }
    if (listClassType[1] == true) {
      listType.add(1);
    }
    for (var i in listTemp2) {
      for (var j in listType) {
        if (i.classType == j) {
          listClassNow!.add(i);
        }
      }
    }

    bool change = true;
    for (var i in listClassNow!) {
      if (i.classId == selector) {
        change = false;
        break;
      }
    }
    if (change) {
      listTeacher = [];
      listStudent = [];
      selector = -1;
      canAdd = false;
    }

    emit(state + 2);
  }

  loadTeacherInClass(int selector) async {
    listTeacher = null;
    var listAllTeacherInClass =
        await FireBaseProvider.instance.getAllTeacherInClassByClassId(selector);
    List<int> listTeacherId = [];
    for(var i in listAllTeacherInClass){
      listTeacherId.add(i.userId);
    }
    listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
    emit(state + 2);
  }

  loadAfterRemoveStudent(StudentModel student) {
    for (int i = 0; i < listStudent!.length; i++) {
      if (student.userId == listStudent![i].userId) {
        listStudent!.remove(listStudent![i]);
        break;
      }
    }
    emit(state + 2);
  }

  loadStudentInClass(int selector) async {
    listStudent = null;
    listStudentClass = null;
    List<StudentClassModel> listAllStudentInClass =
        await FireBaseProvider.instance.getStudentClassInClass(selector);
    List<int> listStudentId = [];
    for(var i in listAllStudentInClass){
      listStudentId.add(i.userId);
    }
    listStudent = await FireBaseProvider.instance.getAllStudentInFoInClass(listStudentId);
    listStudentClass = listAllStudentInClass;
    emit(state + 2);
  }

  StudentClassModel getStudentClass(int studentId) {
    StudentClassModel? studentClassModel;
    for (var i in listStudentClass!) {
      if (i.userId == studentId) {
        studentClassModel = i;
        break;
      }
    }
    return studentClassModel!;
  }
}

class MenuPopupCubit extends Cubit<int> {
  MenuPopupCubit() : super(0);

  update() {
    emit(state + 1);
  }
}
