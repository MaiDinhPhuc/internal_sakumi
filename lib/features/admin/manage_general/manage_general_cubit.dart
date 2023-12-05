import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageGeneralCubit extends Cubit<int> {
  ManageGeneralCubit() : super(-1);
  List<ClassModel>? listAllClass;
  List<ClassModel>? listClassNow;
  List<TeacherModel>? listTeacher;
  List<StudentModel>? listStudent;
  List<TeacherClassModel>? listTeacherClass;
  List<StudentClassModel>? listStudentClass;
  List<CourseModel>? listAllCourse;
  int selector = -1;
  //List<bool> listStateCourse = [];
  final TextEditingController searchTextController = TextEditingController();
  List<bool> listStateClassStatus = [true, true, false, false];
  List<bool> listClassType = [true, true];
  bool canAdd = true;

  List<bool> listCourseTypeFilter = [false, false, false, false, false];
  List<String> listCourseTypeMenuAdmin = [
    "GENERAL",
    "KAIWA",
    "JLPT",
    "KID",
    "1VS1"
  ];
  List<bool> levelFilter = [false, false, false, false, false];
  List<String> listLevelMenu = ["N5", "N4", "N3", "N2", "N1"];

  List<String> listTeacherClassStatus = ["InProgress","Remove"];

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
    listAllCourse = await FireBaseProvider.instance.getAllCourse();
    listAllClass = list;
    filterClass();
    emit(listAllClass!.first.classId);
  }

  loadAfterAddClass(int index) async {
    final List<ClassModel> list = await FireBaseProvider.instance.getListClassNotRemove();
    listAllClass = list;
    filterClass();
    selector = index;
    canAdd = true;
    emit(selector);
    loadTeacherInClass(selector);
    loadStudentInClass(selector);
  }

  loadAfterChangeClassStatus() async {
    final List<ClassModel> list = await FireBaseProvider.instance.getListClassNotRemove();
    listAllClass = list;
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
    var list1 = [];
    var list2 = [];
    var list3 = [];
    var list4 = [];

    for (int i = 0; i < listClassType.length; i++) {
      if (listClassType[i] == true) {
        list1.add(i);
      }
    }

    for (int i = 0; i < listCourseTypeFilter.length; i++) {
      if (listCourseTypeFilter[i] == true) {
        list2.add(listCourseTypeMenuAdmin[i]);
      }
    }

    for (int i = 0; i < listStateClassStatus.length; i++) {
      if (listStateClassStatus[i] == true) {
        list3.add(listClassStatusMenu[i]);
      }
    }

    for (int i = 0; i < levelFilter.length; i++) {
      if (levelFilter[i] == true) {
        list4.add(listLevelMenu[i]);
      }
    }

    listClassNow = listAllClass!
        .where((e) =>
    list3.contains(e.classStatus) &&
        list1.contains(e.classType) &&
        (list2.isEmpty
            ? true
            : list2.contains(getCourseOfClass(e.courseId).type.toUpperCase())) &&
        (list4.isEmpty
            ? true
            : list4.contains(getCourseOfClass(e.courseId).level.toUpperCase())))
        .toList();
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

  search(String value){
    if(value == ""){
      filterClass();
      emit(state+1);
    }else{
      listClassNow = listAllClass!.where((e) => e.classCode.toUpperCase().contains(value.toUpperCase())).toList();
      emit(state+1);
    }
  }

  CourseModel getCourseOfClass(int courseId){
    return listAllCourse!.firstWhere((e) => e.courseId == courseId);
  }

  loadTeacherInClass(int selector) async {
    listTeacher = null;
    listTeacherClass = null;
    var listAllTeacherInClass =
        await FireBaseProvider.instance.getAllTeacherInClassByClassId(selector);
    List<int> listTeacherId = [];
    for(var i in listAllTeacherInClass){
      listTeacherId.add(i.userId);
    }
    listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
    listTeacherClass = listAllTeacherInClass;
    emit(state + 2);
  }

  loadAfterRemoveTeacher(TeacherModel teacher) {
    for (int i = 0; i < listTeacher!.length; i++) {
      if (teacher.userId == listTeacher![i].userId) {
        listTeacher!.remove(listTeacher![i]);
        break;
      }
    }
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

  TeacherClassModel getTeacherClass(int teacherId) {
    TeacherClassModel? teacherClassModel;
    for (var i in listTeacherClass!) {
      if (i.userId == teacherId) {
        teacherClassModel = i;
        break;
      }
    }
    return teacherClassModel!;
  }
}

class MenuPopupCubit extends Cubit<int> {
  MenuPopupCubit() : super(0);

  update() {
    emit(state + 1);
  }
}
