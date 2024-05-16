import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_cubit_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_item_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/filter_class_status_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/filter_class_type_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/filter_course_level_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/filter_course_type_v2.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:shimmer/shimmer.dart';

class ManageClassScreenV2 extends StatelessWidget {
  ManageClassScreenV2({super.key}) : cubit = ClassCubit();

  final ClassCubit cubit;

  @override
  Widget build(BuildContext context) {
    var filterController = BlocProvider.of<AdminClassFilterCubit>(context);
    final shimmerList = List.generate(5, (index) => index);
    if (filterController.filter.keys.isNotEmpty) {
      cubit.loadDataAdmin(filterController);
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        const AdminAppBar(index: 1),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child:Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 70)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(AppText.titleListClass.text.toUpperCase(),
                            style: TextStyle(
                              fontSize: Resizable.font(context, 30),
                              fontWeight: FontWeight.w800,
                            )),
                      ),
                      AddButton(
                        onTap: ()async {
                          Navigator.pushNamed(
                              context, '${Routes.admin}/${Routes.manageGeneral}');


                        }, title: AppText.btnManageClass.text,
                      )
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.size(context, 70)),
                    padding: EdgeInsets.symmetric(
                        //horizontal: Resizable.padding(context, 30),
                        vertical: Resizable.padding(context, 15)),
                    decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                    child: BlocListener<AdminClassFilterCubit, int>(
                        listener: (context, _) {
                          cubit.loadDataAdmin(filterController);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilterStatusAdminV2(filterController,
                                classCubit: cubit),
                            FilterCourseTypeAdminV2(filterController,
                                classCubit: cubit),
                            FilterCourseLevelAdminV2(filterController,
                                classCubit: cubit),
                            FilterTypeAdminV2(filterController,
                                classCubit: cubit)
                          ],
                        )))),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 70)),
                child: ClassItemRowLayout(
                  widgetClassCode: Text(AppText.txtClassCode.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetCourse: Text(AppText.txtCourse.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetLessons: Text(AppText.txtNumberOfLessons.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetAttendance: Text(AppText.txtRateOfAttendance.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetSubmit: Text(AppText.txtRateOfSubmitHomework.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetEvaluate: Text(AppText.txtEvaluate.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                  widgetStatus: Text(AppText.titleStatus.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 17),
                          color: greyColor.shade600)),
                )),
            Expanded(
              flex: 6,
              child: BlocBuilder<ClassCubit, int>(
                bloc: cubit,
                builder: (context, _) {
                  if (cubit.listClass == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...shimmerList.map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.size(context, 70)),
                                child: const ItemShimmer()))
                          ],
                        ),
                      ),
                    );
                  } else if (cubit.listClass!.isEmpty) {
                    return Text(AppText.txtNoClass.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600));
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cubit.listClass!.length,
                            itemBuilder: (context, index) {
                              var e = cubit.listClass![index];
                              return Padding(
                                key: Key(e.classId.toString()),
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.size(context, 70)),
                                child: ClassItemV2(
                                    classModel: e, classCubit: cubit),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: Resizable.size(context, 5)),
                        cubit.isLastPage
                            ? Container()
                            : SubmitButton(
                            onPressed: () {
                              cubit.loadMore(filterController);
                            },
                            title: AppText.txtLoadMore.text),
                        SizedBox(height: Resizable.size(context, 5)),
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ))
      ],
    ));
  }
}
