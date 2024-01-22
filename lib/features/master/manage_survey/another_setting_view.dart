import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_survey_cubit.dart';
import 'edit_survey_cubit.dart';

class AnotherSettingView extends StatelessWidget {
  const AnotherSettingView(
      {super.key,
      required this.detailSurveyCubit,
      required this.editSurveyCubit});
  final DetailSurveyCubit detailSurveyCubit;
  final EditSurveyCubit editSurveyCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppText.txtAnotherSetting.text,
            style: TextStyle(
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w600,
                color: primaryColor)),
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
            child: Row(
              children: [
                Container(
                  height: Resizable.size(context, 35),
                  width: Resizable.size(context, 120),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.5, color: const Color(0xffE0E0E0)),
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5)),
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(AppText.txtForce.text,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w600,
                            color: greyColor.shade600)),
                    value: detailSurveyCubit
                        .surveyModel!.detail[detailSurveyCubit.index]["force"],
                    onChanged: (newValue) {
                      if (!detailSurveyCubit.surveyModel!.active) {
                        editSurveyCubit.changeForce(newValue!);
                      }
                    },
                  ),
                ),
                if (detailSurveyCubit
                        .surveyModel!.detail[detailSurveyCubit.index]["type"] <
                    3)
                  Container(
                    margin:
                        EdgeInsets.only(left: Resizable.padding(context, 15)),
                    height: Resizable.size(context, 35),
                    width: Resizable.size(context, 135),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: const Color(0xffE0E0E0)),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(AppText.txtAnother.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 18),
                              fontWeight: FontWeight.w600,
                              color: greyColor.shade600)),
                      value: detailSurveyCubit.surveyModel!
                          .detail[detailSurveyCubit.index]["another"],
                      onChanged: (newValue) {
                        if (!detailSurveyCubit.surveyModel!.active) {
                          editSurveyCubit.changeAnother(newValue!);
                        }
                      },
                    ),
                  ),
                if (detailSurveyCubit.index != 0)
                  Container(
                    margin:
                        EdgeInsets.only(left: Resizable.padding(context, 15)),
                    height: Resizable.size(context, 35),
                    width: Resizable.size(context, 200),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: const Color(0xffE0E0E0)),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(AppText.txtOption.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 18),
                              fontWeight: FontWeight.w600,
                              color: greyColor.shade600)),
                      value: editSurveyCubit.option!,
                      onChanged: (newValue) {
                        if (!detailSurveyCubit.surveyModel!.active) {
                          editSurveyCubit.changeOption(newValue!);
                        }
                      },
                    ),
                  )
              ],
            )),
        if (editSurveyCubit.option!)
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 15),
                  vertical: Resizable.padding(context, 8)),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: greyColor.shade50),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 5,
                      child: Center(
                          child: InputDropdownV2(
                            key: Key(detailSurveyCubit
                                .surveyModel!.detail[detailSurveyCubit.index]["id"].toString()),
                        title: AppText.txtQuestion.text,
                        hint: AppText.txtChooseQuestion.text,
                        onChanged: detailSurveyCubit.surveyModel!
                                        .detail[detailSurveyCubit.index]
                                    ["option"][0]["id"] !=
                                -1
                            ? null
                            : (v) {
                                editSurveyCubit.chooseOption(v!);
                              },
                        items: List.generate(
                            editSurveyCubit.listQuestion.length,
                            (index) =>
                                (editSurveyCubit.listQuestion[index])).toList(),
                        disableHint: detailSurveyCubit
                                .surveyModel!.detail[detailSurveyCubit.index]
                            ["option"][0]["question"],
                      ))),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Resizable.padding(context, 10)),
                        child: Center(
                            child: InputDropdownV2(
                                key: Key(detailSurveyCubit
                                    .surveyModel!.detail[detailSurveyCubit.index]["id"].toString()),
                                title: AppText.txtAnswer.text,
                                hint: AppText.txtChooseAnswer.text,
                                onChanged: detailSurveyCubit
                                    .surveyModel!.detail[detailSurveyCubit.index]
                                ["option"][0]["answer"] != "empty"
                                    ? null
                                    : (v) {
                                  editSurveyCubit.chooseAnswer(v!);
                                },
                                items: editSurveyCubit.optionId == -1
                                    ? []
                                    : List.generate(
                                        editSurveyCubit.listAnswer.length,
                                        (index) => (editSurveyCubit
                                            .listAnswer[index])).toList(),
                            disableHint:  detailSurveyCubit
                                .surveyModel!.detail[detailSurveyCubit.index]
                            ["option"][0]["answer"])
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(Resizable.padding(context, 5)),
                        height: Resizable.size(context, 30),
                        width: Resizable.size(context, 30),
                        decoration: BoxDecoration(
                            color: greyColor.shade50,
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5))),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 100)),
                            onTap: () async {
                             await editSurveyCubit.changeOption(false);
                            },
                            child: Icon(Icons.delete,
                                color: greyColor.shade500,
                                size: Resizable.size(context, 20))),
                      )),
                ],
              ))
      ],
    );
  }
}
