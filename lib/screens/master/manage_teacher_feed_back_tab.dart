import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/feedback_navigation_item.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/list_feedback_view.dart';
import 'package:internal_sakumi/features/master/manage_teacher_feedback/teacher_feedback_cubit.dart';
import 'package:internal_sakumi/model/navigation/feedback_navigation.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

class ManageTeacherFeedBackTab extends StatelessWidget {
  ManageTeacherFeedBackTab({super.key}) : teacherFeedBackCubit = TeacherFeedBackCubit();
  final TeacherFeedBackCubit teacherFeedBackCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtSurvey.text,
            AppText.titleManageFeedBack.text
          ], s: 2),
          Container(
            margin:
            EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),
            child: Text(AppText.titleFeedBackFromTeacher.text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 30))),
          ),
          Expanded(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 80)),
                    child: Column(
                      children: [
                        Expanded(
                            child: BlocBuilder<TeacherFeedBackCubit, int>(
                              bloc: teacherFeedBackCubit,
                              builder: (c, s) {
                                return teacherFeedBackCubit.listFeedBack == null
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                )
                                    : Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            TitleWidget(AppText
                                                .titleListFeedBack.text
                                                .toUpperCase()),
                                            Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ...listFeedBack.map((e) =>
                                                          FeedBackNavigationItem(
                                                            number: teacherFeedBackCubit.getCount(e.type),
                                                            navigation: e,
                                                            type: teacherFeedBackCubit.type,
                                                            onTap: () {
                                                              teacherFeedBackCubit.changeType(e.type);
                                                            },
                                                          ))
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: ListFeedBackViewV2(
                                            cubit: teacherFeedBackCubit))
                                  ],
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

List<FeedBackNavigationModel> listFeedBack = [
  FeedBackNavigationModel(0, AppText.titleCurriculumFeedBack.text, "curriculum_teacher"),
  FeedBackNavigationModel(
      1, AppText.txtCentreFeedBack.text, "centre_teacher"),
  FeedBackNavigationModel(2, AppText.txtTeachingFeedBack.text, "teaching_teacher"),
  FeedBackNavigationModel(
      3, AppText.txtSupportFeedBack.text, "support_teacher")
];