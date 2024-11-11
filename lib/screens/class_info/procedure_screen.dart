import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/check_procedure_dialog.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/create_custom_procedure_dialog.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:shimmer/shimmer.dart';

class ClassProcedureScreen extends StatelessWidget {
  const ClassProcedureScreen({super.key, required this.role});
  final String role;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderTeacher(index: 6, classId: TextUtils.getName(), role: role),
          Expanded(
              flex: 10,
              child: BlocProvider(
                create: (context) =>
                    ProcedureClassCubit(int.parse(TextUtils.getName()))..init(),
                child: BlocBuilder<ProcedureClassCubit, int>(builder: (c, _) {
                  var cubit = BlocProvider.of<ProcedureClassCubit>(c);
                  return SingleChildScrollView(
                      child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 70)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 15)),
                              child: Text(
                                  AppText.txtProcedure.text.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 30))),
                            ),
                            if (role == "admin")
                              Row(
                                children: [
                                  AddButton(
                                    onTap: () {
                                      selectionDialog(
                                          context, "Chọn từ list", "Tạo custom",
                                          () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CheckProcedureDialog(
                                                  type: 'checklist',
                                                  procedureClassCubit: cubit,
                                                ));
                                      }, () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CreateCustomProcedureDialog(
                                                  procedureClassCubit: cubit,
                                                  type: 'checklist',
                                                ));
                                      });
                                    },
                                    title: "+ Checklist",
                                  ),
                                  SizedBox(
                                      width: Resizable.padding(context, 5)),
                                  AddButton(
                                    onTap: () {
                                      selectionDialog(
                                          context, "Chọn từ list", "Tạo custom",
                                          () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CheckProcedureDialog(
                                                  type: 'meeting',
                                                  procedureClassCubit: cubit,
                                                ));
                                      }, () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CreateCustomProcedureDialog(
                                                  procedureClassCubit: cubit,
                                                  type: 'meeting',
                                                ));
                                      });
                                    },
                                    title: "+ Meeting",
                                  ),
                                ],
                              )
                          ],
                        ),
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
                                        items: const ["Checklist", "Meeting"],
                                        onChanged: (item) async {
                                          cubit.filter(item!);
                                        },
                                        value: cubit.filterState))
                              ],
                            )),
                        Column(
                          children: [
                            cubit.listProcedureClass == null
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
                                : SingleChildScrollView(
                                    child: Column(
                                        key: Key(cubit.filterState),
                                        children: [
                                        ...cubit.getProcedureClass().map((e) =>
                                            ProcedureClassItem(
                                                procedureClassModel: e,
                                                cubit: cubit,
                                                role: role,
                                                type: e.type)),
                                        SizedBox(
                                            height: Resizable.size(context, 20))
                                      ]))
                          ],
                        )
                      ],
                    ),
                  ));
                }),
              )),
          if (role == 'teacher') FooterView()
        ],
      ),
    );
  }
}
