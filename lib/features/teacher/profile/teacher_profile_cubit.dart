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
import 'app_bar_info_teacher_cubit.dart';

class TeacherProfileCubit extends Cubit<int> {
  TeacherProfileCubit() : super(0);
  UserModel? userModel;
  TeacherModel? profileTeacher;
  bool isEditBaseInfo = false;
  bool isEditPassLogin = false;
  bool isUpdate = false;


  String passTeacher = '';
  List<Map<String, dynamic>>? listInfoTextField;
  List<Map<String, dynamic>>? listPassWordField;

  load(BuildContext context) async {
    UserRepository userRepository = UserRepository.fromContext(context);
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    SharedPreferences localData = await SharedPreferences.getInstance();
    profileTeacher = await teacherRepository
        .getTeacher(localData.getString(PrefKeyConfigs.code).toString());
    debugPrint('=>>>>>>>profileTeacher: ${profileTeacher!.name}');
    passTeacher = localData.getString(PrefKeyConfigs.password).toString();
    userModel = await userRepository.getUserById(profileTeacher!.userId);
    listInfoTextField = [];
    isEditBaseInfo = false;
    isEditPassLogin = false;
    isUpdate = false;
    listInfoTextField?.add({
      'title': '${AppText.txtName.text}:',
      'focusNode': FocusNode(),
      'isEdit': true,
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.name),
    });
    listInfoTextField?.add({
      'title': '${AppText.txtPhone.text}:',
      'focusNode': FocusNode(),
      'isEdit': true,
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.phone),
    });
    listInfoTextField?.add({
      'title': '${AppText.textEmail.text}:',
      'focusNode': FocusNode(),
      'isEdit': false,
      'isFocus': false,
      'controller': TextEditingController(text: userModel?.email),
    });
    listInfoTextField?.add({
      'title': '${AppText.txtTeacherCode.text}:',
      'focusNode': FocusNode(),
      'isEdit': false,
      'isFocus': false,
      'controller': TextEditingController(text: profileTeacher?.teacherCode),
    });
    listPassWordField = [];
    listPassWordField?.add({
      'title': '${AppText.txtCurrentPass.text}:',
      'focusNode': FocusNode(),
      'isEdit': false,
      'isFocus': false,
      'isShowPass': false,
      'controller': TextEditingController(text: passTeacher),
    });
    listPassWordField?.add({
      'title': '${AppText.txtNewPass.text}:',
      'focusNode': FocusNode(),
      'isEdit': true,
      'isFocus': false,
      'isShowPass': false,
      'controller': TextEditingController(),
    });
    listPassWordField?.add({
      'title': '${AppText.txtAgainNewPass.text}:',
      'focusNode': FocusNode(),
      'isEdit': true,
      'isFocus': false,
      'isShowPass': false,
      'controller': TextEditingController(),
    });
    emit(state + 1);
  }

  void editInfo() {
    isEditBaseInfo = !isEditBaseInfo;
    emit(state + 1);
  }

  void setFocus(String type, int index, bool value) {
    if (type == 'info') {
      if (!isEditBaseInfo) return;
      listInfoTextField?[index]['isFocus'] = value;
    }
    else {
      if (!isEditPassLogin || index == 0) return;
      listPassWordField?[index]['isFocus'] = value;

    }
    emit(state + 1);
  }

  void checkText(String text, int index, String type) {
    if (type == 'info') {
      final controllerName =
          listInfoTextField?[0]['controller'] as TextEditingController;
      final controllerPhone =
          listInfoTextField?[1]['controller'] as TextEditingController;
      if (controllerName.text != profileTeacher!.name ||
          controllerPhone.text != profileTeacher!.phone) {
        isUpdate = true;
      } else {
        isUpdate = false;
      }
      emit(state + 1);
    }

  }

  void exit(String type) {
    if(type == 'info') {
      final controllerName =
      listInfoTextField?[0]['controller'] as TextEditingController;
      final controllerPhone =
      listInfoTextField?[1]['controller'] as TextEditingController;
      controllerName.text = profileTeacher!.name;
      controllerPhone.text = profileTeacher!.phone;
      editInfo();
    }
   else {
      final controllerNewPass =
      listPassWordField?[1]['controller'] as TextEditingController;
      final controllerAgainNewPass =
      listPassWordField?[2]['controller'] as TextEditingController;
      controllerNewPass.text = '';
      controllerAgainNewPass.text = '';
      listPassWordField?[1]['isShowPass'] = false;
      listPassWordField?[2]['isShowPass'] = false;
      editPass();
    }
  }

  void updateProfile(BuildContext context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    final controllerName =
        listInfoTextField?[0]['controller'] as TextEditingController;
    final controllerPhone =
        listInfoTextField?[1]['controller'] as TextEditingController;
    profileTeacher = profileTeacher!
        .copyWith(name: controllerName.text, phone: controllerPhone.text);
    await teacherRepository.updateProfileTeacher(
        profileTeacher!.userId.toString(), profileTeacher!);
    Fluttertoast.showToast(msg: 'Cập nhật thông tin thành công');
    context.read<AppBarInfoTeacherCubit>().update(profileTeacher!);
    load(context);
  }

  void changeAvatar(BuildContext context, Uint8List img) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    final url =
        await teacherRepository.uploadImageAndGetUrl(img, 'teacher_avatar');
    debugPrint('==============>url: $url');
    profileTeacher = profileTeacher!.copyWith(url: url);
    await teacherRepository.updateProfileTeacher(
        profileTeacher!.userId.toString(), profileTeacher!);
    Fluttertoast.showToast(msg: 'Bạn đã đổi avatar');
    context.read<AppBarInfoTeacherCubit>().update(profileTeacher!);
    emit(state + 1);
  }

  void editPass() {
    isEditPassLogin = !isEditPassLogin;
    emit(state + 1);
  }

  void setFocusPass(bool value, int index) {
    listPassWordField?[index]['isFocus'] = value;
    emit(state + 1);
  }

  void hidePass(int index) {
    listPassWordField?[index]['isShowPass'] =
        !listPassWordField?[index]['isShowPass'];
    emit(state + 1);
  }


  void changePassWord(BuildContext context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    final newPass = (listPassWordField![1]['controller'] as TextEditingController).text;
    final res = await teacherRepository.changePassword(userModel!.email, passTeacher, newPass);
    debugPrint('=>>>>>>>>> resaaaaaaaaa: $res');
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    if(res) {
      await sharedPreferences.setString(PrefKeyConfigs.password, newPass);
      load(context);
    }

  }
}
