import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/checklist_item_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_group_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/manage_procedure_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/meeting_item_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_item.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

class ManageProcedureScreen extends StatelessWidget {
  ManageProcedureScreen({super.key}) : cubit = ManageProcedureCubit();
  final ManageProcedureCubit cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 10),
          Expanded(
              child: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 70)),
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
                        Row(
                          children: [
                            AddButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ProcedureGroupDialog();
                                    });
                              },
                              title: "Group",
                            ),
                            SizedBox(width: Resizable.padding(context, 10)),
                            AddButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ChecklistItemDialog();
                                    });
                              },
                              title: "Checklist Items",
                            ),
                            SizedBox(width: Resizable.padding(context, 10)),
                            AddButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return MeetingItemDialog();
                                    });
                              },
                              title: "Meeting Items",
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                        child: BlocBuilder<ManageProcedureCubit, int>(
                      bloc: cubit,
                      builder: (c, s) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(flex: 5, child: Container()),
                                      Expanded(
                                          flex: 1,
                                          child: DropDownGrading(
                                              items: const [
                                                "Checklist",
                                                "Meeting"
                                              ],
                                              onChanged: (item) async {
                                                cubit.filter(item!);
                                              },
                                              value: cubit.filterState))
                                    ],
                                  )),
                              cubit.listProcedure == null
                                  ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: Resizable.padding(context, 5)),
                                    child: Column(
                                      children: [
                                        ...shimmerList
                                            .map((e) => const ItemShimmer())
                                      ],
                                    ),
                                  ),
                                ),
                              )
                                  : cubit.getProcedure().isNotEmpty
                                  ? SingleChildScrollView(
                                  child: Column(children: [
                                    ...cubit.getProcedure().map((e) =>
                                        ProcedureItem(
                                            procedureModel: e,
                                            cubit: cubit)),
                                    DottedBorderButton(
                                        "+ Thêm quy trình".toUpperCase(),
                                        isManageGeneral: true,
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return ProcedureDialog(
                                                    cubit: cubit);
                                              });
                                        }),
                                    SizedBox(height: Resizable.size(context, 20))
                                  ]))
                                  : Center(
                                  child: DottedBorderButton(
                                      "+ Thêm quy trình".toUpperCase(),
                                      isManageGeneral: true,
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return ProcedureDialog(
                                                  cubit: cubit);
                                            });
                                      }))
                            ],
                          ),
                        );
                      },
                    ))
                  ],
                )),
          ))
        ],
      ),
    );
  }
}
