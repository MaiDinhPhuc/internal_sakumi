import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DetailClassScreen extends StatelessWidget {
  final ClassModel classModel;
  final StudentsInClassCubit studentsInClassCubit;
  final TeachersInClassCubit teachersInClassCubit;
  DetailClassScreen({required this.classModel, Key? key})
      : studentsInClassCubit = StudentsInClassCubit(classModel),
        teachersInClassCubit = TeachersInClassCubit(classModel),
        super(key: key);

  var list = [AppText.btnRemove.text, AppText.btnEdit.text];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(classModel.classCode),
          actions: [
            PopupMenuButton(onSelected: (value) async {
              if (value == 0) {
                var nav = Navigator.popUntil(
                    context, ModalRoute.withName(Routes.admin));
                // var nav = Navigator.of(context, rootNavigator: true)
                //     .pushReplacementNamed(Routes.admin);
                await FirebaseFirestore.instance
                    .collection('class')
                    .doc(
                        "class_${classModel!.classId}_course_${classModel!.courseId}")
                    .update({'status': 'remove'});
                await Future.delayed(const Duration(milliseconds: 1000));
                nav;
              }
              if (value == 1 && context.mounted) {
                Navigator.pushNamed(context, Routes.addClass,
                    arguments: {'classModel': classModel});
              }
            }, itemBuilder: (BuildContext c) {
              return list
                  .map((e) =>
                      PopupMenuItem(value: list.indexOf(e), child: Text(e)))
                  .toList();
            })
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                            child: BlocBuilder<StudentsInClassCubit,
                                    List<StudentModel>>(
                                bloc: studentsInClassCubit,
                                builder: (c, list) {
                                  if (list.isEmpty)
                                    return const Text('No student');
                                  return Column(
                                    children:
                                        list.map((e) => Text(e.name)).toList(),
                                  );
                                })),
                        Expanded(
                            child: BlocBuilder<TeachersInClassCubit,
                                    List<TeacherModel>>(
                                bloc: teachersInClassCubit,
                                builder: (c, list) {
                                  if (list.isEmpty)
                                    return const Text('No teacher');
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:
                                        list.map((e) => Text(e.name)).toList(),
                                  );
                                })),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(
                  bottom: Resizable.padding(context, 20),
                  right: Resizable.padding(context, 20)),
              child: Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: Resizable.size(context, 30),
                      height: Resizable.size(context, 30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: Resizable.size(context, 5))
                          ]),
                      child: Icon(
                        Icons.add,
                        size: Resizable.size(context, 20),
                        color: Colors.white,
                      )),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000),
                      // onTap: () => Navigator.pushNamed(
                      //     context, Routes.addStudent,
                      //     arguments: {'studentModel': null}),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ));
  }
}

class StudentsInClassCubit extends Cubit<List<StudentModel>> {
  final ClassModel classModel;
  StudentsInClassCubit(this.classModel) : super([]) {
    load();
  }

  load() async {
    List<StudentModel> lists = await AdminRepository.getListStudent()
      ..where((element) => element.status == 'progress');
    List<StudentModel> listStudent = [];
    for (var i in classModel.listStudent) {
      listStudent.add(lists.where((e) => e.userId == i).single);
    }
    emit(listStudent);
  }
}

class TeachersInClassCubit extends Cubit<List<TeacherModel>> {
  final ClassModel classModel;
  TeachersInClassCubit(this.classModel) : super([]) {
    load();
  }

  load() async {
    List<TeacherModel> lists = await AdminRepository.getListTeacher()
      ..where((element) => element.status == 'progress');
    List<TeacherModel> listTeacher = [];
    for (var i in classModel.listTeacher) {
      listTeacher.add(lists.where((e) => e.userId == i).single);
    }
    emit(listTeacher);
  }
}
