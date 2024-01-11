import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_survey/survey_layout.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'confirm_delete_survey.dart';
import 'manage_survey_cubit.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({super.key, required this.surveyModel, required this.cubit});
  final SurveyModel surveyModel;
  final ManageSurveyCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: Resizable.padding(context, 10)),
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border.all(
                width: Resizable.size(context, 1), color: greyColor.shade100),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: SurveyLayout(
          surveyCode: Text(surveyModel.surveyCode,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17))),
          title: Text(surveyModel.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17))),
          number: Container(),
          date: Container(),
          moreButton: SizedBox(
            height: Resizable.size(context, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  splashRadius: Resizable.size(context, 15),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black, // Set the desired border color here
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Resizable.size(context, 5)),
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context,
                            '${Routes.master}/manageSurvey/id=${surveyModel.id}');
                        // Navigator.pushNamed(context,
                        //     '${Routes.master}/manageSurvey/id=${surveyModel.id}');
                      },
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Text(AppText.textDetail.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 20),
                                  color: Colors.black))),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        //Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => ConfirmDeleteSurvey(
                                  surveyModel: surveyModel,
                                  cubit: cubit,
                                ));
                        //waitingDialog(context);
                      },
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Text(AppText.txtDeleteSurvey.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 20),
                                  color: const Color(0xffB71C1C)))),
                    )
                  ],
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
        ));
  }
}
