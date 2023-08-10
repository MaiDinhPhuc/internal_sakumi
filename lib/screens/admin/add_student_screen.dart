import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

class AddStudentScreen extends StatelessWidget {
  final StudentModel? studentModel;
  final List<TextEditingController> controller;
  final ChooseLocationCubit locationCubit;
  AddStudentScreen({required this.studentModel, Key? key})
      : controller =
            List.generate(7, (index) => TextEditingController()).toList(),
        locationCubit = ChooseLocationCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return studentModel == null
        ? Scaffold(
            appBar: AppBar(
              title: Text(AppText.btnAddNewStudent.text),
            ),
            body: BlocBuilder<ChooseLocationCubit, String>(
                bloc: locationCubit,
                builder: (c, location) => SafeArea(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 20)),
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFieldWidget(
                                  AppText.textEmail.text,
                                  Icons.mail,
                                  false,
                                  controller: controller[0],
                                  cursorColor: Colors.red,
                                  iconColor: primaryColor,
                                ),
                                TextFieldWidget(
                                    AppText.txtName.text, Icons.person, false,
                                    controller: controller[1],
                                    iconColor: primaryColor),
                                TextFieldWidget(
                                    AppText.txtPhone.text, Icons.phone, false,
                                    controller: controller[2],
                                    isNumber: true,
                                    iconColor: primaryColor),
                                TextFieldWidget(
                                    AppText.txtNote.text, Icons.edit, false,
                                    controller: controller[3],
                                    iconColor: primaryColor),
                                TextFieldWidget(
                                    AppText.titleUserId.text, Icons.key, false,
                                    controller: controller[4],
                                    iconColor: primaryColor),
                                // Padding(
                                //     padding: EdgeInsets.symmetric(
                                //         vertical:
                                //         Resizable.padding(context, 10)),
                                //     child: DropdownButtonHideUnderline(
                                //       child: DropdownButton2(
                                //         buttonPadding: EdgeInsets.symmetric(
                                //             horizontal: Resizable.padding(
                                //                 context, 15),
                                //             vertical: Resizable.padding(
                                //                 context, 20)),
                                //         buttonDecoration: BoxDecoration(
                                //             color: primaryColor
                                //                 .withOpacity(0.3),
                                //             borderRadius:
                                //             BorderRadius.circular(
                                //                 1000)),
                                //         dropdownElevation: 0,
                                //         dropdownDecoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color: primaryColor),
                                //             color: Colors.white,
                                //             borderRadius:
                                //             BorderRadius.circular(10)),
                                //         hint: Text(
                                //           AppText.titleRole.text,
                                //           style: TextStyle(
                                //             fontWeight: FontWeight.w500,
                                //             fontSize:
                                //             Resizable.font(context, 18),
                                //             color:
                                //             Theme.of(context).hintColor,
                                //           ),
                                //         ),
                                //         items: [
                                //           AppText.selectorStudent.text,
                                //           AppText.selectorTeacher.text
                                //         ]
                                //             .map((item) =>
                                //             DropdownMenuItem<String>(
                                //               value: item,
                                //               child: Text(
                                //                 item,
                                //                 style: TextStyle(
                                //                   color: primaryColor,
                                //                   fontWeight:
                                //                   FontWeight.w500,
                                //                   fontSize:
                                //                   Resizable.font(
                                //                       context, 18),
                                //                 ),
                                //               ),
                                //             ))
                                //             .toList(),
                                //         value: s,
                                //         onChanged: (v) =>
                                //             cubit.update(v.toString()),
                                //         buttonHeight:
                                //         Resizable.size(context, 60),
                                //         buttonWidth: double.maxFinite,
                                //         itemHeight:
                                //         Resizable.size(context, 50),
                                //       ),
                                //     )),
                                // if (s == AppText.selectorStudent.text)
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Resizable.padding(context, 10)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        buttonPadding: EdgeInsets.symmetric(
                                            horizontal:
                                                Resizable.padding(context, 15),
                                            vertical:
                                                Resizable.padding(context, 20)),
                                        buttonDecoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(1000)),
                                        dropdownElevation: 0,
                                        dropdownDecoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hint: Text(
                                          AppText.titleRole.text,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 18),
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: ['vn', 'jp']
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: location,
                                        onChanged: (v) =>
                                            locationCubit.change(v.toString()),
                                        buttonHeight:
                                            Resizable.size(context, 60),
                                        buttonWidth: double.maxFinite,
                                        itemHeight: Resizable.size(context, 50),
                                      ),
                                    )),
                                TextFieldWidget(AppText.txtStudentCode.text,
                                    Icons.code, false,
                                    controller: controller[5],
                                    iconColor: primaryColor),
                                SizedBox(
                                  height: Resizable.size(context, 30),
                                ),
                                ElevatedButton(
                                  onPressed: () => AuthServices.signupUser(
                                      controller[1].text,
                                      controller[3].text,
                                      controller[2].text,
                                      controller[5].text,
                                      location == 'vn' ? false : true,
                                      controller[0].text,
                                      'student',
                                      int.parse(controller[4].text),
                                      context),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 30)))),
                                  child: Text(AppText.btnSignUp.text),
                                ),
                              ]),
                        )))),
          )
        : BlocBuilder<LoadStudentCubit, StudentModel?>(
            bloc: LoadStudentCubit(studentModel!)..load(context),
            builder: (c, s) => Scaffold(
                  appBar: AppBar(
                    title: Text(AppText.btnAddNewStudent.text),
                  ),
                  body: BlocBuilder<ChooseLocationCubit, String>(
                      bloc: locationCubit,
                      builder: (c, location) => SafeArea(
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 20)),
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFieldWidget(
                                        AppText.textEmail.text,
                                        Icons.mail,
                                        false,
                                        controller: controller[0],
                                        cursorColor: Colors.red,
                                        iconColor: primaryColor,
                                      ),
                                      TextFieldWidget(
                                          AppText.txtName.text,
                                          isUpdate: true,
                                          Icons.person,
                                          false,
                                          controller: controller[1],
                                          hintText: studentModel!.name,
                                          iconColor: primaryColor),
                                      TextFieldWidget(
                                          AppText.txtPhone.text,
                                          isUpdate: true,
                                          Icons.phone,
                                          false,
                                          controller: controller[2],
                                          hintText: studentModel!.phone,
                                          isNumber: true,
                                          iconColor: primaryColor),
                                      TextFieldWidget(
                                          AppText.txtNote.text,
                                          isUpdate: true,
                                          Icons.edit,
                                          false,
                                          controller: controller[3],
                                          hintText: studentModel!.note,
                                          iconColor: primaryColor),
                                      TextFieldWidget(AppText.titleUserId.text,
                                          Icons.key, false,
                                          controller: controller[4],
                                          iconColor: primaryColor),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Resizable.padding(
                                                  context, 10)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              buttonPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Resizable.padding(
                                                              context, 15),
                                                      vertical:
                                                          Resizable.padding(
                                                              context, 20)),
                                              buttonDecoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000)),
                                              dropdownElevation: 0,
                                              dropdownDecoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: primaryColor),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              hint: Text(
                                                AppText.titleRole.text,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Resizable.font(
                                                      context, 18),
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items: ['vn', 'jp']
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                Resizable.font(
                                                                    context,
                                                                    18),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: location,
                                              onChanged: (v) => locationCubit
                                                  .change(v.toString()),
                                              buttonHeight:
                                                  Resizable.size(context, 60),
                                              buttonWidth: double.maxFinite,
                                              itemHeight:
                                                  Resizable.size(context, 50),
                                            ),
                                          )),
                                      TextFieldWidget(
                                          AppText.txtStudentCode.text,
                                          Icons.code,
                                          false,
                                          controller: controller[5],
                                          iconColor: primaryColor),
                                      SizedBox(
                                        height: Resizable.size(context, 30),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (context.mounted) {
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    Routes.admin));
                                          }
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(
                                                  "student_user_${studentModel!.userId}")
                                              .update({
                                            'in_jp':
                                                location == 'vn' ? false : true,
                                            'name': controller[1].text != ''
                                                ? controller[1].text
                                                : studentModel!.name,
                                            'note': controller[3].text != ''
                                                ? controller[3].text
                                                : studentModel!.note,
                                            'phone': controller[2].text != ''
                                                ? controller[2].text
                                                : studentModel!.phone,
                                            'status': 'progress',
                                            'student_code':
                                                controller[5].text != ''
                                                    ? controller[5].text
                                                    : studentModel!.studentCode,
                                            'url': studentModel!.url,
                                            'user_id': controller[4].text != ''
                                                ? int.parse(controller[4].text)
                                                : studentModel!.userId
                                          });
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 30)))),
                                        child: Text(AppText.btnUpdate.text),
                                      ),
                                    ]),
                              )))),
                ));
  }
}

class LoadStudentCubit extends Cubit<StudentModel?> {
  final StudentModel model;
  LoadStudentCubit(this.model) : super(null);

  load(context) async {
    var user = UserRepository.fromContext(context);
    emit(await user.getStudentInfo(model.userId));
  }
}

class ChooseLocationCubit extends Cubit<String> {
  ChooseLocationCubit() : super('vn');

  change(String country) {
    emit(country);
  }
}
