import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_new_class_cubit.dart';

class InfoClassView extends StatelessWidget {
  const InfoClassView(
      {super.key,
      required this.isEdit,
      required this.cubit,
      required this.classModel,
      required this.desCon,
      required this.noteCon,
      required this.codeCon,
      required this.linkCon});
  final bool isEdit;
  final AlertNewClassCubit cubit;
  final ClassModel? classModel;
  final TextEditingController desCon;
  final TextEditingController noteCon;
  final TextEditingController codeCon;
  final TextEditingController linkCon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          child: IntrinsicHeight(
            child: Row(
              children: [
                if (!isEdit)
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.txtCourse.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: const Color(0xff757575))),
                          InputDropdown(
                              hint: cubit.findCourse(classModel == null
                                  ? -1
                                  : classModel!.courseId),
                              errorText: AppText.txtPleaseChooseCourse.text,
                              onChanged: (v) {
                                cubit.chooseCourse(v);
                              },
                              items: List.generate(
                                      cubit.listCourse!.length,
                                      (index) =>
                                          ('${cubit.listCourse![index].title} ${cubit.listCourse![index].termName} ${cubit.listCourse![index].code}'))
                                  .toList())
                        ],
                      )),
                if (isEdit)
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.txtCourse.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: const Color(0xff757575))),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)),
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 18),
                                  fontWeight: FontWeight.w500),
                              initialValue: cubit.findCourse(classModel == null
                                  ? -1
                                  : classModel!.courseId),
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Colors.white,
                                hoverColor: Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xffE0E0E0),
                                      width: Resizable.size(context, 0.5)),
                                  borderRadius: BorderRadius.circular(
                                      Resizable.padding(context, 5)),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Resizable.padding(context, 5)),
                                    borderSide: BorderSide(
                                        color: const Color(0xffE0E0E0),
                                        width: Resizable.size(context, 0.5))),
                              ),
                            ),
                          )
                        ],
                      )),
                SizedBox(width: Resizable.size(context, 20)),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.txtClassCode.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 18),
                                color: const Color(0xff757575))),
                        InputField(
                            controller: codeCon,
                            errorText: AppText.txtPleaseInputClassCode.text)
                      ],
                    )),
              ],
            ),
          )),
      if (isEdit == false)
        Row(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.txtClassType.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: const Color(0xff757575))),
                    InputDropdown(
                        hint: AppText.txtChooseClassType.text,
                        errorText: AppText.txtPleaseChooseType.text,
                        onChanged: (v) {
                          cubit.classType = cubit.chooseType(v);
                        },
                        items: List.generate(cubit.listClassType.length,
                            (index) => (cubit.listClassType[index])).toList())
                  ],
                )),
            SizedBox(width: Resizable.size(context, 20)),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: Resizable.padding(context, 10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          cubit.updateInformal();
                        },
                        child: Icon(
                            cubit.informal
                                ? Icons.check_box
                                : Icons.check_box_outline_blank_outlined,
                            color: primaryColor),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: Resizable.padding(context, 5)),
                          child: Text(AppText.txtInformal.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: const Color(0xff757575))))
                    ],
                  ),
                ))
          ],
        ),
      if (isEdit)
        Row(children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.txtClassType.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 18),
                          color: const Color(0xff757575))),
                  InputDropdown(
                      hint: cubit.findClassType(classModel!.classType),
                      onChanged: (v) {
                        cubit.classType = cubit.chooseType(v);
                      },
                      items: List.generate(cubit.listClassType.length,
                          (index) => (cubit.listClassType[index])).toList())
                ],
              )),
          SizedBox(width: Resizable.size(context, 20)),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.titleStatus.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 18),
                          color: const Color(0xff757575))),
                  InputDropdown(
                      hint: cubit.findStatus(classModel!.classStatus),
                      onChanged: (v) {
                        cubit.classStatus = cubit.chooseStatus(v);
                      },
                      items: List.generate(
                          cubit.listClassStatusMenu.length,
                          (index) => (vietnameseSubText(
                              cubit.listClassStatusMenu[index]))).toList())
                ],
              )),
          SizedBox(width: Resizable.size(context, 20)),
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: Resizable.padding(context, 10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        cubit.updateInformal();
                      },
                      child: Icon(
                          cubit.informal
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_outlined,
                          color: primaryColor),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: Resizable.padding(context, 5)),
                        child: Text(AppText.txtInformal.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 18),
                                color: const Color(0xff757575))))
                  ],
                ),
              ))
        ]),
      InputItem(
          title: AppText.txtDescription.text,
          controller: desCon,
          isExpand: true),
      Row(
        children: [
          Expanded(
              child: InputDate(
                  title: AppText.txtStartDate.text,
                  errorText: AppText.txtErrorStartDate.text)),
          SizedBox(width: Resizable.size(context, 20)),
          Expanded(
              child: InputDate(
                  title: AppText.txtEndDate.text,
                  isStartDate: false,
                  errorText: AppText.txtErrorEndDate.text))
        ],
      ),
      InputItem(
          controller: noteCon, title: AppText.txtNote.text, isExpand: true),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtLink.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          InputField(
              controller: linkCon, errorText: AppText.txtPleaseInputLink.text)
        ],
      )
    ]));
  }
}
