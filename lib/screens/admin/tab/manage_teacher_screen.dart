import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/filter_teacher_status.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/list_teacher_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_item.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_layout.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/manage_teacher/alert_add_new_teacher_account.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:shimmer/shimmer.dart';

class ManageTeacherScreen extends StatelessWidget {
  ManageTeacherScreen({super.key}) : cubit = ListTeacherCubit();
  final ListTeacherCubit cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 7),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 70)),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.titleManageTeacher.text.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: Resizable.font(context, 30))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AddButton(
                          onTap: () {
                            alertAddNewTeacherAccount(context);
                          },
                          title:
                          " + ${AppText.btnAddNewTeacher.text.replaceAll(" mới", "")}",
                        ),
                        SizedBox(width: Resizable.padding(context, 10)),
                        AddButton(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '${Routes.admin}/${Routes.manageSchedule}');
                          },
                          title: AppText.txtScheduleTeacher.text,
                        )
                      ],
                    )
                  ],
                )),
                Expanded(flex: 1, child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context,15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [FilterTeacherStatus(cubit: cubit)],
                  ),
                )),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical:
                        Resizable.padding(context, 10)),
                    child: TeacherItemLayout(
                      widgetTeacherCode: Text(
                          AppText.txtTeacherCode.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetName: Text(AppText.txtName.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetPhone: Text(AppText.txtPhone.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetRating: Text(AppText.txtRating.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetStatus: Text(
                          AppText.titleStatus.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetDropdown: Container(),
                    )),
                Expanded(
                    flex: 6,
                    child: BlocBuilder<ListTeacherCubit, int>(
                    bloc: cubit,
                    builder: (c, s) {
                      return cubit.listTeacher == null
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: Resizable.padding(context, 5)),
                            child: Column(
                              children: [
                                ...shimmerList.map((e) => const ItemShimmer())
                              ],
                            ),
                          ),
                        ),
                      )
                          : cubit.listTeacher!.isNotEmpty? SingleChildScrollView(child: Column(
                          children: [
                            ...cubit.listTeacher!.map((e) =>
                                TeacherItem(teacherModel: e)),
                            SizedBox(height: Resizable.size(context, 5)),
                            !cubit.canGetMore
                                ? Container()
                                : SubmitButton(
                                onPressed: () {
                                  cubit.getMore();
                                },
                                title: AppText.txtLoadMore.text),
                            SizedBox(
                                height: Resizable.padding(
                                    context, 50))
                          ]))
                              : Center(child: Text(AppText.txtNoTeacher.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                              Resizable.font(context, 17),
                              color: greyColor.shade600)));
                    }))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
