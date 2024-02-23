import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_course/filter_course_state.dart';
import 'package:internal_sakumi/features/master/manage_course/manage_course_cubit.dart';
import 'package:internal_sakumi/features/master/manage_course/manage_list_course.dart';
import 'package:internal_sakumi/features/master/manage_course/manage_list_lesson.dart';
import 'package:internal_sakumi/features/master/manage_course/manage_list_test.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

class ManageCourseTab extends StatelessWidget {
  const ManageCourseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageCourseCubit()..loadAllCourse(),
      child: Scaffold(
          body: Column(
        children: [
          CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtSurvey.text,
            AppText.titleManageFeedBack.text
          ], s: 0),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 50)),
            child: BlocBuilder<ManageCourseCubit, int>(
              builder: (c, s) {
                var cubit = BlocProvider.of<ManageCourseCubit>(c);
                if (cubit.listAllCourse == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10)),
                        child: FilterCourseState(cubit)),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Resizable.padding(context, 20)),
                              child: cubit.listCourseNow == null
                                  ? Transform.scale(
                                      scale: 0.75,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : ManageListCourse(cubit),
                            )),
                        Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: TitleWidget(AppText
                                            .txtListLesson.text
                                            .toUpperCase()),
                                      )),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: TitleWidget(AppText
                                            .txtListTest.text
                                            .toUpperCase()),
                                      )),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(
                                        Resizable.padding(context, 10)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffEEEEEE),
                                        borderRadius: BorderRadius.circular(
                                            Resizable.padding(context, 5))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ManageListLesson(cubit),
                                        SizedBox(
                                            width:
                                                Resizable.padding(context, 10)),
                                        ManageListTest(cubit)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ))
                  ],
                );
              },
            ),
          ))
        ],
      )),
    );
  }
}
