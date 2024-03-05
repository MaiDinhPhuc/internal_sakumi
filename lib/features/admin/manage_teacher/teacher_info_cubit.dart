import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TeacherInfoCubit extends Cubit<int> {
  TeacherInfoCubit() : super(0);

  TeacherModel? teacher;
  UserModel? user;

  List<TeacherClassModel>? teacherClasses;
  List<ClassModel>? classes;
  bool isLoading = true;

  String name = "";
  String teacherCode = "";
  String phone = "";
  String note = "";

  List<String> listStatus = ['Preparing', 'InProgress', 'Completed', 'Cancel', 'Remove'];

  List<bool> status = [true, true, false, false, false];

  List<String> listStatusSub = ['Mới tạo', 'Đang học', 'Hoàn thành', 'Huỷ', 'Xoá'];

  update() {
    emit(state + 1);
  }

  loadTeacher(int teacherId) async {
    await DataProvider.teacherById(teacherId, loadTeacherInfo);
    await DataProvider.userById(teacherId, loadUserInfo);

    name = teacher!.name;
    teacherCode = teacher!.teacherCode;
    phone = teacher!.phone;
    note = teacher!.note;
    emit(state + 1);
    loadInFoTeacherInSystem(teacherId);
  }

  loadTeacherInfo(Object teacher) {
    this.teacher = teacher as TeacherModel;
  }

  loadUserInfo(Object user) {
    this.user = user as UserModel;
  }

  loadInFoTeacherInSystem(int teacherId) async {
    teacherClasses =
        await FireBaseProvider.instance.getTeacherClassById(teacherId);
    var listClassId = teacherClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassByListIdV2(listClassId);
    isLoading = false;
    emit(state + 1);
  }
  
  List<ClassModel> getClasses(){
    List<String> listStatusChoose = [];
    for(int i = 0; i < status.length; i++){
      if(status[i]){
        listStatusChoose.add(listStatus[i]);
      }
    }
    return classes!.where((e) => listStatusChoose.contains(e.classStatus)).toList();
  }

  changeNote(String newValue) {
    note = newValue;
    emit(state + 1);
  }

  changePhone(String newValue) {
    phone = newValue;
    emit(state + 1);
  }

  changeTeacherCode(String newValue) {
    teacherCode = newValue;
    emit(state + 1);
  }

  changeName(String newValue) {
    name = newValue;
    emit(state + 1);
  }
}
