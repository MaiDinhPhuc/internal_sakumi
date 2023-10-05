import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../model/teacher_model.dart';
import 'app_bar_info_teacher_cubit.dart';

class TeacherProfileCubit extends Cubit<int> {
  TeacherProfileCubit() : super(0);
  UserModel? userModel;
  TeacherModel? profileTeacher;
  bool isEditBaseInfo = false;
  bool isEditPassLogin = false;
  bool isUpdate = false;

  List<Map<String, dynamic>>? listInfoTextField;
  List<Map<String, dynamic>>? listPassWordField;

  load(BuildContext context) async {
    await context.read<AppBarInfoTeacherCubit>().load();
    profileTeacher = context.read<AppBarInfoTeacherCubit>().state;
    debugPrint('=>>>>>>>profileTeacher: ${profileTeacher!.name}');
    userModel = await FireBaseProvider.instance.getUserById(profileTeacher!.userId);
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
      'isEdit': true,
      'isFocus': true,
      'isShowPass': false,
      'controller': TextEditingController(),
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
      if (!isEditPassLogin ) return;
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
      final controllerOldPass =
      listPassWordField?[0]['controller'] as TextEditingController;
      final controllerNewPass =
      listPassWordField?[1]['controller'] as TextEditingController;
      final controllerAgainNewPass =
      listPassWordField?[2]['controller'] as TextEditingController;
      controllerOldPass.text = '';
      controllerNewPass.text = '';
      controllerAgainNewPass.text = '';
      listPassWordField?[0]['isShowPass'] = false;
      listPassWordField?[1]['isShowPass'] = false;
      listPassWordField?[2]['isShowPass'] = false;
      editPass();
    }
  }

  void updateProfile(BuildContext context) async {
    final controllerName =
        listInfoTextField?[0]['controller'] as TextEditingController;
    final controllerPhone =
        listInfoTextField?[1]['controller'] as TextEditingController;
    profileTeacher = profileTeacher!
        .copyWith(name: controllerName.text, phone: controllerPhone.text);
    await FireBaseProvider.instance.updateProfileTeacher(
        profileTeacher!.userId.toString(), profileTeacher!);
    Fluttertoast.showToast(msg: 'Cập nhật thông tin thành công');
    context.read<AppBarInfoTeacherCubit>().update(profileTeacher!);
    load(context);
  }

  void changeAvatar(BuildContext context, Uint8List img) async {
    final url =
        await FireBaseProvider.instance.uploadImageAndGetUrl(img, 'teacher_avatar');
    debugPrint('==============>url: $url');
    profileTeacher = profileTeacher!.copyWith(url: url);
    await FireBaseProvider.instance.updateProfileTeacher(
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
    final oldPass = (listPassWordField![0]['controller'] as TextEditingController).text;
    final newPass = (listPassWordField![1]['controller'] as TextEditingController).text;
    final res = await FireBaseProvider.instance.changePassword(userModel!.email, oldPass, newPass);
    debugPrint('=>>>>>>>>> resaaaaaaaaa: $res');
    if(res) {
      load(context);
    }

  }
}
