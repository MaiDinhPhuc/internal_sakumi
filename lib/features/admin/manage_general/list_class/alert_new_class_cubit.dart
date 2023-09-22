import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertNewClassCubit extends Cubit<int> {
  AlertNewClassCubit() : super(0);

  List<CourseModel>? listCourse;
  List<ClassModel>? listClass;
  int? courseId;
  String? selector;
  bool? check;
  List<String> listClassType = ['Lớp chung','Lớp 1-1'];
  int classType = 0;

  loadCourse() async {
    listClass = await FireBaseProvider.instance.getAllClass();
    listCourse = await FireBaseProvider.instance.getAllCourse();
    emit(state + 1);
  }

  chooseCourse(String? text) async {
    selector = text;
    emit(state + 1);
    await getCourseId(selector!);
  }

  chooseType(String? text) async {
    if(text == listClassType[0]){
      classType = 0;
    }else{
      classType = 1;
    }
    emit(state + 1);
  }

  String findCourse(int courseId)  {
    for(var i in listCourse!){
      if(i.courseId == courseId){
        return '${i.title} ${i.termName}';
      }
    }
    return AppText.textChooseCourse.text;
  }

  getCourseId(String text) async {
    var title = text.split('Kỳ').first.trim();
    var term = text.split(title).last.trim();
    var course = await FireBaseProvider.instance.getCourseByName(title, term);

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