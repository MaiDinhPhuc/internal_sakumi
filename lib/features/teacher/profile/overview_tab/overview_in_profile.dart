import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/check_procedure_dialog.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/create_custom_procedure_dialog.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:shimmer/shimmer.dart';

import 'overview_tab_cubit.dart';

class OverViewTabInProfile extends StatelessWidget {
  OverViewTabInProfile({super.key, required this.role})
      : overViewCubit = OverViewTabCubit(role);

  final OverViewTabCubit overViewCubit;
  final String role;

  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return BlocBuilder<OverViewTabCubit, int>(
        bloc: overViewCubit,
        builder: (c, s) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: Resizable.size(context, 150),
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10),
                        vertical: Resizable.padding(context, 5)),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: greyColor.shade600),
                        borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 5))),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.titleOverView.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: Resizable.font(context, 26))),
                        const Divider(thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: Resizable.size(context, 80),
                                  child: CircleProgress(
                                    title: overViewCubit.levelUpPercent == null
                                        ? '0%'
                                        : '${overViewCubit.levelUpPercent!.toStringAsFixed(0)}%',
                                    lineWidth: Resizable.size(context, 5),
                                    percent: overViewCubit.levelUpPercent == null
                                        ? 0
                                        : overViewCubit.levelUpPercent! / 100,
                                    radius: Resizable.size(context, 30),
                                    fontSize: Resizable.font(context, 20),
                                  ),
                                ),
                                Text(AppText.txtUpPercent.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: Resizable.font(context, 24)))
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                    height: Resizable.size(context, 80),
                                    child: CircleProgress(
                                      title: overViewCubit.attendancePercent == null
                                          ? '0%'
                                          : '${(overViewCubit.attendancePercent! * 100).toStringAsFixed(0)}%',
                                      lineWidth: Resizable.size(context, 5),
                                      percent: overViewCubit.attendancePercent == null
                                          ? 0
                                          : overViewCubit.attendancePercent!,
                                      radius: Resizable.size(context, 30),
                                      fontSize: Resizable.font(context, 20),
                                    )),
                                Text(AppText.txtRateOfAttendance.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: Resizable.font(context, 24)))
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                    height: Resizable.size(context, 80),
                                    child: CircleProgress(
                                      title: overViewCubit.hwPercent == null
                                          ? '0%'
                                          : '${(overViewCubit.hwPercent! * 100).toStringAsFixed(0)}%',
                                      lineWidth: Resizable.size(context, 5),
                                      percent: overViewCubit.hwPercent == null
                                          ? 0
                                          : overViewCubit.hwPercent!,
                                      radius: Resizable.size(context, 30),
                                      fontSize: Resizable.font(context, 20),
                                    )),
                                Text(AppText.txtRateOfSubmitHomework.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: Resizable.font(context, 24)))
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                if(overViewCubit.userId != null)
                 BlocProvider(
                  create: (context) =>
                  ProcedureClassCubit(overViewCubit.userId!)
                    ..init(),
                  child:BlocBuilder<ProcedureClassCubit, int>(
                      builder: (c, _) {
                        var cubit = BlocProvider.of<ProcedureClassCubit>(c);
                        return SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: Resizable.padding(context, 15)),
                                      child: Text(AppText.txtProcedure.text.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: Resizable.font(context, 30))),
                                    ),
                                    if(role == "admin")
                                      Row(
                                        children: [
                                          AddButton(
                                            onTap: () {
                                              selectionDialog(
                                                  context,
                                                  "Chọn từ list",
                                                  "Tạo custom", () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        CheckProcedureDialog(
                                                          type: 'checklist',
                                                          procedureClassCubit:
                                                          cubit,
                                                        ));
                                              }, () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        CreateCustomProcedureDialog(
                                                          procedureClassCubit:
                                                          cubit, type: 'checklist',
                                                        ));
                                              });
                                            },
                                            title: "+ Checklist",
                                          ),
                                          SizedBox(
                                              width: Resizable.padding(
                                                  context, 5)),
                                          AddButton(
                                            onTap: () {
                                              selectionDialog(
                                                  context,
                                                  "Chọn từ list",
                                                  "Tạo custom", () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        CheckProcedureDialog(
                                                          type: 'meeting',
                                                          procedureClassCubit:
                                                          cubit,
                                                        ));
                                              }, () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        CreateCustomProcedureDialog(
                                                          procedureClassCubit:
                                                          cubit, type: 'meeting',
                                                        ));
                                              });
                                            },
                                            title: "+ Meeting",
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                                Column(
                                  children: [
                                    cubit.listProcedureClass == null
                                        ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: Resizable.padding(
                                                  context, 5)),
                                          child: Column(
                                            children: [
                                              ...shimmerList.map(
                                                      (e) => const ItemShimmer())
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                        : SingleChildScrollView(
                                        child: Column(
                                            children: [
                                              ...cubit.getProcedureClass().map(
                                                      (e) => ProcedureClassItem(
                                                      procedureClassModel: e,
                                                      cubit: cubit, role: role, type: e.type)),
                                              SizedBox(
                                                  height: Resizable.size(
                                                      context, 20))
                                            ]))
                                  ],
                                )
                              ],
                            ));
                      }) ,
                )
              ],
            ),
          );
        });
  }
}
