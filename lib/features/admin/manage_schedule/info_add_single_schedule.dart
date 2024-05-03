import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'add_single_schedule_cubit.dart';

class InfoAddSingleScheduleView extends StatelessWidget {
  const InfoAddSingleScheduleView({super.key, required this.addCubit, required this.info});
  final AddSingleScheduleCubit addCubit;
  final String info;
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
                addCubit.deleteTeacher();
              },
              onChange: (newValue) {
                addCubit.searchTeacher(newValue);
              },
              controller: addCubit.teacherSearch,
              enable: addCubit.teacherId == null),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      child: Text("${AppText.txtChangeTeacherTo.text} ${addCubit.teacherSearch.text}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: greyColor.shade600))),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      child: Text("${AppText.txtScheduleInfo.text} $info",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: greyColor.shade600))),
                ],
              ),
              if (addCubit.teacherId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("teacher")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? Container()
                          : TeacherSearchSingleSchedule(
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
