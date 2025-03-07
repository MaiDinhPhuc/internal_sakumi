import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'custom_lesson_cubit.dart';
import 'list_lesson_cubit_v2.dart';

class AddCustomLessonDialog extends StatelessWidget {
  AddCustomLessonDialog(this.listLessonCubit,
      {super.key, required this.classModel})
      : cubit = CustomLessonCubit(classModel);

  final CustomLessonCubit cubit;
  final ClassModel classModel;
  final ListLessonCubitV2 listLessonCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomLessonCubit, int>(
        bloc: cubit,
        builder: (c, s) {
          return cubit.lessons == null
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
                            AppText.btnAddNewLesson.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppText.txtTitle.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 18),
                                          color: const Color(0xff757575))),
                                  InputField(controller: cubit.titleCon)
                                ],
                              ),
                              Text(AppText.txtContent.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575))),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Resizable.padding(context, 15),
                                      vertical: Resizable.padding(context, 8)),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: Resizable.size(context, 1),
                                          color: greyColor.shade50),
                                      borderRadius: BorderRadius.circular(
                                          Resizable.size(context, 5))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                      child: Text(
                                                          AppText
                                                              .txtCourse.text,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w600,
                                                              fontSize:
                                                                  Resizable.font(
                                                                      context,
                                                                      18),
                                                              color: const Color(
                                                                  0xff757575))))),
                                              Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                      child: Text(
                                                          AppText
                                                              .titleLesson.text,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  Resizable.font(
                                                                      context,
                                                                      18),
                                                              color: const Color(
                                                                  0xff757575))))),
                                              Expanded(
                                                  flex: 1, child: Container())
                                            ],
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
                                          DottedBorderButton(
                                              AppText.btnAddNewLesson.text,
                                              onPressed: () {
                                            cubit.addNewCourse();
                                          })
                                        ],
                                      ))
                                    ],
                                  )),
                              InputItem(
                                  title: AppText.txtDescription.text,
                                  controller: cubit.desCon,
                                  isExpand: true),
                            ],
                          ),
                        ),
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
                                      onPressed: () {
                                        if (cubit.titleCon.text.isEmpty) {
                                          notificationDialog(context,
                                              "Tiêu đề không được trống!");
                                        } else {
                                          cubit.updateClass(listLessonCubit);
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
