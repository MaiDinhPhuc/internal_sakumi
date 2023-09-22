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
  int selector = 0;
  List<bool> listStateCourse = [];
  List<bool> listStateClassStatus = [true,true,true,true];
  List<bool> listClassType = [true,true];
  bool canAdd = true;

  List<String> listStudentStatusMenu = ["Completed","InProgress","Viewer","ReNew","UpSale","Moved","Retained","Dropped","Remove"];
  List<String> listClassStatusMenu = ["Preparing", "InProgress", "Completed", "Cancel"];
  List<String> listAllClassStatusMenu = ["Preparing", "InProgress", "Completed", "Cancel", "Remove"];
  List<String> listClassTypeMenu = ["Lớp Chung","Lớp 1-1"];

  loadAllClass(context) async {
    listAllClass = await FireBaseProvider.instance.getListClassNotRemove();
    listAllCourse = await FireBaseProvider.instance.getAllCourse();
    listClassNow = listAllClass;
    for(int i = 0; i < listAllCourse!.length ;i++){
      listStateCourse.add(true);
    }
    emit(listAllClass!.first.classId);
    selector = listAllClass!.first.classId;
    loadTeacherInClass(context, selector);
    loadStudentInClass(context, selector);
  }

  loadAfterAddClass(int index,context) async {
    listAllClass = await FireBaseProvider.instance.getListClassNotRemove();
    listAllCourse = await FireBaseProvider.instance.getAllCourse();
    listClassNow = listAllClass;
    selector = index;
    canAdd = true;
    emit(selector);
    loadTeacherInClass(context, selector);
    loadStudentInClass(context, selector);
  }

  loadAfterChangeClassStatus()async{
    listAllClass = await FireBaseProvider.instance.getListClassNotRemove();
    filterClass();
    emit(state+2);
  }

  selectedClass(int index, context) {
    selector = index;
    canAdd = true;
    emit(selector);
    loadTeacherInClass(context, index);
    loadStudentInClass(context, index);
  }

  filterClass(){
    listClassNow = [];

    List<int> listCourseNow = [];
    for(int i = 0; i<listStateCourse.length; i++){
      if(listStateCourse[i] == true){
        listCourseNow.add(listAllCourse![i].courseId);
      }
    }

    List<String> listCLassStatus = [];
    for(int i = 0; i<listStateClassStatus.length; i++){
      if(listStateClassStatus[i] == true){
        listCLassStatus.add(listClassStatusMenu[i]);
      }
    }

    List<ClassModel> listTemp1 = [];

    for(var i in listAllClass!){
      for(var j in listCourseNow){
        if(i.courseId == j){
          listTemp1.add(i);
          break;
        }
      }
    }
    List<ClassModel> listTemp2 = [];
    for(var i in listTemp1){
      for(var j in listCLassStatus){
        if(i.classStatus == j){
          listTemp2.add(i);
        }
      }
    }
    List<int> listType = [];
    if(listClassType[0] == true){
      listType.add(0);
    }
    if(listClassType[1] == true){
      listType.add(1);
    }
    for(var i in listTemp2){
      for(var j in listType){
        if(i.classType == j){
          listClassNow!.add(i);
        }
      }
    }

    bool change = true;
    for(var i in listClassNow!){
      if(i.classId == selector){
        change = false;
        break;
      }
    }
    if(change){
      listTeacher = [];
      listStudent = [];
      canAdd = false;
    }

    emit(state+2);
  }



  loadTeacherInClass(BuildContext context, int selector)async{
    listTeacher = null;
    var listAllTeacher = await FireBaseProvider.instance.getAllTeacher();
    var listAllTeacherInClass = await FireBaseProvider.instance.getAllTeacherInClassByClassId(selector);
    debugPrint('============> loadTeacherInClass ${listAllTeacherInClass.length}');
    listTeacher = [];
    for(var i in listAllTeacher){
      for(var j in listAllTeacherInClass){
        if(i.userId == j.userId){
          listTeacher!.add(i);
        }
      }
    }
    emit(state+2);
  }

  loadAfterRemoveStudent(StudentModel student){
    for(int i= 0; i<listStudent!.length; i++){
      if(student.userId == listStudent![i].userId){
        listStudent!.remove(listStudent![i]);
        break;
      }
    }
    emit(state+2);
  }

  loadStudentInClass(context, int selector)async{
    listStudent = null;
    listStudentClass = null;
    debugPrint('============> loadStudentInClass 1');
    debugPrint('============> loadStudentInClass 2');
    var listAllStudent = await FireBaseProvider.instance.getAllStudent();
    debugPrint('============> loadStudentInClass 3 $selector');
    List<StudentClassModel> listAllStudentInClass = await FireBaseProvider.instance.getStudentClassInClass(selector);
    debugPrint('============> loadStudentInClass 4');
    listStudent = [];
    listStudentClass = listAllStudentInClass;
    for(var i in listAllStudent){
      debugPrint('============> loadStudentInClass 5');
      for(var j in listAllStudentInClass){
        if(i.userId == j.userId && j.classStatus != "Remove"){
          listStudent!.add(i);
        }
      }
      debugPrint('============> loadStudentInClass 6');
    }
    debugPrint('============> loadStudentInClass ${listStudent!.length}');
    emit(state+2);
  }


  StudentClassModel getStudentClass(int studentId){
    StudentClassModel? studentClassModel;
    for(var i in listStudentClass!){
      if(i.userId == studentId){
        studentClassModel = i;
        break;
      }
    }
    return studentClassModel!;
  }
}

class MenuPopupCubit extends Cubit<int>{
  MenuPopupCubit():super(0);

  update(){
    emit(state+1);
  }
}