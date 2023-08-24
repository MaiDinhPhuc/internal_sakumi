import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/prefKey_configs.dart';
import '../../../model/teacher_model.dart';
import '../../../repository/teacher_repository.dart';
import '../../../utils/text_utils.dart';

class TeacherProfileCubit extends Cubit<int> {
  TeacherProfileCubit() : super(0);
  UserModel? userModel;
  TeacherModel? profileTeacher;
  bool isEditBaseInfo = false;
  bool isEditPassLogin = false;
  bool isUpdate = false;
  String defaultImage = 'https://cdn3.iconfinder.com/data/icons/education-1-28/49/144-512.png';
  List<Map<String, dynamic>>? listInfoTextField;

  load(BuildContext context) async {
    UserRepository userRepository = UserRepository.fromContext(context);
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    SharedPreferences localData = await SharedPreferences.getInstance();
    profileTeacher = await teacherRepository
        .getTeacher(localData.getString(PrefKeyConfigs.code).toString());
    debugPrint('=>>>>>>>profileTeacher: ${profileTeacher!.name}');

    userModel = await userRepository.getUserTeacherById(profileTeacher!.userId);
    listInfoTextField = [];
    isEditBaseInfo = false;
    isEditPassLogin = false;
    isUpdate = false;
    listInfoTextField?.add({
      'title': '${AppText.txtName.text}:',
      'value': profileTeacher?.name,
      'isEdit': true,
      'focusNode': FocusNode(),
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.name),
    });
    listInfoTextField?.add({
      'title': '${AppText.txtPhone.text}:',
      'value': profileTeacher?.phone,
      'isEdit': true,
      'focusNode': FocusNode(),
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.phone),
    });
    listInfoTextField?.add({
      'title': '${AppText.textEmail.text}:',
      'value': userModel?.email,
      'isEdit': false,
      'focusNode': FocusNode(),
      'isFocus': false,
      'controller': TextEditingController(text: userModel?.email),
    });
    listInfoTextField?.add({
      'title': '${AppText.txtTeacherCode.text}:',
      'value': profileTeacher?.teacherCode,
      'isEdit': false,
      'focusNode': FocusNode(),
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.teacherCode),
    });
    emit(state + 1);
  }

  void editInfo() {
     isEditBaseInfo = !isEditBaseInfo;
     emit(state + 1);
  }

  void setFocus( bool value , int index) {
    listInfoTextField?[index]['isFocus'] = value;
    emit(state+1);
  }

  void checkText(String text, int index) {
    final controllerName = listInfoTextField?[0]['controller'] as TextEditingController;
    final controllerPhone = listInfoTextField?[1]['controller'] as TextEditingController;
    if(controllerName.text != profileTeacher!.name || controllerPhone.text != profileTeacher!.phone){
      isUpdate = true;
    }
    else {
      isUpdate = false;
    }
    emit(state+1);
  }

  void exit() {
    final controllerName = listInfoTextField?[0]['controller'] as TextEditingController;
    final controllerPhone = listInfoTextField?[1]['controller'] as TextEditingController;
    controllerName.text = profileTeacher!.name;
    controllerPhone.text = profileTeacher!.phone;
    editInfo();
  }

  void updateProfile(BuildContext context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    final controllerName = listInfoTextField?[0]['controller'] as TextEditingController;
    final controllerPhone = listInfoTextField?[1]['controller'] as TextEditingController;
    profileTeacher = profileTeacher!.copyWith(
      name: controllerName.text,
      phone: controllerPhone.text
    );
    await teacherRepository.updateProfileTeacher(profileTeacher!.userId.toString(), profileTeacher!);
    Fluttertoast.showToast(msg: 'Cập nhật thông tin thành công');
    load(context);
  }

  void changeAvatar(BuildContext context, Uint8List img) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    final url = await teacherRepository.uploadImageAndGetUrl(img, 'teacher_avatar');
    debugPrint('==============>url: $url');
    profileTeacher = profileTeacher!.copyWith(url: url);
    await teacherRepository.updateProfileTeacher(profileTeacher!.userId.toString(), profileTeacher!);
    emit(state+1);
  }
}
