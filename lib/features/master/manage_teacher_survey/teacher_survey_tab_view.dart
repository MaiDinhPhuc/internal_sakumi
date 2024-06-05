
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

import 'manage_assign_teacher_survey_cubit.dart';

class TeacherSurveyTabView extends StatelessWidget {
  const TeacherSurveyTabView({super.key, required this.surveyController});

  final ManageAssignTeacherSurveyCubit surveyController;

  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
        child: Column(
          children: [
            BlocBuilder<ManageAssignTeacherSurveyCubit, int>(
                bloc: surveyController..loadSurvey(),
                builder: (c, s) => surveyController.listTeacherSurvey == null
                    ? Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 10)),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...shimmerList.map((e) => const ItemShimmer())
                              ],
                            ))))
                    : surveyController.listTeacherSurvey!.isNotEmpty
                    ? Column(
                  children: [
                    SurveyLayout(
                      surveyCode: Text(AppText.txtSurveyCode.text,
                          style: TextStyle(
                              color: greyColor.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17))),
                      title: Text(AppText.txtTitle.text,
                          style: TextStyle(
                              color: greyColor.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17))),
                      number: Container(),
                      date: Container(),
                      moreButton: Container(),
                    ),
                    SingleChildScrollView(
                        child: Column(children: [
                          ...surveyController.listTeacherSurvey!
                              .map((e) => TeacherSurveyItem(
                              surveyModel: e,
                              cubit: surveyController))
                              .toList(),
                        ]))
                  ],
                )
                    : Container(
                  margin: EdgeInsets.only(
                      top: Resizable.padding(context, 150)),
                  child: Text(
                      AppText.txtTeacherSurveyEmpty.text
                          .toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                )),
            SizedBox(height: Resizable.padding(context, 15)),
          ],
        ));
  }
}