import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'add_new_report_dialog_cubit.dart';
import 'confirm_delete_report.dart';
import 'info_reporty_view.dart';

class AddNewReportDialog extends StatelessWidget {
  AddNewReportDialog(
      {super.key,
      required this.reportCubit,
      required this.isEdit,
      this.reportModel})
      : cubit = AddNewReportCubit(reportModel, reportCubit.userId!);
  final TeacherReportCubit reportCubit;
  final AddNewReportCubit cubit;
  final bool isEdit;
  final ReportModel? reportModel;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewReportCubit, int>(
        bloc: cubit,
        builder: (c, _) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Form(
                  key: cubit.formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
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
                                isEdit
                                    ? AppText.txtEditReport.text.toUpperCase()
                                    : AppText.txtAddNewReport.text
                                        .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            )),
                        Expanded(
                            flex: 10,
                            child: ReportInfoView(
                                cubit: cubit,
                                isEdit: isEdit,
                                reportModel: reportModel)),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: isEdit
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isEdit)
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      child: DeleteButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return ConfirmDeleteReport(
                                                    onPress: () {
                                                      reportCubit.removeReport(reportModel!.id);
                                                    });
                                                });
                                          },
                                          title: AppText.txtDeleteReport.text),
                                    ),
                                  Row(
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
                                            AppText.textCancel.text
                                                .toUpperCase(),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                                Resizable.size(context, 100)),
                                        child: SubmitButton(
                                            onPressed: () async {
                                              if (cubit.formKey.currentState!
                                                  .validate()) {
                                                if (!isEdit) {
                                                  await cubit.addNewReport(
                                                      reportCubit);
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                } else {
                                                  await cubit
                                                      .updateReport(reportCubit);
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              } else {
                                                debugPrint('Form is invalid');
                                              }
                                            },
                                            title: isEdit
                                                ? AppText.btnUpdate.text
                                                : AppText.btnAdd.text),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )));
        });
  }
}
