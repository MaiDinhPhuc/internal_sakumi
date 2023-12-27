import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/admin/manage_survey/alert_add_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'manage_survey_admin_cubit.dart';

void alertCheckBoxSurvey(BuildContext context,
    ManageSurveyAdminCubit manageSurveyAdminCubit, int classId) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAddSurveyCubit()
              ..loadSurvey(manageSurveyAdminCubit.surveyResults!),
            child: BlocBuilder<AlertAddSurveyCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertAddSurveyCubit>(c);
                return cubit.listSurvey == null
                    ? const WaitingAlert()
                    : Dialog(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 20),
                                        vertical:
                                            Resizable.padding(context, 10)),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      AppText.txtAddNewSurvey.text
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              Resizable.font(context, 20)),
                                    ),
                                  ),
                                  Expanded(
                                      child: cubit.listSurvey!.isEmpty
                                          ? Center(
                                              child: Text(
                                                  AppText.txtSurveyEmpty.text))
                                          : SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 0)),
                                                child: Column(
                                                  children: [
                                                    ...List.generate(
                                                        cubit
                                                            .listSurvey!.length,
                                                        (index) => BlocProvider(
                                                            key: Key(
                                                                "${cubit.listSurvey![index].id}"),
                                                            create: (c) =>
                                                                CheckBoxCubit()
                                                                  ..load(false),
                                                            child: BlocBuilder<
                                                                CheckBoxCubit,
                                                                bool?>(
                                                              builder: (cc,
                                                                      state) =>
                                                                  CheckboxListTile(
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: Resizable.padding(
                                                                              context,
                                                                              30)),
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading,
                                                                      value: state ??
                                                                          false,
                                                                      onChanged:
                                                                          (v) {
                                                                        if (v! ==
                                                                            true) {
                                                                          cubit
                                                                              .listSurveyCheck
                                                                              .add(cubit.listSurvey![index]);
                                                                        } else {
                                                                          cubit
                                                                              .listSurveyCheck
                                                                              .remove(cubit.listSurvey![index]);
                                                                        }

                                                                        BlocProvider.of<CheckBoxCubit>(cc)
                                                                            .update(v);
                                                                      },
                                                                      title: Text(cubit
                                                                          .listSurvey![
                                                                              index]
                                                                          .title)),
                                                            ))).toList(),
                                                    SizedBox(
                                                        height: Resizable.size(
                                                            context, 50))
                                                  ],
                                                ),
                                              ),
                                            ))
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 20),
                                    vertical: Resizable.padding(context, 10)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius:
                                              Resizable.padding(context, 2),
                                          offset: Offset(
                                              0, Resizable.size(context, -1)))
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      margin: EdgeInsets.only(
                                          right:
                                              Resizable.padding(context, 20)),
                                      child: DialogButton(
                                          AppText.textCancel.text.toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    ),
                                    if (cubit.listSurvey!.isNotEmpty)
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                                Resizable.size(context, 100)),
                                        child: SubmitButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              waitingDialog(context);
                                              for (var i
                                                  in cubit.listSurveyCheck) {
                                                DateTime dateTime =
                                                    DateTime.now();
                                                int id = dateTime
                                                    .millisecondsSinceEpoch;
                                                await cubit.addSurveyResult(
                                                    i, classId, id);
                                                manageSurveyAdminCubit
                                                    .addSurveyToClass(
                                                        i, id, classId);
                                              }
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            title: AppText.btnAdd.text),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
            ));
      });
}
