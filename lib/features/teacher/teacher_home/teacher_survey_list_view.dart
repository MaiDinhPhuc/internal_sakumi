import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_item_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherSurveyListView extends StatelessWidget {
  const TeacherSurveyListView({super.key, required this.cubit});
  final TeacherSurveyCubit cubit;
  @override
  Widget build(BuildContext context) {
    return cubit.listTeacherSurvey!.isEmpty
        ? const Center(child: Text("Chưa có bài khảo sát nào cho bạn!"))
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child: TeacherSurveyItemLayout(
                        widgetTitle: Text(
                          AppText.txtTitle.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17),
                              color: greyColor.shade600),
                        ),
                        widgetButton:Container(),
                        widgetSurveyCode: Text(
                          AppText.txtSurveyCode.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17),
                              color: greyColor.shade600),
                        ),
                        widgetDateAssign: Text(
                          AppText.txtDateAssignSurvey.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17),
                              color: greyColor.shade600),
                        ))),
                SizedBox(height: Resizable.size(context, 5)),
                ...cubit.listTeacherSurvey!
                    .map((e) => TeacherSurveyItem(model: e)),
              ],
            ),
          );
  }
}
