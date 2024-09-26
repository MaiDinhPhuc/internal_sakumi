import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/manage_browse_download_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_class/create_pdf_file_dialog.dart';
import 'package:internal_sakumi/features/class_info/lesson/add_custom_lesson_dialog.dart';
import 'package:internal_sakumi/features/class_info/lesson/list_lesson_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/lesson/list_lesson_items_v2.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/browse_download/manage_browse_download_in_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/teacher/browse_download/request_browse_download_dialog.dart';

class ListLessonScreenV2 extends StatelessWidget {
  ListLessonScreenV2({super.key, required this.role})
      : cubit = ListLessonCubitV2(int.parse(TextUtils.getName()));
  final String role;
  final ListLessonCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(18, (index) => index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderTeacher(
              index: 1, classId: cubit.classId.toString(), role: role),
          BlocBuilder<ListLessonCubitV2, int>(
              bloc: cubit,
              builder: (c, s) {
                return cubit.classModel == null
                    ? Expanded(
                        child: Center(
                            child: Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )))
                    : Expanded(
                        key: const Key('aa'),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 70)),
                            child: Column(
                              children: [
                                role == "admin"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: Resizable.padding(
                                                      context, 20)),
                                              child: Text(
                                                  '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: Resizable.font(
                                                          context, 30))),
                                            ),
                                            Row(
                                              children: [
                                                AddButton(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CreatePdfFileDialog(
                                                                classModel: cubit
                                                                    .classModel!));
                                                  },
                                                  title: AppText
                                                      .txtCreatePDFFile.text,
                                                ),
                                                SizedBox(
                                                    width: Resizable.padding(
                                                        context, 5)),
                                                BlocProvider(
                                                    create: (context) =>
                                                        ManageBrowseDownloadInClassCubit(),
                                                    child: BlocBuilder<
                                                        ManageBrowseDownloadInClassCubit,
                                                        int>(builder: (c, state) {
                                                      var manageCubit =
                                                          BlocProvider.of<
                                                              ManageBrowseDownloadInClassCubit>(c);
                                                      return AddButton(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  ManageBrowseDownloadInClassDialog(
                                                                      cubit:
                                                                          manageCubit));
                                                        },
                                                        title: AppText
                                                            .txtData.text,
                                                      );
                                                    })),
                                                SizedBox(
                                                    width: Resizable.padding(
                                                        context, 5)),
                                                AddButton(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AddCustomLessonDialog(
                                                                cubit,
                                                                classModel: cubit
                                                                    .classModel!));
                                                  },
                                                  title: AppText
                                                      .btnAddNewLesson.text,
                                                )
                                              ],
                                            )
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: Resizable.padding(
                                                      context, 20)),
                                              child: Text(
                                                  '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: Resizable.font(
                                                          context, 30))),
                                            ),
                                            if (cubit.courseModel != null &&
                                                cubit.courseModel!.dataToken !=
                                                    "_")
                                              AddButton(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          RequestBrowseDownloadDialog(
                                                              listLessons: cubit
                                                                  .lessons!,
                                                              classModel: cubit
                                                                  .classModel!));
                                                },
                                                title: AppText.txtData.text,
                                              )
                                          ]),
                                Container(
                                    padding: EdgeInsets.only(
                                        bottom: Resizable.padding(context, 10),
                                        right: Resizable.padding(context, 20),
                                        left: Resizable.padding(context, 15)),
                                    child: LessonItemRowLayout(
                                        lesson: Text(AppText.subjectLesson.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff757575),
                                                fontSize: Resizable.font(
                                                    context, 17))),
                                        name: Padding(
                                            padding: EdgeInsets.only(
                                                left: Resizable.padding(
                                                    context, 20)),
                                            child: Text(
                                                AppText.titleSubject.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(context, 17)))),
                                        sensei: Text(AppText.txtSensei.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                        attend: Text(AppText.txtRateOfAttendance.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                        submit: Text(AppText.txtRateOfSubmitHomework.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                        mark: Text(AppText.titleStatus.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                        dropdown: Container())),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: cubit.lessons == null
                                            ? Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Column(
                                                  children: [
                                                    ...shimmerList.map((e) =>
                                                        const ItemShimmer())
                                                  ],
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  ...cubit.lessons!
                                                      .map((e) => LessonItemV2(
                                                          cubit: cubit,
                                                          role: role,
                                                          lesson: e))
                                                      .toList()
                                                ],
                                              )))
                              ],
                            )));
              }),
          if (role == 'teacher') FooterView()
        ],
      ),
    );
  }
}
