import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/detail_student_survey_cubit.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/detail_student_survey_view.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/manage_student_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class DetailStudentSurveyScreen extends StatelessWidget {
  DetailStudentSurveyScreen({super.key}) : cubit = DetailStudentSurveyCubit();

  final DetailStudentSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    var surveyController = BlocProvider.of<ManageStudentSurveyCubit>(context);
    return BlocBuilder<ManageStudentSurveyCubit, int>(builder: (cc, ss) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const MasterAppbar( s: 1),
            Expanded(
                child: BlocBuilder<DetailStudentSurveyCubit, int>(
                    bloc: cubit
                      ..loadSurvey(
                          int.parse(TextUtils.getName()), surveyController),
                    builder: (c, s) {
                      return cubit.surveyModel == null
                          ? Center(
                              child: Transform.scale(
                              scale: 0.75,
                              child: const CircularProgressIndicator(),
                            ))
                          : Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: Resizable.padding(context, 20)),
                                      child: Text(
                                          cubit.surveyModel!.title
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                                  Resizable.font(context, 30))),
                                    )),
                                if (cubit.surveyModel!.description != "")
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                          cubit.surveyModel!.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Resizable.font(
                                                  context, 22)))),
                                Expanded(
                                    flex: cubit.surveyModel!.description != ""
                                        ? 10
                                        : 7,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Resizable.padding(context, 5),
                                            right:
                                                Resizable.padding(context, 10),
                                            left:
                                                Resizable.padding(context, 10)),
                                        padding: EdgeInsets.all(
                                            Resizable.padding(context, 5)),
                                        decoration: BoxDecoration(
                                            color: lightGreyColor,
                                            borderRadius: BorderRadius.circular(
                                                Resizable.size(context, 5))),
                                        child: DetailStudentSurveyView(
                                            cubit: surveyController,
                                            detailSurveyCubit: cubit)))
                              ],
                            );
                    }))
          ],
        ),
      );
    });
  }
}
