import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/doing_teacher_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/back_button.dart';

class TeacherSurveyScreen extends StatelessWidget {
  const TeacherSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DoingTeacherSurveyCubit(),
    child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
          child: BlocBuilder<DoingTeacherSurveyCubit, int>(builder: (c, s) {
            var cubit = BlocProvider.of<DoingTeacherSurveyCubit>(c);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Resizable.size(context, 20)),
                const CustomBackTeacherButton(),
                SizedBox(height: Resizable.size(context, 20)),

              ],
            );
          }),
        )));
  }
}
