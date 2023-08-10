import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/firestore_service.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

class AddClassScreen extends StatelessWidget {
  final ClassModel? classModel;
  final List<TextEditingController> controller;
  AddClassScreen({required this.classModel, Key? key})
      : controller =
            List.generate(7, (index) => TextEditingController()).toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return classModel == null
        ? Scaffold(
            appBar: AppBar(
              title: Text(AppText.btnAddNewClass.text),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Resizable.size(context, 20),
                    ),
                    TextFieldWidget(AppText.txtClassId.text, Icons.code, false,
                        controller: controller[0],
                        iconColor: primaryColor,
                        isNumber: true),
                    TextFieldWidget(
                      AppText.txtCourseId.text,
                      Icons.code,
                      false,
                      controller: controller[1],
                      iconColor: primaryColor,
                      isNumber: true,
                    ),
                    TextFieldWidget(
                        AppText.txtClassCode.text, Icons.code, false,
                        controller: controller[2], iconColor: primaryColor),
                    TextFieldWidget(
                        AppText.txtDescription.text, Icons.code, false,
                        controller: controller[3], iconColor: primaryColor),
                    TextFieldWidget(
                        AppText.txtStartTime.text, Icons.code, false,
                        controller: controller[4], iconColor: primaryColor),
                    TextFieldWidget(AppText.txtEndTime.text, Icons.code, false,
                        controller: controller[5], iconColor: primaryColor),
                    TextFieldWidget(AppText.txtNote.text, Icons.code, false,
                        controller: controller[6], iconColor: primaryColor),
                    SizedBox(
                      height: Resizable.size(context, 30),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (context.mounted) {
                          Navigator.popUntil(
                              context, ModalRoute.withName(Routes.admin));
                        }
                        await FirestoreServices.addNewClass(
                            int.parse(controller[0].text),
                            int.parse(controller[1].text),
                            controller[2].text,
                            controller[3].text,
                            controller[4].text,
                            controller[5].text,
                            controller[6].text);
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 30)))),
                      child: Text(AppText.btnCreateClass.text),
                    ),
                  ],
                ),
              ),
            ),
          )
        : BlocBuilder<LoadClassCubit, ClassModel?>(
            bloc: LoadClassCubit(classModel!)..load(context),
            builder: (c, s) => Scaffold(
                  appBar: AppBar(
                    title: Text(classModel!.classCode),
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Resizable.size(context, 20),
                          ),
                          TextFieldWidget(
                            AppText.txtClassId.text,
                            Icons.code,
                            false,
                            controller: controller[0],
                            iconColor: primaryColor,
                            isNumber: true,
                            hintText: classModel!.classId.toString(),
                          ),
                          TextFieldWidget(
                            AppText.txtCourseId.text,
                            Icons.code,
                            false,
                            controller: controller[1],
                            iconColor: primaryColor,
                            isNumber: true,
                            hintText: classModel!.courseId.toString(),
                          ),
                          TextFieldWidget(
                              AppText.txtClassCode.text, Icons.code, false,
                              controller: controller[2],
                              iconColor: primaryColor,
                              isUpdate: true,
                              hintText: classModel!.classCode),
                          TextFieldWidget(
                              AppText.txtDescription.text, Icons.code, false,
                              controller: controller[3],
                              iconColor: primaryColor,
                              isUpdate: true,
                              hintText: classModel!.description),
                          TextFieldWidget(
                              AppText.txtStartTime.text, Icons.code, false,
                              controller: controller[4],
                              iconColor: primaryColor,
                              isUpdate: true,
                              hintText: classModel!.startTime),
                          TextFieldWidget(
                              AppText.txtEndTime.text, Icons.code, false,
                              controller: controller[5],
                              iconColor: primaryColor,
                              isUpdate: true,
                              hintText: classModel!.endTime),
                          TextFieldWidget(
                              AppText.txtNote.text, Icons.code, false,
                              controller: controller[6],
                              iconColor: primaryColor,
                              isUpdate: true,
                              hintText: classModel!.note),
                          SizedBox(
                            height: Resizable.size(context, 30),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (context.mounted) {
                                Navigator.popUntil(
                                    context, ModalRoute.withName(Routes.admin));
                              }
                              debugPrint(
                                  "------ ======= -------- ========== class_${classModel!.classId}_course_${classModel!.courseId}");
                              debugPrint(
                                  "------ ======= -------- ========== ${controller[6].text != '' ? controller[6].text : classModel!.note}");
                              await FirebaseFirestore.instance
                                  .collection('class')
                                  .doc(
                                      "class_${classModel!.classId}_course_${classModel!.courseId}")
                                  .update({
                                'class_id': controller[0].text != ''
                                    ? int.parse(controller[0].text)
                                    : classModel!.classId,
                                'course_id': controller[1].text != ''
                                    ? int.parse(controller[1].text)
                                    : classModel!.courseId,
                                'description': controller[3].text != ''
                                    ? controller[3].text
                                    : classModel!.description,
                                'end_time': controller[5].text != ''
                                    ? controller[5].text
                                    : classModel!.endTime,
                                'start_time': controller[4].text != ''
                                    ? controller[4].text
                                    : classModel!.startTime,
                                'note': controller[6].text != ''
                                    ? controller[6].text
                                    : classModel!.note,
                                'class_code': controller[2].text != ''
                                    ? controller[2].text
                                    : classModel!.classCode,
                                'list_student': [],
                                'list_teacher': [],
                              });
                              debugPrint(
                                  "------ ======= -------- ========== ${controller[0].text != '' ? controller[0].text : classModel!.note}");
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 30)))),
                            child: Text(AppText.btnUpdate.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
  }
}

class LoadClassCubit extends Cubit<ClassModel?> {
  final ClassModel model;
  LoadClassCubit(this.model) : super(null);

  load(context) async {
    var userRepo = UserRepository.fromContext(context);
    emit(await userRepo.getClassByClassId(model.classId, model.courseId));
  }
}
