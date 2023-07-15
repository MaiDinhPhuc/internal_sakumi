import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherCubit extends Cubit<int> {
  TeacherCubit() : super(0);

  TeacherModel? teacherProfile;
  List<ClassModel>? listClass;
  List<CourseModel>? courses;
  List<int>? listStatus;

  void init(context) {
    loadProfileTeacher();
    loadListClassOfTeacher(context);
  }

  void loadProfileTeacher() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    teacherProfile = await TeacherRepository.getTeacher(
        localData.getString(PrefKeyConfigs.code)!);
    emit(state + 1);
  }

  void loadListClassOfTeacher(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    List<TeacherClassModel> listTeacherClass = [];
    List<ClassModel> listAllClass = [];
    List<CourseModel> listAllCourse = [];
    SharedPreferences localData = await SharedPreferences.getInstance();

    listTeacherClass = await TeacherRepository.getTeacherClassById(
        'user_id', localData.getInt(PrefKeyConfigs.userId)!);

    listAllCourse = await TeacherRepository.getAllCourse();

    listAllClass = await adminRepository.getListClass();

    listClass = [];
    for (var i in listTeacherClass) {
      for (var j in listAllClass) {
        if (i.classId == j.classId) {
          listClass!.add(j);
          break;
        }
      }
    }

    courses = [];
    listStatus = [];
    for (var i in listClass!) {
      var temp = await teacherRepository.getLessonResultByClassId(i.classId);
      listStatus!
          .add(temp.where((e) => e.status == 'Complete').toList().length);
      for (var j in listAllCourse) {
        if (i.courseId == j.courseId) {
          courses!.add(j);
          break;
        }
      }
    }

    emit(state + 1);
  }
}
