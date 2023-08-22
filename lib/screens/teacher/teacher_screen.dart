import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/teacher_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class TeacherScreen extends StatelessWidget {
  final String name;
  const TeacherScreen(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return Scaffold(
        body: Column(
      children: [
        Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Resizable.padding(context, 70),
                    right: Resizable.padding(context, 70),
                    top: Resizable.padding(context, 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: Resizable.size(context, 25),
                          backgroundColor: greyColor.shade300,
                        ),
                        SizedBox(width: Resizable.size(context, 10)),
                        BlocBuilder<TeacherCubit, int>(
                            builder: (_, __) => cubit.state == 0
                                ? const CircularProgressIndicator()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppText.txtHello.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 24)),
                                      ),
                                      Text(
                                          '${cubit.teacherProfile?.name} ${AppText.txtSensei.text}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                                  Resizable.font(context, 40)))
                                    ],
                                  ))
                      ],
                    ),
                    Icon(
                      Icons.menu,
                      size: Resizable.size(context, 30),
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: Resizable.padding(context, 10)),
                child: Text(AppText.titleListClass.text.toUpperCase(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 30),
                        fontWeight: FontWeight.w800)),
              ),
              BlocBuilder<TeacherCubit, int>(
                  builder: (_, __) => cubit.listClass == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                        Resizable.padding(context, 150)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: Resizable.size(context, 120),
                            child: InputDropdown(
                                isCircleBorder: true,
                                height: 30,
                                title: AppText.txtCourse.text,
                                hint: AppText.txtFilter.text,
                                errorText: AppText
                                    .txtPleaseChooseCourse.text,
                                onChanged: (v) async {
                                  waitingDialog(context);
                                  await cubit.loadListClassOfTeacher(context, v.toString());
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                items: [
                                  AppText.optBoth.text,
                                  AppText.optInProgress.text,
                                  AppText.optComplete.text,
                                ]),
                          ),
                        ),
                        ClassItemRowLayout(
                          widgetClassCode: Text(
                              AppText.txtClassCode.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                          widgetCourse: Text(
                              AppText.txtCourse.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                          widgetLessons: Text(
                              AppText.txtNumberOfLessons.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                          widgetAttendance: Text(
                              AppText.txtRateOfAttendance.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                          widgetSubmit: Text(
                              AppText
                                  .txtRateOfSubmitHomework.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                          widgetEvaluate: Text(
                              AppText.txtEvaluate.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(
                                      context, 17),
                                  color: greyColor.shade600)),
                        ),
                        SizedBox(
                            height:
                            Resizable.size(context, 10)),
                        (cubit.listClass!.isNotEmpty) ?
                        Column(
                            children: cubit.listClass!
                                .map((e) => ClassItem(
                                cubit.listClass!.indexOf(e),
                                e.classId))
                                .toList()
                        ) : Center(
                          child: Text(AppText.txtNoClass.text),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )),
      ],
    ));
  }
}