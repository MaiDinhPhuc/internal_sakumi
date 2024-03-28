import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/sub_course/add_custom_lesson_sub_course.dart';
import 'package:internal_sakumi/features/teacher/sub_course/add_sub_course_dialog.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_item_layout.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_item_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:shimmer/shimmer.dart';

class SubCourseScreen extends StatelessWidget {
  SubCourseScreen({super.key, required this.role})
      : cubit = SubCourseCubit(int.parse(TextUtils.getName()));
  final String role;
  final SubCourseCubit cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 4, classId: TextUtils.getName(), role: role),
          BlocBuilder<SubCourseCubit, int>(
              bloc: cubit,
              builder: (c, _) {
                return cubit.classModel == null
                    ? Expanded(
                    child: Center(
                      child: Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      ),
                    )) : Expanded(
                    flex: 10,
                    child:  cubit.subClassId == 0 ?
                    Padding(padding:EdgeInsets.symmetric(horizontal: Resizable.padding(context, 70),vertical: Resizable.padding(context, 20)),
                        child: Column(
                      children: [
                        if (role == 'admin')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AddButton(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AddSubCourseDialog(cubit));
                                },
                                title: AppText.txtAddNewSubCourse.text,
                              )
                            ],
                          ),
                        Expanded(child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/ic_no_sub_course.png",scale: 10),
                              Text(
                                  AppText.txtNoSubCourse.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                      fontSize: Resizable.font(context, 36))),
                              if (role == 'teacher')
                                Text(
                                    AppText.titleNoSubCourse.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: Resizable.font(context, 20)))
                            ],
                          ),
                        ))
                      ],
                    )) : SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 100)),
                          child: Column(
                            children: [
                              if(role == "admin")
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: Resizable.padding(context, 10)),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SubmitButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AddCustomLessonSubCourseDialog(
                                                            cubit,
                                                            classModel: cubit
                                                                .subClassModel!));
                                              },
                                              title: AppText.btnAddNewLesson.text)
                                        ])),
                              Container(
                                  padding: EdgeInsets.only(
                                      top:Resizable.padding(context, 10),
                                      right: Resizable.padding(context, 15)),
                                  child: SubCourseItemLayout(
                                      dropdown: Container(),
                                      lesson: Text(AppText.subjectLesson.text,
                                          style: TextStyle(
                                              color: const Color(0xff757575),
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              Resizable.font(context, 17))),
                                      title: Text(AppText.titleSubject.text,
                                          style: TextStyle(
                                              color: const Color(0xff757575),
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              Resizable.font(context, 17))))),
                              cubit.loading == true
                                  ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...shimmerList
                                          .map((e) => const ItemShimmer())
                                    ],
                                  ),
                                ),
                              )
                                  : Column(
                                children: [
                                  ...cubit.lessons!
                                      .map((e) => SubCourseItemView(
                                      cubit: cubit,
                                      lesson: e, index: cubit.lessons!.indexOf(e), role: role))
                                      .toList(),
                                  SizedBox(
                                      height: Resizable.size(context, 50))
                                ],
                              )
                            ],
                          ),
                        ))
                );
              }),
          if (role == 'teacher') FooterView()
        ],
      ),
    );
  }
}
