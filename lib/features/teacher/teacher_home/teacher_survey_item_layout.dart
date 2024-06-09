import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';

class TeacherSurveyItemLayout extends StatelessWidget {
  const TeacherSurveyItemLayout(
      {super.key,
      required this.widgetTitle,
      required this.widgetSurveyCode,
      required this.widgetButton,
      required this.widgetDateAssign});
  final Widget widgetTitle, widgetSurveyCode, widgetButton, widgetDateAssign;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: widgetSurveyCode,
            )),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.centerLeft, child: widgetTitle)),
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center, child: widgetDateAssign)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: widgetButton))
      ],
    );
  }
}

class TeacherSurveyItem extends StatelessWidget {
  const TeacherSurveyItem({super.key, required this.model});

  final TeacherSurveyModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: Resizable.padding(context, 5),bottom: Resizable.padding(context, 5),
            left: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 10),
            vertical: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            border: Border.all(
                width: Resizable.size(context, 1), color: greyColor.shade100),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: TeacherSurveyItemLayout(
          widgetTitle: Text(
            model.title,
            style: TextStyle(
                fontSize: Resizable.size(context, 14),
                fontWeight: FontWeight.w700),
          ),
          widgetSurveyCode: Text(
            model.surveyCode,
            style: TextStyle(
                fontSize: Resizable.size(context, 14),
                fontWeight: FontWeight.w700),
          ),
          widgetButton: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, '${Routes.teacher}/survey=${model.id}');
            },
            style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.padding(context, 3)))),
                backgroundColor: MaterialStateProperty.all(primaryColor),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 10)))),
            child: Text('Làm khảo sát',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Resizable.font(context, 16),
                    color: Colors.white)),
          ),
          widgetDateAssign: Text(
            DateFormat('dd/MM/yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(model.dateAssign)),
            style: TextStyle(
                fontSize: Resizable.size(context, 14),
                fontWeight: FontWeight.w700),
          ),
        ));
  }
}
