import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/manage_schedule_cubit.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_item.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_taught_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/back_button.dart';

class ManageScheduleScreen extends StatelessWidget {
  ManageScheduleScreen({super.key}) : cubit = ManageScheduleCubit();

  final ManageScheduleCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 80)),
        child: SingleChildScrollView(child: Column(
          children: [
            SizedBox(height: Resizable.size(context, 20)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomBackTeacherScreenButton(),
              ],
            ),
            SizedBox(height: Resizable.size(context, 20)),
            Text(AppText.txtScheduleTeacher.text,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 30),
                    color: Colors.black)),
            BlocBuilder(
                bloc: cubit,
                builder: (c,s){
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)),
                            child: Text(AppText.txtClass.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 18),
                                    color: const Color(0xff757575)))),
                        SearchInBill(
                            hint:AppText.txtSearchClass.text,
                            onDelete: () {
                              cubit.deleteClass();
                            },
                            onChange: (newValue) {
                              cubit.searchClass(newValue);
                            },
                            controller: cubit.classSearch,
                            enable: cubit.classId == null),
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.txtSchedule.text.toUpperCase(),
                                    style: TextStyle(
                                        color: greyColor.shade600,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20))),
                                Container(
                                  margin:
                                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
                                  width: Resizable.size(context, 250),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: Resizable.size(context, 1), color: greyColor.shade300),
                                      borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
                                  child:
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    InkWell(
                                      onTap: () {
                                        cubit.previous();
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(Resizable.padding(context, 5)),
                                          child: Icon(Icons.arrow_back_ios_new_sharp,
                                              color: greyColor.shade600)),
                                    ),
                                    InkWell(
                                        child: Text(cubit.getRangeDate(),
                                            style: TextStyle(
                                                fontSize: Resizable.font(context, 20),
                                                fontWeight: FontWeight.w700,
                                                color: greyColor.shade600))),
                                    InkWell(
                                      onTap: () {
                                        cubit.next();
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(Resizable.padding(context, 5)),
                                          child: Icon(Icons.arrow_forward_ios_sharp,
                                              color: greyColor.shade600)),
                                    )
                                  ]),
                                ),
                                cubit.isLoadingSchedule
                                    ? const Center(child: CircularProgressIndicator())
                                    : Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                          height: Resizable.size(context, 500),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: Resizable.size(context, 1),
                                                  color: greyColor.shade300),
                                              borderRadius:
                                              BorderRadius.circular(Resizable.size(context, 5))),
                                          child: Column(
                                            children: [
                                              ...cubit.listDay.map((e) => Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            e,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: Resizable.font(context, 15),
                                                                color: greyColor.shade600),
                                                          ),
                                                          Text(
                                                            cubit.getDate(cubit.listDay.indexOf(e)),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: Resizable.font(context, 15),
                                                                color: greyColor.shade600),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(width: Resizable.padding(context, 10)),
                                                      SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            ...cubit
                                                                .getResult(cubit.listDay.indexOf(e))
                                                                .map((ee) => Padding(
                                                                padding: EdgeInsets.all(
                                                                    Resizable.padding(
                                                                        context, 3)),
                                                                child: ScheduleTaughtItemV2(
                                                                    cubit: cubit,
                                                                    lessonResultModel: ee))),
                                                            ...cubit
                                                                .getScheduleItem(
                                                                cubit.listDay.indexOf(e), e)
                                                                .map((e) => Padding(padding: EdgeInsets.all(
                                                                Resizable.padding(
                                                                    context, 3)),child: ScheduleItemV2(
                                                                cubit: cubit, scheduleModel: e)))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )))
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                            if (cubit.classId == null)
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("class")
                                      .snapshots(),
                                  builder: (c, snapshots) {
                                    return (snapshots.connectionState ==
                                        ConnectionState.waiting)
                                        ? Container()
                                        : ClassSearchListSchedule(
                                        snapshots: snapshots, scheduleCubit: cubit);
                                  })
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ],
        )),
      ),
    );
  }
}
