import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/feedback_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/feedback_navigation_item.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/list_feedback_view.dart';
import 'package:internal_sakumi/model/navigation/feedback_navigation.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

class ManageFeedBacksScreen extends StatelessWidget {
  ManageFeedBacksScreen({super.key})
      : cubit = FeedBackCubit();
  final FeedBackCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 4),
          Expanded(
              child: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 80)),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 20)),
                      child: Text(
                          AppText.titleFeedBackFromStd.text.toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 30))),
                    ),
                    Expanded(
                        child: BlocBuilder<FeedBackCubit, int>(
                      bloc: cubit,
                      builder: (c, s) {
                        return cubit.listFeedBack == null
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
                                                      number:
                                                          cubit.getCount(
                                                              e.type),
                                                      navigation: e,
                                                      type: cubit.type,
                                                      onTap: () {
                                                        cubit.changeType(e.type);
                                                      },
                                                    ))
                                              ],
                                            ),
                                          ))
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: ListFeedBackView(
                                          cubit: cubit))
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
  FeedBackNavigationModel(0, AppText.titleGeneralFeedBack.text, "general"),
  FeedBackNavigationModel(
      1, AppText.titleCurriculumFeedBack.text, "curriculum"),
  FeedBackNavigationModel(2, AppText.titleLecturersFeedBack.text, "lecturers"),
  FeedBackNavigationModel(
      3, AppText.titleStudentSupportFeedBack.text, "studentSupport"),
  FeedBackNavigationModel(4, AppText.titleRouteFeedBack.text, "route"),
  FeedBackNavigationModel(5, AppText.titleHomeworkFeedBack.text, "homework"),
  FeedBackNavigationModel(6, AppText.titleTestFeedBack.text, "test"),
  FeedBackNavigationModel(7, AppText.titleTuitionFeedBack.text, "tuition"),
];
