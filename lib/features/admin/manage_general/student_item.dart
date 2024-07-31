import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/features/class_info/over_view/confirm_change_student_class_status_v2.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/services/custom_firebase_firestore.dart';
import 'package:internal_sakumi/utils/functions.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'list_student/alert_confirm_change_student_status.dart';
import 'manage_general_cubit.dart';

class StudentItem extends StatelessWidget {
  const StudentItem({super.key, required this.student, required this.cubit});

  final StudentModel student;
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xffE0E0E0),
              width: Resizable.size(context, 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 10,
              child: Row(
                children: [
                  InkWell(onTap: () async{
                    await Functions.goPage("${Routes.admin}/studentInfo/student=${student.userId}", context);

                  }, child: SmallAvatar(student.url)),
                  SizedBox(width: Resizable.padding(context, 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: Resizable.size(context, 165),
                          child: Text("${student.name}\n${student.studentCode}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 16),
                                  color: Colors.black))),
                      SizedBox(height: Resizable.padding(context, 3)),
                      Text(student.email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Resizable.font(context, 13),
                              color: const Color(0xff757575)))
                    ],
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: BlocProvider(
                create: (context) => MenuPopupCubit(),
                child: BlocBuilder<MenuPopupCubit, int>(
                  builder: (cc, s) {
                    var popupCubit = BlocProvider.of<MenuPopupCubit>(cc);
                    return Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color:
                                  cubit.getStudentClass(student.userId).color)
                        ],
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: PopupMenuButton(
                              itemBuilder: (context) => [
                                    ...cubit.listStudentStatusMenu.map((e) =>
                                        PopupMenuItem(
                                            padding: EdgeInsets.zero,
                                            child: BlocProvider(
                                                create: (context) =>
                                                    CheckBoxFilterCubit(cubit
                                                            .getStudentClass(
                                                                student.userId)
                                                            .status ==
                                                        e),
                                                child: BlocBuilder<
                                                    CheckBoxFilterCubit,
                                                    bool>(builder: (c, state) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      if (cubit
                                                              .getStudentClass(
                                                                  student
                                                                      .userId)
                                                              .status !=
                                                          e) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                ConfirmChangeStudentClassStatus(
                                                                  e,
                                                                  cubit.getStudentClass(
                                                                      student
                                                                          .userId),
                                                                  student,
                                                                  onTap:
                                                                      () async {
                                                                    var stdClass =
                                                                        cubit.getStudentClass(
                                                                            student.userId);
                                                                    CustomFirebaseFireStore
                                                                        .database
                                                                        .collection(
                                                                            'student_class')
                                                                        .doc(
                                                                            'student_${student.userId}_class_${stdClass.classId}')
                                                                        .update({
                                                                      'class_status':
                                                                          e,
                                                                      "last_time_change":
                                                                          DateTime.now()
                                                                              .millisecondsSinceEpoch
                                                                    }).whenComplete(
                                                                            () async {
                                                                      if (e ==
                                                                          "Remove") {
                                                                        List<StudentClassModel>
                                                                            list =
                                                                            [];

                                                                        for (var i
                                                                            in cubit.listStudentClass!) {
                                                                          if (i.userId !=
                                                                              student.userId) {
                                                                            list.add(i);
                                                                          }
                                                                        }

                                                                        DataProvider.updateStdClass(
                                                                            stdClass.classId,
                                                                            list);
                                                                        cubit.loadAfterRemoveStudent(
                                                                            student);
                                                                        Navigator.pop(
                                                                            context);
                                                                        waitingDialog(
                                                                            context);
                                                                      } else {
                                                                        var classModel = await FireBaseProvider
                                                                            .instance
                                                                            .getClassById(stdClass.classId);
                                                                        Create.addNewLog(StudentClassLogModel(
                                                                            id: DateTime.now()
                                                                                .millisecondsSinceEpoch,
                                                                            classId:
                                                                                stdClass.classId,
                                                                            courseId: classModel.courseId,
                                                                            from: stdClass.status,
                                                                            to: e,
                                                                            userId: stdClass.userId,
                                                                            classType: classModel.classType));
                                                                        List<StudentClassModel>
                                                                            list =
                                                                            [];

                                                                        for (var i
                                                                            in cubit.listStudentClass!) {
                                                                          if (i.userId !=
                                                                              student.userId) {
                                                                            list.add(i);
                                                                          } else {
                                                                            list.add(StudentClassModel(
                                                                                id: stdClass.id,
                                                                                classId: stdClass.classId,
                                                                                activeStatus: stdClass.activeStatus,
                                                                                learningStatus: stdClass.learningStatus,
                                                                                moveTo: stdClass.moveTo,
                                                                                userId: stdClass.userId,
                                                                                classStatus: e,
                                                                                date: stdClass.date,
                                                                                timeChange: stdClass.timeChange));
                                                                          }
                                                                        }
                                                                        DataProvider.updateStdClass(
                                                                            stdClass.classId,
                                                                            list);
                                                                        cubit
                                                                            .getStudentClass(student.userId)
                                                                            .status = e;
                                                                        popupCubit
                                                                            .update();
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  },
                                                                ));
                                                      }
                                                    },
                                                    child: Container(
                                                        height: Resizable.size(
                                                            context, 33),
                                                        decoration: BoxDecoration(
                                                            color: state
                                                                ? primaryColor
                                                                : Colors.white),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: Resizable
                                                                      .padding(
                                                                          context,
                                                                          10)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  vietnameseSubText(
                                                                      e),
                                                                  style: TextStyle(
                                                                      fontSize: Resizable.font(
                                                                          context,
                                                                          15),
                                                                      color: state
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black)),
                                                              if (state)
                                                                const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                }))))
                                  ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Resizable.size(context, 10)),
                                ),
                              ),
                              child: Tooltip(
                                  padding: EdgeInsets.all(
                                      Resizable.padding(context, 10)),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                          color: Colors.black,
                                          width: Resizable.size(context, 1)),
                                      borderRadius: BorderRadius.circular(
                                          Resizable.padding(context, 5))),
                                  richMessage: WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: vietnameseSubText(cubit
                                                  .getStudentClass(
                                                      student.userId)
                                                  .status),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Resizable.font(
                                                      context, 18),
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: cubit
                                              .getStudentClass(student.userId)
                                              .color,
                                          borderRadius:
                                              BorderRadius.circular(1000)),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/ic_${cubit.getStudentClass(student.userId).icon}.png',
                                          scale: 50,
                                        ),
                                      ),
                                    ),
                                  )))),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
