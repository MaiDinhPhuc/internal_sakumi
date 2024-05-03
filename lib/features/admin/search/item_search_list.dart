import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_dialog_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/add_schedule_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/add_single_schedule_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/manage_schedule_cubit.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'item_search.dart';

class ItemSearchList extends StatelessWidget {
  const ItemSearchList(
      {super.key, required this.searchCubit, required this.snapshots});
  final SearchCubit searchCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return searchCubit.searchValue == ""
        ? Container()
        : Container(
            constraints: BoxConstraints(
              maxHeight: Resizable.padding(context, 250), // max height
            ),
            margin: EdgeInsets.only(
                left: Resizable.padding(context, 110),
                top: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (c, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (searchCubit.searchValue.isEmpty) {
                    return Container();
                  }
                  if (searchCubit.type == AppText.txtClass.text) {
                    if (data["class_code"]
                        .toString()
                        .toUpperCase()
                        .contains(searchCubit.searchValue.toUpperCase()) && data["is_sub_class"] == false) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        classStatus: data["class_status"],
                        code: data["class_code"] ?? "",
                        classType: data["class_type"] ?? 0,
                        id: data["class_id"],
                      );
                    }
                  }

                  if (searchCubit.type == AppText.txtStudent.text) {
                    if (data["name"]
                            .toString()
                            .toLowerCase()
                            .contains(searchCubit.searchValue.toLowerCase()) ||
                        data["student_code"]
                            .toString()
                            .toLowerCase()
                            .contains(searchCubit.searchValue.toLowerCase()) || data["email"]
                        .toString()
                        .toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase())) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        url: data["url"] ?? "",
                        name: data["name"] ?? "",
                        code: data["student_code"] ?? "",
                        id: data["user_id"],
                        email: data["email"],
                      );
                    }
                  }

                  if (searchCubit.type == AppText.txtTeacher.text) {
                    if (data["name"]
                            .toString()
                            .toLowerCase()
                            .contains(searchCubit.searchValue.toLowerCase()) ||
                        data["teacher_code"]
                            .toString()
                            .toLowerCase()
                            .contains(searchCubit.searchValue.toLowerCase()) || data["email"]
                        .toString()
                        .toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase())) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        url: data["url"] ?? "",
                        name: data["name"] ?? "",
                        code: data["teacher_code"] ?? "",
                        id: data["user_id"],
                        email: data["email"],
                      );
                    }
                  }

                  return Container();
                }));
  }
}

class StdSearchListV2 extends StatelessWidget {
  const StdSearchListV2(
      {super.key, required this.billDialogCubit, required this.snapshots});
  final BillDialogCubit billDialogCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return billDialogCubit.stdSearchValue == ""
        ? Container()
        : Container(
            constraints: BoxConstraints(
              maxHeight: Resizable.padding(context, 250), // max height
            ),
            margin: EdgeInsets.only(
                //left: Resizable.padding(context, 110),
                top: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (c, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (billDialogCubit.stdSearchValue.isEmpty) {
                    return Container();
                  }
                  if (data["name"].toString().toLowerCase().contains(
                          billDialogCubit.stdSearchValue.toLowerCase()) ||
                      data["student_code"].toString().toLowerCase().contains(
                          billDialogCubit.stdSearchValue.toLowerCase())||
                      data["email"].toString().toLowerCase().contains(
                          billDialogCubit.stdSearchValue.toLowerCase())) {
                    return ItemSearchV2(
                      type: AppText.txtStudent.text,
                      isLast: index == (snapshots.data!.docs.length - 1),
                      url: data["url"] ?? "",
                      name: data["name"] ?? "",
                      code: data["student_code"] ?? "",
                      id: data["user_id"],
                      onTap: () {
                        billDialogCubit.chooseStd(
                            "${data["name"] ?? ""}-${data["student_code"] ?? ""}",
                            data["user_id"]);
                      },
                      email: data["email"],
                    );
                  }
                  return Container();
                }));
  }
}

class ClassSearchListV2 extends StatelessWidget {
  const ClassSearchListV2(
      {super.key, required this.billDialogCubit, required this.snapshots});
  final BillDialogCubit billDialogCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return billDialogCubit.classSearchValue == ""
        ? Container()
        : Container(
            constraints: BoxConstraints(
              maxHeight: Resizable.padding(context, 250), // max height
            ),
            margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (c, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (billDialogCubit.classSearchValue.isEmpty) {
                    return Container();
                  }
                  if (data["class_code"].toString().toLowerCase().contains(
                      billDialogCubit.classSearchValue.toLowerCase())&& data["is_sub_class"] == false) {
                    return ItemSearchV2(
                      type: AppText.txtClass.text,
                      isLast: index == (snapshots.data!.docs.length - 1),
                      classStatus: data["class_status"],
                      code: data["class_code"] ?? "",
                      classType: data["class_type"] ?? 0,
                      id: data["class_id"],
                      onTap: () {
                        billDialogCubit.chooseClass(
                            "${data["class_code"] ?? ""}",
                            data["class_id"],
                            data['course_id'],
                            data['class_type']);
                      },
                    );
                  }
                  return Container();
                }));
  }
}

class ClassSearchListSchedule extends StatelessWidget {
  const ClassSearchListSchedule(
      {super.key, required this.scheduleCubit, required this.snapshots});
  final ManageScheduleCubit scheduleCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return scheduleCubit.classSearchValue == ""
        ? Container()
        : Container(
        constraints: BoxConstraints(
          maxHeight: Resizable.padding(context, 250), // max height
        ),
        margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (c, index) {
              var data = snapshots.data!.docs[index].data()
              as Map<String, dynamic>;
              if (scheduleCubit.classSearchValue.isEmpty) {
                return Container();
              }
              if (data["class_code"].toString().toLowerCase().contains(
                  scheduleCubit.classSearchValue.toLowerCase())&& data["is_sub_class"] == false) {
                return ItemSearchV2(
                  type: AppText.txtClass.text,
                  isLast: index == (snapshots.data!.docs.length - 1),
                  classStatus: data["class_status"],
                  code: data["class_code"] ?? "",
                  classType: data["class_type"] ?? 0,
                  id: data["class_id"],
                  onTap: () {
                    scheduleCubit.chooseClass(
                        "${data["class_code"] ?? ""}",
                        data["class_id"]);
                  },
                );
              }
              return Container();
            }));
  }
}

class TeacherSearchListSchedule extends StatelessWidget {
  const TeacherSearchListSchedule(
      {super.key, required this.scheduleCubit, required this.snapshots});
  final ManageScheduleCubit scheduleCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return scheduleCubit.teacherSearchValue == ""
        ? Container()
        : Container(
        constraints: BoxConstraints(
          maxHeight: Resizable.padding(context, 250), // max height
        ),
        margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (c, index) {
              var data = snapshots.data!.docs[index].data()
              as Map<String, dynamic>;
              if (scheduleCubit.teacherSearchValue.isEmpty) {
                return Container();
              }
              if (data["name"].toString().toLowerCase().contains(
                  scheduleCubit.teacherSearchValue.toLowerCase()) || data["teacher_code"].toString().toLowerCase().contains(
                  scheduleCubit.teacherSearchValue.toLowerCase()) ||data["email"].toString().toLowerCase().contains(
                  scheduleCubit.teacherSearchValue.toLowerCase())) {
                return ItemSearchV2(
                  type: AppText.txtTeacher.text,
                  isLast: index == (snapshots.data!.docs.length - 1),
                  url: data["url"] ?? "",
                  name: data["name"] ?? "",
                  code: data["teacher_code"] ?? "",
                  id: data["user_id"],
                  email: data["email"],
                  onTap: () {
                    scheduleCubit.chooseTeacher(
                        "${data["name"] ?? ""} - ${data["teacher_code"] ?? ""}",
                        data["user_id"]);
                  },
                );
              }
              return Container();
            }));
  }
}

class ClassSearchListScheduleV2 extends StatelessWidget {
  const ClassSearchListScheduleV2(
      {super.key, required this.addCubit, required this.snapshots});
  final AddScheduleCubit addCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return addCubit.classSearchValue == ""
        ? Container()
        : Container(
        constraints: BoxConstraints(
          maxHeight: Resizable.padding(context, 250), // max height
        ),
        margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (c, index) {
              var data = snapshots.data!.docs[index].data()
              as Map<String, dynamic>;
              if (addCubit.classSearchValue.isEmpty) {
                return Container();
              }
              if (data["class_code"].toString().toLowerCase().contains(
                  addCubit.classSearchValue.toLowerCase())&& data["is_sub_class"] == false) {
                return ItemSearchV2(
                  type: AppText.txtClass.text,
                  isLast: index == (snapshots.data!.docs.length - 1),
                  classStatus: data["class_status"],
                  code: data["class_code"] ?? "",
                  classType: data["class_type"] ?? 0,
                  id: data["class_id"],
                  onTap: () {
                    addCubit.chooseClass(
                        "${data["class_code"] ?? ""}",
                        data["class_id"]);
                  },
                );
              }
              return Container();
            }));
  }
}

class TeacherSearchListScheduleV2 extends StatelessWidget {
  const TeacherSearchListScheduleV2(
      {super.key, required this.addCubit, required this.snapshots});
  final AddScheduleCubit addCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return addCubit.teacherSearchValue == ""
        ? Container()
        : Container(
        constraints: BoxConstraints(
          maxHeight: Resizable.padding(context, 250), // max height
        ),
        margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (c, index) {
              var data = snapshots.data!.docs[index].data()
              as Map<String, dynamic>;
              if (addCubit.teacherSearchValue.isEmpty) {
                return Container();
              }
              if (data["name"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase()) || data["teacher_code"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase()) ||data["email"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase())) {
                return ItemSearchV2(
                  type: AppText.txtTeacher.text,
                  isLast: index == (snapshots.data!.docs.length - 1),
                  url: data["url"] ?? "",
                  name: data["name"] ?? "",
                  code: data["teacher_code"] ?? "",
                  id: data["user_id"],
                  email: data["email"],
                  onTap: () {
                    addCubit.chooseTeacher(
                        "${data["name"] ?? ""} - ${data["teacher_code"] ?? ""}",
                        data["user_id"]);
                  },
                );
              }
              return Container();
            }));
  }
}

class TeacherSearchSingleSchedule extends StatelessWidget {
  const TeacherSearchSingleSchedule(
      {super.key, required this.addCubit, required this.snapshots});
  final AddSingleScheduleCubit addCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return addCubit.teacherSearchValue == ""
        ? Container()
        : Container(
        constraints: BoxConstraints(
          maxHeight: Resizable.padding(context, 250), // max height
        ),
        margin: EdgeInsets.only(top: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (c, index) {
              var data = snapshots.data!.docs[index].data()
              as Map<String, dynamic>;
              if (addCubit.teacherSearchValue.isEmpty) {
                return Container();
              }
              if (data["name"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase()) || data["teacher_code"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase()) ||data["email"].toString().toLowerCase().contains(
                  addCubit.teacherSearchValue.toLowerCase())) {
                return ItemSearchV2(
                  type: AppText.txtTeacher.text,
                  isLast: index == (snapshots.data!.docs.length - 1),
                  url: data["url"] ?? "",
                  name: data["name"] ?? "",
                  code: data["teacher_code"] ?? "",
                  id: data["user_id"],
                  email: data["email"],
                  onTap: () {
                    addCubit.chooseTeacher(
                        "${data["name"] ?? ""} - ${data["teacher_code"] ?? ""}",
                        data["user_id"]);
                  },
                );
              }
              return Container();
            }));
  }
}
