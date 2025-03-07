import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/lesson/custom_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AddCustomLessonSubCourseDialog extends StatelessWidget {
  AddCustomLessonSubCourseDialog(this.subCourseCubit,{super.key, required this.classModel})
      : cubit = CustomLessonCubit(classModel);

  final CustomLessonCubit cubit;
  final ClassModel classModel;
  final SubCourseCubit subCourseCubit;


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
                    for (int i = 0;
                    i < cubit.listLessonInfo.length;
                    i++)
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child:Container(
                                margin:const EdgeInsets.only(right: 5, bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey, width: 0.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(AppText
                                          .textChooseCourse
                                          .text),
                                      value: cubit
                                          .getCourseValue(i),
                                      items: cubit
                                          .listCourse()
                                          .map((item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        cubit.chooseCourse(
                                            value, i);
                                      },
                                    )
                                ),
                              )
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                margin:const EdgeInsets.only(right: 5, bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey, width: 0.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(AppText
                                          .txtChooseLesson
                                          .text),
                                      value: cubit
                                          .getLessonValue(i),
                                      items: cubit.getCourseValue(
                                          i) ==
                                          null
                                          ? []
                                          : cubit
                                          .listLesson()[cubit
                                          .getCourseValue(
                                          i)]!
                                          .map((item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child:
                                          Text(item, overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        cubit.chooseLesson(
                                            value, i);
                                      },
                                    )
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Resizable.padding(context, 5),
                                    bottom: Resizable.padding(context, 5),
                                    top: Resizable.padding(context, 5)),
                                height: Resizable.size(context, 30),
                                width: Resizable.size(context, 30),
                                decoration: BoxDecoration(
                                    color: greyColor.shade50,
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 5))),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 100)),
                                    onTap: () {
                                      cubit.delete(i);
                                    },
                                    child: Icon(Icons.delete,
                                        color: greyColor.shade500,
                                        size: Resizable.size(context, 20))),
                              ))
                        ],
                      ),
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
                                  onPressed: () {
                                    cubit.updateSubCourseClass(subCourseCubit);
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