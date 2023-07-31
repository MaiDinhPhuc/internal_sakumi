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
  List<int>? listStatus, listStudentInClass;
  List<List<int>?>? listSubmit, listAttendance;
  List<double>? listPoint;

  void init(context) {
    loadProfileTeacher(context);
    loadListClassOfTeacher(context);
  }

  void loadProfileTeacher(context) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    teacherProfile = await teacherRepository
        .getTeacher(localData.getString(PrefKeyConfigs.code)!);
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

    listTeacherClass = await teacherRepository.getTeacherClassById(
        'user_id', localData.getInt(PrefKeyConfigs.userId)!);

    listAllCourse = await teacherRepository.getAllCourse();

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

  loadStatisticClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    var listAllStudentLessons = await teacherRepository.getAllStudentLessons();

    listSubmit = [];
    listAttendance = [];
    listStudentInClass = [];
    listPoint = [];
    for (var i in listClass!) {
      var sc = await adminRepository.getStudentClassByClassId(i.classId);
      listStudentInClass!.add(sc.length);
      List<int> attends = [];
      List<int> homeworks = [];
      for (var j = 1; j <= courses!.first.lessonCount; j++) {
        var attendance = listAllStudentLessons
            .where((sl) => sl.lessonId == j)
            .fold(
                0,
                (pre, e) =>
                    pre + ((e.timekeeping > 0 && e.timekeeping < 5) ? 1 : 0));

        var hw = listAllStudentLessons
            .where((sl) => sl.lessonId == j)
            .fold(0, (pre, e) => pre + ((e.hw > -2) ? 1 : 0));

        var point = listAllStudentLessons
            .where((sl) => sl.lessonId == j)
            .fold(0, (pre, e) => pre + ((e.hw > -1) ? e.hw : 0));

        attends.add(attendance);
        homeworks.add(hw);

        listPoint!.add(point / listStudentInClass!.length / 10);
      }
      listAttendance!.add(attends);
      listSubmit!.add(homeworks);
    }
    print('==========><========== $listAttendance === $listSubmit');
    emit(state + 1);
  }
}
