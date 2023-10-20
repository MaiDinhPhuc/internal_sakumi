import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertNewClassCubit extends Cubit<int> {
  AlertNewClassCubit() : super(0);

  List<CourseModel>? listCourse;
  int? classCount;
  int? courseId;
  String? selector;
  bool? check;
  List<String> listClassType = ['Lớp chung','Lớp 1-1'];
  List<String> listClassStatusMenu = ["Preparing", "InProgress", "Completed", "Cancel"];
  int? classType ;
  String? classStatus;

  loadCourse() async {
    classCount = (await FireStoreDb.instance.getCount("class")).count;
    listCourse = await FireBaseProvider.instance.getAllCourseEnable();
    emit(state + 1);
  }

  chooseCourse(String? text) async {
    selector = text;
    await getCourseId(selector!);
    emit(state + 1);

  }

  int chooseType(String? text) {
    if(text == listClassType[0]){
      emit(state + 1);
      return 0;
    }
    return 1;
  }

  String chooseStatus(String? text) {
    switch (text) {
      case 'Hoàn Thành':
        emit(state + 1);
        return "Completed";
      case 'Đang Học':
        emit(state + 1);
        return "InProgress";
      case 'Huỷ':
        emit(state + 1);
        return "Cancel";
      case 'Mới Tạo':
        emit(state + 1);
        return "Preparing";
      default:
        emit(state + 1);
        return "error";
    }
  }

  String findClassType(int classType){
    if(classType == 0){
      return listClassType[0];
    }
    return listClassType[1];
  }

  String findCourse(int courseId)  {
    for(var i in listCourse!){
      if(i.courseId == courseId){
        return '${i.title} ${i.termName}';
      }
    }
    return AppText.textChooseCourse.text;
  }

  String findStatus(String status){
    return vietnameseSubText(status);
  }

  getCourseId(String text) async {
    CourseModel course = listCourse!.singleWhere((element) => '${element.title} ${element.termName} ${element.code}' == text);
    courseId = course.courseId;
  }

  addNewClass(BuildContext context, ClassModel model) async {
    Navigator.pop(context);
    waitingDialog(context);
    check = await FireBaseProvider.instance.createNewClass(model);
  }

  updateClass(BuildContext context, ClassModel model) async {
    Navigator.pop(context);
    waitingDialog(context);
    await FireBaseProvider.instance.updateClassInfo(model);
  }
}