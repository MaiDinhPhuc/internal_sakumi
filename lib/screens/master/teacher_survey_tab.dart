import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/alert_add_teacher_survey.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/alert_assign_teacher_survey.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/change_tab_cubit.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/manage_assign_teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/manage_teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/master/manage_teacher_survey/teacher_survey_edit_tab_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class ManageTeacherSurveyTab extends StatelessWidget {
  ManageTeacherSurveyTab({super.key})
      : changeTabCubit = ChangeTabManageTeacherSurveyCubit();

  final ChangeTabManageTeacherSurveyCubit changeTabCubit;

  @override
  Widget build(BuildContext context) {
    var surveyController = BlocProvider.of<ManageTeacherSurveyCubit>(context);
    var teacherSurveyController = BlocProvider.of<ManageAssignTeacherSurveyCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtStudentSurvey.text,
            AppText.txtTeacherSurvey.text,
            AppText.titleManageFeedBack.text
          ], s: 2),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AddButton(
                        onTap: () {
                          alertAssignTeacherSurvey(context, teacherSurveyController);
                        },
                        title: AppText.txtAssignSurvey.text.toUpperCase(),
                      ),
                      SizedBox(width: Resizable.padding(context, 10)),
                      AddButton(
                        onTap: () {
                          alertAddNewTeacherSurvey(context, surveyController);
                        },
                        title: AppText.btnAddNewSurvey.text.toUpperCase(),
                      )
                    ],
                  )
                ],
              )),
          BlocBuilder<ChangeTabManageTeacherSurveyCubit, bool>(
              bloc: changeTabCubit,
              builder: (c, s) {
                return Container(
                    margin: EdgeInsets.only(
                        left: Resizable.padding(context, 50),
                        right: Resizable.padding(context, 50),
                        bottom: Resizable.padding(context, 10)),
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 30),
                        vertical: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Resizable.size(context, 300),
                          height: Resizable.size(context, 40),
                          decoration: BoxDecoration(
                              color: greyColor.shade100,
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 10))),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        changeTabCubit.change();
                                      },
                                      child: Container(
                                          height: Resizable.size(context, 40),
                                          decoration: s
                                              ? ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF757575)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  shadows: const [
                                                    BoxShadow(
                                                      color: Color(0x3F000000),
                                                      blurRadius: 2,
                                                      offset: Offset(0, 2),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                )
                                              : null,
                                          child: Center(
                                              child: Text(AppText.txtEdit.text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: s
                                                        ? Colors.black
                                                        : greyColor.shade600,
                                                    fontSize: Resizable.font(
                                                        context, 18),
                                                    fontWeight: FontWeight.w700,
                                                  )))))),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        changeTabCubit.change();
                                      },
                                      child: Container(
                                          height: Resizable.size(context, 40),
                                          decoration: !s
                                              ? ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF757575)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  shadows: const [
                                                    BoxShadow(
                                                      color: Color(0x3F000000),
                                                      blurRadius: 2,
                                                      offset: Offset(0, 2),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                )
                                              : null,
                                          child: Center(
                                              child: Text(
                                                  AppText.txtAssign.text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: !s
                                                        ? Colors.black
                                                        : greyColor.shade600,
                                                    fontSize: Resizable.font(
                                                        context, 18),
                                                    fontWeight: FontWeight.w700,
                                                  )))))),
                            ],
                          ),
                        ),
                      ],
                    ));
              }),
          Expanded(
              child: BlocBuilder<ChangeTabManageTeacherSurveyCubit, bool>(
                  bloc: changeTabCubit,
                  builder: (c, s) {
                    return s
                        ? TeacherSurveyEditTabView(
                            surveyController: surveyController)
                        : Text("edit");
                  }))
        ],
      ),
    );
  }
}
