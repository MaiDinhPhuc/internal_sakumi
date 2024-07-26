import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/alert_add_new_student_survey.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/manage_student_survey_cubit.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/survey_item.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/survey_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';
import 'package:shimmer/shimmer.dart';

class ManageStudentSurveyTab extends StatelessWidget {
  const ManageStudentSurveyTab({super.key});

  @override
  Widget build(BuildContext context) {
    var surveyController = BlocProvider.of<ManageStudentSurveyCubit>(context)
      ..loadSurvey();
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const MasterAppbar( s: 1),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 20)),
                    child: Text(AppText.titleSurveyList.text.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: Resizable.font(context, 30))),
                  ),
                  SizedBox(width: Resizable.padding(context, 10)),
                  AddButton(
                    onTap: () {
                      alertAddNewStudentSurvey(context, surveyController);
                    },
                    title: AppText.btnAddNewSurvey.text.toUpperCase(),
                  )
                ],
              )),
          Padding(padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 50), vertical: Resizable.padding(context, 5)),child: SurveyLayout(
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
            number: Container(),
            date: Container(),
            moreButton: Container(),
          )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 50)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BlocBuilder<ManageStudentSurveyCubit, int>(
                            builder: (c, s) => surveyController.listSurvey ==
                                    null
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: Resizable.padding(context, 10)),
                                    child: Shimmer.fromColors(
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
                                    ))
                                : surveyController.listSurvey!.isNotEmpty
                                    ? Column(children: [
                                        ...surveyController.listSurvey!
                                            .map((e) => StudentSurveyItem(
                                                surveyModel: e,
                                                cubit: surveyController))
                                            .toList(),
                                      ])
                                    : Container()),
                        SizedBox(height: Resizable.padding(context, 15)),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
