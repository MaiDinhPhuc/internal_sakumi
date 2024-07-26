import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../services/custom_firebase_firestore.dart';
import 'add_cyclic_schedule_cubit.dart';
import 'choose_cyclic_time.dart';

class InfoCyclicScheduleView extends StatelessWidget {
  const InfoCyclicScheduleView({super.key, required this.addCubit});
  final AddCyclicScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtTeacherName.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: greyColor.shade600)),
          SizedBox(height: Resizable.padding(context, 5)),
          SearchInBill(
              hint:AppText.txtSearchTeacher.text,
              onDelete: () {
                if(addCubit.schedule == null){
                  addCubit.deleteTeacher();
                }
              },
              onChange: (newValue) {
                addCubit.searchTeacher(newValue);
              },
              controller: addCubit.teacherSearch,
              enable:addCubit.schedule == null ? addCubit.teacherId == null : false),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      child: Text(AppText.txtClass.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: greyColor.shade600))),
                  SearchInBill(
                      hint:AppText.txtSearchClass.text,
                      onDelete: () {
                        if(addCubit.schedule == null){
                          addCubit.deleteClass();
                        }

                      },
                      onChange: (newValue) {
                        addCubit.searchClass(newValue);
                      },
                      controller: addCubit.classSearch,
                      enable:addCubit.schedule == null ? addCubit.classId == null : false ),
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtSchedule.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: greyColor.shade600))),
                          ChooseCyclicTime(addCubit: addCubit)
                        ],
                      ),
                      if (addCubit.classId == null)
                        StreamBuilder<QuerySnapshot>(
                            stream: CustomFirebaseFireStore.database
                                .collection("class")
                                .snapshots(),
                            builder: (c, snapshots) {
                              return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                                  ? Container()
                                  : ClassSearchCyclicSchedule(
                                  snapshots: snapshots, addCubit: addCubit,
                                  );
                            })
                    ],
                  ),
                ],
              ),
              if (addCubit.teacherId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: CustomFirebaseFireStore.database
                        .collection("teacher")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? Container()
                          : TeacherSearchCyclicSchedule(
                          snapshots: snapshots, addCubit: addCubit
                       );
                    })
            ],
          )
        ],
      ),
    );
  }
}
