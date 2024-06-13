import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/features/master/teacher_survey_answer/detail_answer_teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/master/teacher_survey_answer/teacher_survey_answer_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class DetailAnswerTeacherSurveyScreen extends StatelessWidget {
  const DetailAnswerTeacherSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailAnswerTeacherSurveyCubit()..load(int.parse(TextUtils.getName(position: 1)),int.parse(TextUtils.getName(position: 2)),int.parse(TextUtils.getName())),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppbar( s: 2),
                Expanded(
                    child: BlocBuilder<DetailAnswerTeacherSurveyCubit, int>(
                        builder: (c, s) {
                          var cubit = BlocProvider.of<DetailAnswerTeacherSurveyCubit>(c);
                          return cubit.surveyAnswer == null
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
                                  flex: 1,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: Resizable.padding(context, 10)),
                                      child: Row(
                                    children: [
                                      Text('${AppText.txtTeacher.text}: ',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                              Resizable.font(context, 25))),
                                      SizedBox(width: Resizable.padding(context, 10)),
                                      IgnorePointer(
                                          ignoring: true,
                                          child: SmallAvatar(cubit.teacher == null ? "" :cubit.teacher!.url)),
                                      SizedBox(width: Resizable.padding(context, 10)),
                                      Text('${cubit.teacher!.name} - ${cubit.teacher!.teacherCode}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                              Resizable.font(context, 22)))
                                    ],
                                  ))),
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
                                      TeacherSurveyAnswerView(cubit: cubit)))
                            ],
                          );
                        }))
              ],
            )));
  }
}
