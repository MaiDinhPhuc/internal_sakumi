import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_survey/detail_survey_admin_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_survey/detail_survey_admin_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailSurveyAdminScreen extends StatelessWidget {
  DetailSurveyAdminScreen({super.key}) : cubit = DetailSurveyAdminCubit();

  final DetailSurveyAdminCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
              index: 3, classId: TextUtils.getName(position: 1), role: "admin"),
          Expanded(
              child: BlocBuilder<DetailSurveyAdminCubit, int>(
                  bloc: cubit..load(int.parse(TextUtils.getName()),int.parse(TextUtils.getName(position: 1))),
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
                                        cubit.surveyModel!.title.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize:
                                                Resizable.font(context, 30))),
                                  )),
                              if (cubit.surveyModel!.description != "")
                                Expanded(
                                    flex: 1,
                                    child: Text(cubit.surveyModel!.description,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 22)))),
                              Expanded(
                                  flex: cubit.surveyModel!.description != ""
                                      ? 10
                                      : 7,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: Resizable.padding(context, 5),
                                          right: Resizable.padding(context, 10),
                                          left: Resizable.padding(context, 10)),
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 5)),
                                      decoration: BoxDecoration(
                                          color: lightGreyColor,
                                          borderRadius: BorderRadius.circular(
                                              Resizable.size(context, 5))),
                                      child:
                                          DetailSurveyAdminView(cubit: cubit)))
                            ],
                          );
                  }))
        ],
      ),
    );
  }
}
