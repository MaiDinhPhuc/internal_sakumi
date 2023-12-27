import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_survey/alert_checkbox_survey.dart';
import 'package:internal_sakumi/features/admin/manage_survey/manage_survey_admin_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_survey/survey_item_admin.dart';
import 'package:internal_sakumi/features/master/manage_survey/survey_layout.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class ManageSurveyTab extends StatelessWidget {
  ManageSurveyTab({super.key}) : cubit = ManageSurveyAdminCubit();
  final ManageSurveyAdminCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 3, classId: TextUtils.getName(), role: "admin"),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 20)),
                  child: Text(AppText.titleSurveyList.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: Resizable.font(context, 30))),
                ),
                BlocBuilder<ManageSurveyAdminCubit, int>(
                    bloc: cubit..loadSurvey(),
                    builder: (c, s) {
                      return cubit.surveyResults == null
                          ? Transform.scale(
                              scale: 0.75,
                              child: const CircularProgressIndicator(),
                            )
                          : cubit.surveyResults!.isEmpty
                              ? Column(children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Resizable.padding(context, 30)),
                                      child: Text(
                                          AppText.txtSurveyResultEmpty.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Resizable.font(
                                                  context, 25)))),
                                  SubmitButton(
                                      onPressed: () {
                                        alertCheckBoxSurvey(c, cubit,
                                            int.parse(TextUtils.getName()));
                                      },
                                      title: AppText.btnAddNewSurvey.text)
                                ])
                              : Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),child: Column(
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
                            number: Text(AppText.textNumberResultReceive.text,
                                style: TextStyle(
                                    color: greyColor.shade600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17))),
                            date: Text(AppText.txtDateAssignSurvey.text,
                                style: TextStyle(
                                    color: greyColor.shade600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17))),
                            moreButton: Container(),
                          ),
                          ...cubit.surveyResults!.map((e) => SurveyItemAdmin(result: e, cubit: cubit)).toList(),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 20)),
                              child: DottedBorderButton(
                                  AppText.btnAddNewSurvey.text.toUpperCase(),
                                  isManageGeneral: true, onPressed: () {
                                alertCheckBoxSurvey(c, cubit,
                                    int.parse(TextUtils.getName()));
                              }))
                        ],
                      ));
                    })
              ],
            ),
          ))
        ],
      ),
    );
  }
}
