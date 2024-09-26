import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'custom_test_cubit.dart';
import 'info_add_custom_test_view.dart';

class AddCustomTestDialog extends StatelessWidget {
  AddCustomTestDialog(this.listTestCubit, {super.key, required this.classModel})
      : cubit = CustomTestCubit(classModel);

  final CustomTestCubit cubit;
  final ClassModel classModel;
  final TestCubitV2 listTestCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomTestCubit, int>(
        bloc: cubit,
        builder: (c, s) {
          return cubit.courses == null
              ? const WaitingAlert()
              : Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 20)),
                          child: Text(
                            AppText.btnAddNewTest.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        ),
                        InfoAddCustomTestView(cubit: cubit),
                        Container(
                            margin: EdgeInsets.only(
                                top: Resizable.padding(context, 20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: Resizable.size(context, 100)),
                                  margin: EdgeInsets.only(
                                      right: Resizable.padding(context, 20)),
                                  child: DialogButton(
                                      AppText.textCancel.text.toUpperCase(),
                                      onPressed: () => Navigator.pop(context)),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: Resizable.size(context, 100)),
                                  child: SubmitButton(
                                      onPressed: () async{
                                        if (cubit.testInfo["course_id"] ==
                                            null) {
                                          notificationDialog(
                                              context,
                                              AppText
                                                  .txtPleaseChooseCourse.text);
                                        } else if (cubit.testInfo["test_id"] ==
                                            null) {
                                          notificationDialog(context,
                                              AppText.txtPleaseChooseTest.text);
                                        } else {
                                          await cubit.updateClass(listTestCubit);
                                          Navigator.pop(context);
                                        }
                                      },
                                      title: AppText.btnAdd.text),
                                ),
                              ],
                            ))
                      ],
                    )),
                  ));
        });
  }
}
