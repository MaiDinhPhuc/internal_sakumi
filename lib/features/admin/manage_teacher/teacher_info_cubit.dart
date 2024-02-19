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
  List<CourseModel> courses = [];
  List<StudentLessonModel>? stdLessons;
  List<LessonResultModel>? lessonResults;
  List<StudentClassModel>? stdClasses;
  List<int> listCourseIds = [];
  bool isLoading = true;

  String name = "";
  String teacherCode = "";
  String phone = "";
  String note = "";

  loadTeacher(int teacherId) async {
    await DataProvider.teacherById(teacherId, loadStudentInfo);
    await DataProvider.userById(teacherId, loadUserInfo);

    name = teacher!.name;
    teacherCode = teacher!.teacherCode;
    phone = teacher!.phone;
    note = teacher!.note;
    emit(state + 1);
    loadInFoTeacherInSystem(teacherId);
  }

  loadStudentInfo(Object teacher) {
    this.teacher = teacher as TeacherModel;
  }

  loadUserInfo(Object user) {
    this.user = user as UserModel;
  }

  onCourseLoaded(Object course) {
    courses.add(course as CourseModel);
    if (courses.length == listCourseIds.length) {
      emit(state + 1);
    }
  }

  loadInFoTeacherInSystem(int teacherId) async {
    teacherClasses =
        await FireBaseProvider.instance.getTeacherClassById(teacherId);
    var listClassId = teacherClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassByListIdV2(listClassId);
    for (var i in classes!) {
      if (listCourseIds.contains(i.courseId) == false) {
        DataProvider.courseById(i.courseId, onCourseLoaded);
        listCourseIds.add(i.courseId);
      }
    }

    stdClasses =
        await FireBaseProvider.instance.getStudentClassByListId(listClassId);
    stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(listClassId);
    lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(listClassId);

    isLoading = false;
    emit(state + 1);
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
