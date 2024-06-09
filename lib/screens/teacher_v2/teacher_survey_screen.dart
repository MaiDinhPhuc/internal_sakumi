import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/doing_teacher_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/back_button.dart';

import '../../features/teacher/teacher_survey/doing_teacher_survey_view.dart';

class TeacherSurveyScreen extends StatelessWidget {
  const TeacherSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DoingTeacherSurveyCubit()..load(int.parse(TextUtils.getName())),
    child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Resizable.size(context, 20)),
              const CustomBackTeacherButton(),
              SizedBox(height: Resizable.size(context, 20)),
              Expanded(
                  child: BlocBuilder<DoingTeacherSurveyCubit, int>(
                      builder: (c, s) {
                        var cubit = BlocProvider.of<DoingTeacherSurveyCubit>(c);
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
                                    DoingTeacherSurveyView(cubit: cubit)))
                          ],
                        );
                      }))
            ],
          )
        )));
  }
}
