import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  loadCourse(context) async {
    listClass = await FireBaseProvider.instance.getAllClass();
    listCourse = await FireBaseProvider.instance.getAllCourse();
    emit(state + 1);
  }

  choose(String? text, context) async {
    selector = text;
    emit(state + 1);
    await getCourseId(context, selector!);
  }

  getCourseId(BuildContext context, String text) async {
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
}