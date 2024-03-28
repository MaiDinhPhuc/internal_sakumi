import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_sub_course_cubit.dart';

class AddSubCourseDialog extends StatelessWidget {
  AddSubCourseDialog(this.subCourseCubit,{super.key})
      : cubit = AddSubCourseCubit();

  final AddSubCourseCubit cubit;
  final SubCourseCubit subCourseCubit;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSubCourseCubit, int>(
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
                        AppText.txtAddNewSubCourse.text.toUpperCase().replaceAll("+ ", ""),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 20)),
                      ),
                    ),
                    InputDropdown(
                        hint: cubit.findCourse(-1),
                        errorText: AppText.txtPleaseChooseCourse.text,
                        onChanged: (v) {
                          cubit.chooseCourse(v);
                        },
                        items: List.generate(
                            cubit.courses!.length,
                                (index) =>
                            ('${cubit.courses![index].title} ${cubit.courses![index].termName} ${cubit.courses![index].code}'))
                            .toList()),
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
                                  onPressed: () async {
                                    if(cubit.courseId != null){
                                      await subCourseCubit.addNewSubCourse(cubit.courseId!);
                                    }
                                    Navigator.pop(context);
                                  }, title: AppText.btnAdd.text),
                            ),
                          ],
                        ))
                  ],
                )),
              ));
        });
  }
}