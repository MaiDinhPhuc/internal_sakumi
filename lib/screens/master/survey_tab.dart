import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/master/manage_survey/alert_add_new_survey.dart';
import 'package:internal_sakumi/features/master/manage_survey/manage_survey_cubit.dart';
import 'package:internal_sakumi/features/master/manage_survey/survey_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';
import 'package:shimmer/shimmer.dart';

class SurveyTab extends StatelessWidget {
  const SurveyTab({super.key});

  @override
  Widget build(BuildContext context) {
    var surveyController = BlocProvider.of<ManageSurveyCubit>(context)
      ..loadSurvey();
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtSurvey.text,
          ], s: 1),
          Container(
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),
            child: Text(AppText.titleSurveyList.text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 30))),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 100)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SurveyLayout(
                          surveyCode: Text(AppText.txtSurveyCode.text,
                              style: TextStyle(
                                  color: const Color(0xff757575),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17))),
                          title: Text(AppText.txtTitle.text,
                              style: TextStyle(
                                  color: const Color(0xff757575),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17))),
                          number: Text(AppText.textNumberResultReceive.text,
                              style: TextStyle(
                                  color: const Color(0xff757575),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17))),
                          date: Container(),
                          moreButton: Container(),
                        ),
                        BlocBuilder<ManageSurveyCubit, int>(
                            builder: (c, s) =>
                                surveyController.listSurvey == null
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ...shimmerList.map(
                                                  (e) => const ItemShimmer())
                                            ],
                                          ),
                                        ),
                                      )
                                    : surveyController.listSurvey!.isNotEmpty
                                        ? Column(children: [
                                            ...surveyController.listSurvey!
                                                .map((e) => Container())
                                                .toList(),
                                          ])
                                        : Container()),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.size(context, 20)),
                            child: DottedBorderButton(
                                AppText.btnAddNewSurvey.text.toUpperCase(),
                                isManageGeneral: true,
                                onPressed: () {
                                  alertAddNewSurvey(context,surveyController);
                                }))
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
