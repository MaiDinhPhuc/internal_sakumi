import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'custom_lesson_cubit.dart';
import 'info_add_custom_lesson_dialog.dart';


class AddCustomLessonDialog extends StatelessWidget {
  AddCustomLessonDialog({super.key, required this.classModel})
      : cubit = CustomLessonCubit(classModel);

  final CustomLessonCubit cubit;
  final ClassModel classModel;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomLessonCubit, int>(
        bloc: cubit,
        builder: (c,s){
      return cubit.courses == null ? const WaitingAlert() : Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
          child: Container(
            //height: 500,
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.all(Resizable.padding(context, 20)),
            child: SingleChildScrollView(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin:
                  EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                  child: Text(
                    AppText.btnAddNewLesson.text.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  ),
                ),
                InfoAddCustomLesson(cubit:cubit),
                Container(
                    margin:
                    EdgeInsets.only(top: Resizable.padding(context, 20)),
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
                              onPressed: () {}, title: AppText.btnAdd.text),
                        ),
                      ],
                    ))
              ],
            )),
          ));
    });
  }
}
