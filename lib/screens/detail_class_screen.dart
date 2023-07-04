import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
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
  var roles = [AppText.selectorStudent.text, AppText.selectorTeacher.text];

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
                                    List<StudentModel>?>(
                                bloc: studentsInClassCubit,
                                builder: (c, list) => list == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : list.isEmpty
                                        ? const Center(
                                            child: Text('No student'),
                                          )
                                        : Column(
                                            children: list
                                                .map((e) => Text(e.name))
                                                .toList(),
                                          )
                                // {
                                //   if (list.isEmpty) {
                                //     return const Text('No student');
                                //   }
                                //   return Column(
                                //     children:
                                //         list.map((e) => Text(e.name)).toList(),
                                //   );
                                // }
                                )),
                        Expanded(
                            child: BlocBuilder<TeachersInClassCubit,
                                    List<TeacherModel>>(
                                bloc: teachersInClassCubit,
                                builder: (c, list) {
                                  if (list.isEmpty) {
                                    return const Text('No teacher');
                                  }
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
                      child: PopupMenuButton(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(1000)),
                          child: Container(),
                          onSelected: (value) async {
                            // Navigator.pushNamed(context, Routes.addUserToClass,
                            //     arguments: {
                            //       'isStudent': value == 0 ? true : false,
                            //       'classId': classModel.classId
                            //     });
                            if (value == 0) {
                              Navigator.pushNamed(
                                  context, Routes.addUserToClass, arguments: {
                                'isStudent': true,
                                'classId': classModel.classId
                              });
                            }
                            if (value == 1 && context.mounted) {
                              Navigator.pushNamed(
                                  context, Routes.addUserToClass, arguments: {
                                'isStudent': false,
                                'classId': classModel.classId
                              });
                            }
                          },
                          itemBuilder: (BuildContext c) {
                            return roles
                                .map((e) => PopupMenuItem(
                                    value: roles.indexOf(e), child: Text(e)))
                                .toList();
                          }))
                ],
              ),
            ),
          ],
        ));
  }
}

class StudentsInClassCubit extends Cubit<List<StudentModel>?> {
  final ClassModel classModel;
  StudentsInClassCubit(this.classModel) : super(null) {
    load();
  }

  load() async {
    List<int> list = [];
    List<StudentModel> listStudent = [];
    List<StudentModel> listAllStudent = await AdminRepository.getAllStudent();
    List<StudentClassModel> listStudentClass =
        await AdminRepository.getStudentClassByClassId(classModel.classId);

    for (var i in listStudentClass) {
      list.add(i.userId);
    }

    list = LinkedHashSet<int>.from(list.map((e) => e)).toList();

    for (var i in list) {
      listStudent
          .add(listAllStudent.where((element) => element.userId == i).single);
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
    List<int> list = [];
    List<TeacherModel> listTeacher = [];
    List<TeacherModel> listAllTeacher = await AdminRepository.getAllTeacher();
    List<TeacherClassModel> listTeacherClass =
        await TeacherRepository.getTeacherClassById(
            'class_id', classModel.classId);
    for (var i in listTeacherClass) {
      list.add(i.userId);
    }

    list = LinkedHashSet<int>.from(list.map((e) => e)).toList();

    for (var i in list) {
      listTeacher
          .add(listAllTeacher.where((element) => element.userId == i).single);
    }

    emit(listTeacher);
  }
}
