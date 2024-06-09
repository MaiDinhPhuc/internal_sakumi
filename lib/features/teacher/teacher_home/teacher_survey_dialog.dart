import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_list_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

class TeacherSurveyDialog extends StatelessWidget {
  const TeacherSurveyDialog({super.key, required this.cubit});

  final TeacherSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        bottom: Resizable.padding(context, 20)),
                    child: Text(
                      AppText.txtSurvey.text.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: TeacherSurveyListView(cubit: cubit)),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: Resizable.padding(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                minWidth:
                                Resizable.size(context, 100)),
                            child: DialogButton(
                                AppText.textCancel.text.toUpperCase(),
                                onPressed: () =>
                                    Navigator.pop(context)),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}
