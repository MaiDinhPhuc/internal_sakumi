import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertNewClassCubit extends Cubit<int> {
  AlertNewClassCubit() : super(0);

  List<CourseModel>? listCourse;
  List<ClassModel>? listClass;
  int? courseId;
  String? selector;
  bool? check;

  loadCourse(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    listClass = await adminRepository.getListClass();
    listCourse = await adminRepository.getAllCourse();
    emit(state + 1);
  }

  choose(String? text, context) async {
    selector = text;
    emit(state + 1);
    await getCourseId(context, selector!);
  }

  getCourseId(BuildContext context, String text) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    var title = text.split('Kỳ').first.trim();
    var term = text.split(title).last.trim();
    var course = await adminRepository.getCourseByName(title, term);

    courseId = course.courseId;
  }

  addNewClass(BuildContext context, ClassModel model) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    Navigator.pop(context);
    waitingDialog(context);
    check = await adminRepository.createNewClass(model, context);
  }
}