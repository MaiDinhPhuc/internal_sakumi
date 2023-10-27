import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/main.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/class_overview_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/grading_tab_data_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_statistic_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/list_lesson_data_model.dart';
import 'package:internal_sakumi/model/list_test_data_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/session_data_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_home_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/network_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/teacher/teacher_screen2.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_authentication.dart';
import 'firestore_db.dart';

class FireBaseProvider extends NetworkProvider {
  FireBaseProvider._privateConstructor();

  static final FireBaseProvider instance =
      FireBaseProvider._privateConstructor();

  @override
  Future<void> logInUser(
      TextEditingController email,
      TextEditingController password,
      BuildContext context,
      ErrorCubit cubit) async {
    waitingDialog(context);
    final String check = await FirebaseAuthentication.instance
        .logInUser(email.text, password.text);

    if (check == "true") {
      UserModel user = await FireBaseProvider.instance.getUser(email.text);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (user.role == "admin") {
          AdminModel adminModel =
              await FireBaseProvider.instance.getAdminById(user.id);

          sharedPreferences.setString(
              PrefKeyConfigs.code, adminModel.adminCode);
          sharedPreferences.setInt(PrefKeyConfigs.userId, adminModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, adminModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, email.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
          Navigator.pushReplacementNamed(context, Routes.admin);
        }
        if (user.role == "teacher") {
          TeacherModel teacherModel =
              await FireBaseProvider.instance.getTeacherById(user.id);
          sharedPreferences.setString(
              PrefKeyConfigs.code, teacherModel.teacherCode);
          sharedPreferences.setInt(PrefKeyConfigs.userId, teacherModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, teacherModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, email.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
          await context.read<AppBarInfoTeacherCubit>().load();
          // if (context.mounted) {
          //   BlocProvider.of<TeacherDataCubit>(context).loadClass();
          // }

          Navigator.pushReplacementNamed(context, Routes.teacher);
        }
        if (user.role == "master") {
          sharedPreferences.setInt(PrefKeyConfigs.userId, user.id);
          if (context.mounted) {
            Navigator.pop(context);
          }
          Navigator.pushReplacementNamed(context, Routes.master);
        }
        email.clear();
        password.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are Logged in ${user.role}')));
      } else {
        FirebaseAuth.instance.signOut().then((value) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You don\'t have permission to access ')));
        });
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (AppConfigs.isRunningDebug) {
        RegExp regex = RegExp(r'\((.*?)\)');

        Match? match = regex.firstMatch(check);

        if (match != null) {
          String result = match.group(1)!;
          if (result == 'auth/user-not-found') {
            cubit.changeError(AppText.txtWrongAccount.text);
          } else if (result == 'auth/wrong-password') {
            cubit.changeError(AppText.txtWrongPassword.text);
            password.clear();
          } else {
            cubit.changeError(AppText.txtInvalidLogin.text);
          }
        }
      } else {
        if (check == 'user-not-found') {
          cubit.changeError(AppText.txtWrongAccount.text);
        } else if (check == 'wrong-password') {
          cubit.changeError(AppText.txtWrongPassword.text);
          password.clear();
        } else {
          cubit.changeError(AppText.txtInvalidLogin.text);
        }
      }
    }
  }

  @override
  Future<void> logOutUser(BuildContext context) async {
    await FirebaseAuthentication.instance.logOutUser(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefKeyConfigs.code, '');
    sharedPreferences.setInt(PrefKeyConfigs.userId, -1);
    sharedPreferences.setString(PrefKeyConfigs.name, '');
    sharedPreferences.setString(PrefKeyConfigs.email, '');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Future<bool> autoLogInUser(String email, BuildContext context) async {
    try {
      UserModel user = await FireBaseProvider.instance.getUser(email);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        if (user.role == "admin") {
          Navigator.pushReplacementNamed(context, Routes.admin);
        }
        if (user.role == "teacher") {
          Navigator.pushReplacementNamed(context, Routes.teacher);
        }
        if (user.role == "master") {
          Navigator.pushReplacementNamed(context, Routes.master);
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("==========>login Error");
      return false;
    }
  }

  @override
  Future<bool> changePassword(
      String email, String oldPass, String newPass) async {
    return await FirebaseAuthentication.instance
        .changePassword(email, oldPass, newPass);
  }

  @override
  Future<String> uploadImageAndGetUrl(Uint8List data, String folder) async {
    return await FirebaseAuthentication.instance
        .uploadImageAndGetUrl(data, folder);
  }

  @override
  Future<TeacherModel> getTeacherByTeacherCode(String teacherCode) async {
    final teacher =
        (await FireStoreDb.instance.getTeacherByTeacherCode(teacherCode))
            .docs
            .map((e) => TeacherModel.fromSnapshot(e))
            .single;
    return teacher;
  }

  @override
  Future<TeacherModel> getTeacherById(int id) async {
    final teacher = (await FireStoreDb.instance.getTeacherById(id))
        .docs
        .map((e) => TeacherModel.fromSnapshot(e))
        .single;
    return teacher;
  }

  @override
  Future<List<TeacherClassModel>> getTeacherClassById(
      String string, int id) async {
    return (await FireStoreDb.instance.getTeacherClassById(string, id))
        .docs
        .map((e) => TeacherClassModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    final lessons = (await FireStoreDb.instance.getLessonsByCourseId(id))
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .toList();
    lessons.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    return lessons;
  }

  @override
  Future<List<LessonModel>> getLessonsByLessonId(List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    if (ids.length <= 10) {
      return (await FireStoreDb.instance.getLessonsByLessonId(ids))
          .docs
          .map((e) => LessonModel.fromSnapshot(e))
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<LessonModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getLessonsByLessonId(subLists[i]))
              .docs
              .map((e) => LessonModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<List<LessonModel>> getLessonsByListCourseId(List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    if (ids.length <= 10) {
      return (await FireStoreDb.instance.getLessonsByListCourseId(ids))
          .docs
          .map((e) => LessonModel.fromSnapshot(e))
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<LessonModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getLessonsByListCourseId(subLists[i]))
              .docs
              .map((e) => LessonModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<List<LessonResultModel>> getLessonsResultsByListClassIds(
      List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    if (ids.length <= 10) {
      return (await FireStoreDb.instance.getLessonsResultsByListClassIds(ids))
          .docs
          .map((e) => LessonResultModel.fromSnapshot(e))
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<LessonResultModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance
                  .getLessonsResultsByListClassIds(subLists[i]))
              .docs
              .map((e) => LessonResultModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<ClassModel> getClassById(int id) async {
    return (await FireStoreDb.instance.getClassById(id))
        .docs
        .map((e) => ClassModel.fromSnapshot(e))
        .single;
  }

  @override
  Future<CourseModel> getCourseById(int id) async {
    return (await FireStoreDb.instance.getCourseById(id))
        .docs
        .map((e) => CourseModel.fromSnapshot(e))
        .single;
  }

  @override
  Future<List<LessonResultModel>> getLessonResultByClassId(int id) async {
    return (await FireStoreDb.instance.getLessonResultByClassId(id))
        .docs
        .map((e) => LessonResultModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(
      int classId, int lessonId) async {
    return (await FireStoreDb.instance
            .getAllStudentLessonInLesson(classId, lessonId))
        .docs
        .map((e) => StudentLessonModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<LessonResultModel> getLessonResultByLessonId(
      int id, int classId) async {
    final result =
        (await FireStoreDb.instance.getLessonResultByLessonId(id, classId))
            .docs
            .map((e) => LessonResultModel.fromSnapshot(e))
            .single;
    return result;
  }

  @override
  Future<List<CourseModel>> getAllCourse() async {
    var snapshot = await FireStoreDb.instance.getAllCourse();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    final courses =
        snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    return courses;
  }

  @override
  Future<List<QuestionModel>> getQuestionByUrl(String url) async {
    return await FireStoreDb.instance.getQuestionByUrl(url);
  }

  @override
  Future<List<StudentClassModel>> getStudentClassInClass(int classId) async {
    return (await FireStoreDb.instance.getStudentClassInClass(classId))
        .docs
        .map((e) => StudentClassModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(
      int classId) async {
    return (await FireStoreDb.instance.getAllStudentLessonsInClass(classId))
        .docs
        .map((e) => StudentLessonModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<AnswerModel>> getListAnswer(int id, int classId) async {
    return (await FireStoreDb.instance.getListAnswer(id, classId))
        .docs
        .map((e) => AnswerModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<LessonModel> getLesson(int courseId, int lessonId) async {
    return (await FireStoreDb.instance.getLesson(courseId, lessonId))
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .single;
  }

  @override
  Future<void> updateTimekeeping(
      int userId, int lessonId, int classId, int attendId) async {
    await FireStoreDb.instance
        .updateTimekeeping(userId, lessonId, classId, attendId);
  }

  @override
  Future<void> updateTeacherNote(
      int userId, int lessonId, int classId, String note) async {
    await FireStoreDb.instance
        .updateTeacherNote(userId, lessonId, classId, note);
  }

  @override
  Future<void> updateStudentStatus(
      int userId, int classId, int point, String type) async {
    await FireStoreDb.instance
        .updateStudentStatus(userId, classId, point, type);
  }

  @override
  Future<void> changeStatusLesson(
      int lessonId, int classId, String status) async {
    await FireStoreDb.instance.changeStatusLesson(lessonId, classId, status);
  }

  @override
  Future<void> noteForAllStudentInClass(
      int lessonId, int classId, String note) async {
    await FireStoreDb.instance
        .noteForAllStudentInClass(lessonId, classId, note);
  }

  @override
  Future<void> updateTeacherInLessonResult(
      int lessonId, int classId, int studentId) async {
    await FireStoreDb.instance
        .updateTeacherInLessonResult(lessonId, classId, studentId);
  }

  @override
  Future<void> noteForSupport(int lessonId, int classId, String note) async {
    await FireStoreDb.instance.noteForSupport(lessonId, classId, note);
  }

  @override
  Future<void> noteForAnotherSensei(
      int lessonId, int classId, String note) async {
    await FireStoreDb.instance.noteForAnotherSensei(lessonId, classId, note);
  }

  @override
  Future<bool> addStudentLesson(StudentLessonModel model) async {
    final temp = await FireStoreDb.instance.getStudentLessonByDocs(
        "student_${model.studentId}_lesson_${model.lessonId}_class_${model.classId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addStudentLesson(model);
      return true;
    }

    return false;
  }

  @override
  Future<bool> checkLessonResult(int lessonId, int classId) async {
    DocumentSnapshot<Map<String, dynamic>> temp =
        await FireStoreDb.instance.checkLessonResult(lessonId, classId);

    if (temp.exists == false) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> addLessonResult(LessonResultModel model) async {
    var temp = await FireStoreDb.instance
        .checkLessonResult(model.lessonId, model.classId);
    if (!temp.exists) {
      await FireStoreDb.instance.addLessonResult(model);
      return true;
    }
    return false;
  }

  @override
  Future<void> updateProfileTeacher(String id, TeacherModel model) async {
    await FireStoreDb.instance.updateProfileTeacher(id, model);
  }

  @override
  Future<List<TestModel>> getListTestByCourseId(int courseId) async {
    final test = (await FireStoreDb.instance.getListTestByCourseId(courseId))
        .docs
        .map((e) => TestModel.fromSnapshot(e))
        .toList();
    test.sort((a, b) => a.id.compareTo(b.id));
    return test;
  }

  @override
  Future<List<StudentTestModel>> getAllStudentTest(int classId) async {
    return (await FireStoreDb.instance.getAllStudentTest(classId))
        .docs
        .map((e) => StudentTestModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<TestResultModel>> getListTestResult(int classId) async {
    List<TestResultModel> list =
        (await FireStoreDb.instance.getListTestResult(classId))
            .docs
            .map((e) => TestResultModel.fromSnapshot(e))
            .toList();
    list.sort((a, b) => a.testId.compareTo(b.testId));
    return list;
  }

  @override
  Future<UserModel> getUser(String email) async {
    return (await FireStoreDb.instance.getUserByEmail(email))
        .docs
        .map((e) => UserModel.fromSnapshot(e))
        .single;
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final user = (await FireStoreDb.instance.getUserById(id))
        .docs
        .map((e) => UserModel.fromSnapshot(e))
        .single;
    return user;
  }

  @override
  Future<void> saveUser(String email, String role, int uid) async {
    return await FireStoreDb.instance.saveUser(email, role, uid);
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    final lists = (await FireStoreDb.instance.getAllUser())
        .docs
        .map((e) => UserModel.fromSnapshot(e))
        .toList();
    return lists;
  }

  @override
  Future<bool> createNewStudent(StudentModel model, UserModel user) async {
    var temp = await FireStoreDb.instance.getUserByEmail(user.email);
    if (temp.docs.isEmpty) {
      await FireStoreDb.instance.createNewStudent(model, user);
      await FireBaseProvider.instance
          .saveUser(user.email, user.role, model.userId);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> createNewTeacher(TeacherModel model, UserModel user) async {
    var temp = await FireStoreDb.instance.getUserByEmail(user.email);

    if (temp.docs.isEmpty) {
      await FireStoreDb.instance.createNewTeacher(model, user);
      await FireBaseProvider.instance
          .saveUser(user.email, user.role, model.userId);
      return true;
    }

    return false;
  }

  @override
  Future<List<ClassModel>> getListClassNotRemove() async {
    final listClass = (await FireStoreDb.instance.getListClassNotRemove())
        .docs
        .map((e) => ClassModel.fromSnapshot(e))
        .toList();
    listClass.sort((a, b) => a.classId.compareTo(b.classId));
    return listClass;
  }

  @override
  Future<List<TeacherClassModel>> getAllTeacherInClass() async {
    final listSensei = (await FireStoreDb.instance.getAllTeacherInClass())
        .docs
        .map((e) => TeacherClassModel.fromSnapshot(e))
        .toList();
    return listSensei;
  }

  @override
  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(
      int classId) async {
    final listTeacher =
        (await FireStoreDb.instance.getAllTeacherInClassByClassId(classId))
            .docs
            .map((e) => TeacherClassModel.fromSnapshot(e))
            .toList();
    return listTeacher;
  }

  @override
  Future<List<StudentModel>> getAllStudent() async {
    return (await FireStoreDb.instance.getAllStudent())
        .docs
        .map((e) => StudentModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<TeacherModel>> getAllTeacher() async {
    final lists = (await FireStoreDb.instance.getAllTeacher())
        .docs
        .map((e) => TeacherModel.fromSnapshot(e))
        .toList();
    return lists;
  }

  // @override
  // Future<List<TagModel>> getTags() async {
  //   return await FireStoreDb.instance.getTags();
  // }

  @override
  Future<AdminModel> getAdminById(int id) async {
    final admin = (await FireStoreDb.instance.getAdminById(id))
        .docs
        .map((e) => AdminModel.fromSnapshot(e))
        .single;
    return admin;
  }

  @override
  Future<bool> createNewClass(ClassModel model) async {
    var temp = await FireStoreDb.instance.getClassByClassCode(model.classCode);
    if (temp.docs.isEmpty) {
      debugPrint('===============> check var ${model.classCode}');
      await FireStoreDb.instance.createNewClass(model);
      return true;
    }
    debugPrint('===============> check var 000 ${model.classCode}');
    return false;
  }

  @override
  Future<bool> addStudentToClass(StudentClassModel model) async {
    var temp = await FireStoreDb.instance
        .getStudentClassByDoc("student_${model.userId}_class_${model.classId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addStudentToClass(model);
      return true;
    }
    await FireStoreDb.instance.updateStudentToClass(model);
    return false;
  }

  @override
  Future<bool> addTeacherToClass(TeacherClassModel model) async {
    final temp = await FireStoreDb.instance.getTeacherClassByDocs(
        "teacher_${model.userId}_class_${model.classId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addTeacherToClass(model);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> changeClassStatus(ClassModel classModel, String newStatus,
      ManageGeneralCubit cubit, BuildContext context) async {
    await FireStoreDb.instance
        .changeClassStatus(classModel, newStatus, cubit, context);
  }

  @override
  Future<void> updateClassInfo(ClassModel classModel) async {
    await FireStoreDb.instance.updateClassInfo(classModel);
  }

  @override
  Future<void> updateCourseInfo(CourseModel courseModel) async {
    await FireStoreDb.instance.updateCourseInfo(courseModel);
  }

  @override
  Future<TeacherHomeClass> getDataForTeacherHomeScreen(int teacherId) async {
    final List<TeacherClassModel> listTeacherClass =
        (await FireStoreDb.instance.getTeacherClassById('user_id', teacherId))
            .docs
            .map((e) => TeacherClassModel.fromSnapshot(e))
            .toList();
    List<int> listIds = [];
    for (var i in listTeacherClass) {
      listIds.add(i.classId);
    }
    final List<ClassModel> allClassNotRemove =
        await FireBaseProvider.instance.getListClassForTeacher(listIds);
    allClassNotRemove.sort((a, b) => a.classId.compareTo(b.classId));

    final List<LessonModel> allLessonNotBTVN =
        await FireBaseProvider.instance.getListLessonNotBTVN();

    List<int> listLessonException = [];

    for (var i in allLessonNotBTVN) {
      listLessonException.add(i.lessonId);
    }

    List<int> listClassIds = [];
    List<String> listClassCodes = [];
    List<String> listClassStatus = [];
    List<int> listClassType = [];
    List<int> listCourseIds = [];
    List<String> listClassDes = [];
    List<String> listClassNote = [];
    for (var i in allClassNotRemove) {
      listClassIds.add(i.classId);
      listClassCodes.add(i.classCode);
      listClassStatus
          .add(i.classStatus == "Preparing" ? "InProgress" : i.classStatus);
      listClassType.add(i.classType);
      listCourseIds.add(i.courseId);
      listClassDes.add(i.description);
      listClassNote.add(i.note);
    }

    final List<CourseModel> listCourses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    List<String> listBigTitle = [];
    List<int> listLessonCount = [];
    List<int> listLessonAvailable = [];

    for (var i in listCourseIds) {
      for (var k in listCourses) {
        if (i == k.courseId) {
          listBigTitle.add("${k.name} ${k.level} ${k.termName}");
          listLessonCount.add(k.lessonCount);
          break;
        }
      }
    }
    List<double> rateAttendance = [];
    List<double> rateSubmit = [];
    List<List<int>> rateAttendanceChart = [];
    List<List<int>> rateSubmitChart = [];
    List<List<double>> colStd = [];
    List<StudentLessonModel> listStdLesson = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(listClassIds);
    List<StudentClassModel> listStdClass =
        await FireBaseProvider.instance.getStudentClassByListId(listClassIds);
    for (var i in listClassIds) {
      final List<StudentLessonModel> list =
          listStdLesson.where((e) => e.classId == i).toList();

      final List<StudentClassModel> listStdCol =
          listStdClass.where((element) => element.classId == i).toList();
      double col1 = 0;
      double col2 = 0;
      double col3 = 0;
      double col4 = 0;
      double col5 = 0;
      for (var j in listStdCol) {
        if (j.classStatus == "Completed" ||
            j.classStatus == "InProgress" ||
            j.classStatus == "ReNew") {
          col1++;
        }
        if (j.classStatus == "Viewer") {
          col2++;
        }
        if (j.classStatus == "UpSale" || j.classStatus == "Force") {
          col4++;
        }
        if (j.classStatus == "Moved") {
          col3++;
        }
        if (j.classStatus == "Retained" ||
            j.classStatus == "Dropped" ||
            j.classStatus == "Deposit") {
          col5++;
        }
      }

      colStd.add([col1, col2, col3, col4, col5]);

      final List<StudentClassModel> listStd = listStdClass
          .where((element) =>
              element.classId == i &&
              (element.classStatus != "Remove" &&
                  element.classStatus != "Moved" &&
                  element.classStatus != "Retained" &&
                  element.classStatus != "Dropped" &&
                  element.classStatus != "Deposit" &&
                  element.classStatus != "Viewer"))
          .toList();
      List<int> listStdId = [];
      for (var k in listStd) {
        listStdId.add(k.userId);
      }
      int temp1 = 0;
      int temp2 = 0;
      List<int> listLessonIds = [];

      final List<StudentLessonModel> listStdLessonTemp =
          list.where((e) => listStdId.contains(e.studentId)).toList();

      for (var j in listStdLessonTemp) {
        if (j.timekeeping < 5 && j.timekeeping != 0) {
          temp1++;
        }
        if (j.hw != -2 && j.timekeeping != 0) {
          temp2++;
        }
        if (!listLessonIds.contains(j.lessonId)) {
          listLessonIds.add(j.lessonId);
        }
      }
      var listTemp1 = listStdLessonTemp
          .where((element) =>
              element.timekeeping != 0 && listStdId.contains(element.studentId))
          .toList();
      var listTemp2 = listStdLessonTemp
          .where((element) =>
              element.timekeeping != 0 &&
              listStdId.contains(element.studentId) &&
              !listLessonException.contains(element.lessonId))
          .toList();
      rateAttendance.add(temp1 / (listTemp1.isNotEmpty ? listTemp1.length : 1));
      rateSubmit.add(temp2 / (listTemp2.isNotEmpty ? listTemp2.length : 1));
      listLessonAvailable.add(listLessonIds.length);

      List<int> attendances = [], submits = [];
      for (var j in listLessonIds) {
        int att = listTemp1.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == i &&
                        e.lessonId == j &&
                        e.timekeeping > 0 &&
                        e.timekeeping < 5)
                    ? 1
                    : 0));
        int sub = listTemp2.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == i && e.lessonId == j && e.hw > -2) ? 1 : 0));
        attendances.add(att);
        if (listLessonException.contains(j)) {
          submits.add(0);
        } else {
          submits.add(sub);
        }
      }
      rateAttendanceChart.add(attendances);
      rateSubmitChart.add(submits);
    }

    return TeacherHomeClass(
        listClassIds: listClassIds,
        listClassCodes: listClassCodes,
        listClassStatus: listClassStatus,
        listClassType: listClassType,
        listBigTitle: listBigTitle,
        rateAttendance: rateAttendance,
        rateSubmit: rateSubmit,
        rateAttendanceChart: rateAttendanceChart,
        rateSubmitChart: rateSubmitChart,
        listLessonCount: listLessonCount,
        listLessonAvailable: listLessonAvailable,
        listCourse: [],
        listCourseId: [],
        colStd: colStd,
        listClassDes: listClassDes,
        listClassNote: listClassNote,
        listLastLessonTitle: []);
  }

  @override
  Future<ClassOverViewModel> getDataForClassOverViewTab(int classId) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);
    List<StudentLessonModel> stdLessonsInClass =
        await FireBaseProvider.instance.getAllStudentLessonsInClass(classId);
    List<StudentClassModel> listStdClass =
        await FireBaseProvider.instance.getStudentClassInClass(classId);
    listStdClass.sort((a, b) => a.userId.compareTo(b.userId));
    List<int> listLessonId = [];
    List<int> listStudentId = [];
    for (var i in listStdClass) {
      listStudentId.add(i.userId);
    }
    for (var i in stdLessonsInClass) {
      if (!listLessonId.contains(i.lessonId)) {
        listLessonId.add(i.lessonId);
      }
    }

    List<LessonModel> lessons =
        await FireBaseProvider.instance.getLessonsByLessonId(listLessonId);

    List<LessonModel> lessonTemp =
        lessons.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }

    List<StudentModel> students =
        await FireBaseProvider.instance.getAllStudentInFoInClass(listStudentId);
    students.sort((a, b) => a.userId.compareTo(b.userId));

    List<Map<String, dynamic>> listStdDetail = [];

    List<double> listAttendance = [];
    List<double> listHomework = [];

    for (var i in listLessonId) {
      List<StudentLessonModel> stdLesson = stdLessonsInClass
          .where((element) => element.lessonId == i && element.timekeeping != 0)
          .toList();
      double tempAtt = 0;
      double tempHw = 0;
      for (var j in stdLesson) {
        if (j.timekeeping != 6 && j.timekeeping != 5) {
          tempAtt++;
        }
        if (j.hw != -2) {
          tempHw++;
        }
      }

      listAttendance.add(tempAtt);
      listHomework.add(tempHw);
    }

    int countStudent = 0;
    for (var i in listStdClass) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" &&
          i.classStatus != "Viewer") {
        countStudent++;
      }
    }

    for (var i in listStdClass) {
      List<StudentLessonModel> stdLesson = stdLessonsInClass
          .where((element) => element.studentId == i.userId)
          .toList();
      List<int> listAttendance = [];
      List<int?> listHw = [];
      List<String> title = [];
      List<String> senseiNote = [];
      List<String> spNote = [];
      for (var j in stdLesson) {
        listAttendance.add(j.timekeeping);
        if (lessonExceptionIds.contains(j.lessonId)) {
          listHw.add(null);
        } else {
          listHw.add(j.hw);
        }
        title.add(lessons
            .where((element) => element.lessonId == j.lessonId)
            .single
            .title);
        senseiNote.add(j.teacherNote);
        spNote.add(j.supportNote);
      }
      int tempAttendance = 0;
      int tempHw = 0;
      int countHw = 0;
      for (int j = 0; j < listAttendance.length; j++) {
        if (listAttendance[j] != 6 &&
            listAttendance[j] != 5 &&
            listAttendance[j] != 0) {
          tempAttendance++;
        }
        if (listAttendance[j] != 0) {
          if (listHw[j] != -2 && listHw[j] != null) {
            tempHw++;
          }
          if (listHw[j] != null) {
            countHw++;
          }
        }
      }

      int count = listAttendance.where((element) => element != 0).length;

      if (stdLesson.isEmpty) {
        listStdDetail.add({
          'status': i.classStatus,
          'attendance': listAttendance,
          'title': title,
          'hw': listHw,
          'attendancePercent': 0,
          'hwPercent': 0,
          'teacherNote': senseiNote,
          'spNote': spNote
        });
      } else {
        listStdDetail.add({
          'status': i.classStatus,
          'attendance': listAttendance,
          'title': title,
          'hw': listHw,
          'attendancePercent': tempAttendance / count,
          'hwPercent': tempHw / countHw,
          'teacherNote': senseiNote,
          'spNote': spNote
        });
      }
    }

    double temp = 0;

    for (var i in listStdDetail) {
      if (i["status"] != "Remove" &&
          i["status"] != "Dropped" &&
          i["status"] != "Deposit" &&
          i["status"] != "Retained" &&
          i["status"] != "Moved" &&
          i["status"] != "Viewer") {
        temp += i["hwPercent"];
      }
    }
    double percentHw = (temp / countStudent) * 100;
    return ClassOverViewModel(
        classModel: classModel,
        percentHw: percentHw,
        listStdClass: listStdClass,
        students: students,
        listAttendance: listAttendance,
        listHomework: listHomework,
        listStdDetail: listStdDetail);
  }

  @override
  Future<List<ClassModel2>> getClassByTeacherId(int teacherId) async {
    var teacherClassIDs =
        (await FireStoreDb.instance.getTeacherClassById('user_id', teacherId))
            .docs
            .map((e) => e.data()['class_id'] as int)
            .toList();
    var classes =
        await FireBaseProvider.instance.getListClassForTeacher(teacherClassIDs);

    List<int> listCourseIds = [];

    for (var i in classes) {
      if (listCourseIds.contains(i.courseId) == false) {
        listCourseIds.add(i.courseId);
      }
    }

    var courses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    var lessons =
        await FireBaseProvider.instance.getLessonsByListCourseId(listCourseIds);
    var stdClasses =
        await FireBaseProvider.instance.getStudentClassByListId(teacherClassIDs);
    List<LessonResultModel> lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(teacherClassIDs);
    List<StudentLessonModel> stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(teacherClassIDs);
    return ClassModel2.make(
        classes, courses, lessons, stdClasses, lessonResults, stdLessons);
  }

  @override
  Future<List<ClassModel2>> getClassByAdmin() async {
    var classes =
    await FireBaseProvider.instance.getListClassNotRemove();

    List<int> teacherClassIDs = classes.map((e) => e.classId).toList();

    List<int> listCourseIds = [];

    for (var i in classes) {
      if (listCourseIds.contains(i.courseId) == false) {
        listCourseIds.add(i.courseId);
      }
    }

    var courses =
    await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    var lessons =
    await FireBaseProvider.instance.getLessonsByListCourseId(listCourseIds);
    var stdClasses =
    await FireBaseProvider.instance.getStudentClassByListId(teacherClassIDs);
    List<LessonResultModel> lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(teacherClassIDs);
    List<StudentLessonModel> stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(teacherClassIDs);
    return ClassModel2.make(
        classes, courses, lessons, stdClasses, lessonResults, stdLessons);
  }

  @override
  Future<List<StudentModel>> getAllStudentInFoInClass(
      List<int> listStdId) async {
    if (listStdId.isEmpty) {
      return [];
    }
    if (listStdId.length <= 10) {
      return (await FireStoreDb.instance.getAllStudentInFoInClass(listStdId))
          .docs
          .map((e) => StudentModel.fromSnapshot(e))
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < listStdId.length; i += 10) {
      List<int> subList = listStdId.sublist(
          i, i + 10 > listStdId.length ? listStdId.length : i + 10);
      subLists.add(subList);
    }

    List<StudentModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getAllStudentInFoInClass(subLists[i]))
              .docs
              .map((e) => StudentModel.fromSnapshot(e))
              .toList();
    }
    return list;
  }

  @override
  Future<ListLessonDataModel> getDataForLessonTab(int classId) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);

    List<LessonModel> lessons = await FireBaseProvider.instance
        .getLessonsByCourseId(classModel.courseId);

    List<LessonModel> lessonNotBTVN =
        lessons.where((element) => element.btvn == 0).toList();

    List<int> lessonNotBTVNIds = [];
    for (var i in lessonNotBTVN) {
      lessonNotBTVNIds.add(i.lessonId);
    }

    List<LessonResultModel> listLessonResult =
        await FireBaseProvider.instance.getLessonResultByClassId(classId);
    listLessonResult.sort((a, b) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      var tempA = a.date;
      var tempB = b.date;
      if (tempA!.length == 10) {
        tempA += ' 00:00:00';
      }
      if (tempB!.length == 10) {
        tempB += ' 00:00:00';
      }
      final dateA = dateFormat.parse(tempA);
      final dateB = dateFormat.parse(tempB);
      return dateA.compareTo(dateB);
    });

    List<LessonResultModel?> listLessonResultTemp = [];

    for (var i in listLessonResult) {
      listLessonResultTemp.add(i);
    }

    while (listLessonResultTemp.length < lessons.length) {
      listLessonResultTemp.add(null);
    }
    List<String> listSpNote = [];
    List<String> listTeacherNote = [];
    List<String> listStatus = [];
    List<Map<String, dynamic>> listLessonInfo = [];
    for (int i = 0; i < listLessonResultTemp.length; i++) {
      if (listLessonResultTemp[i] != null) {
        listSpNote.add(listLessonResultTemp[i]!.noteForSupport!);
        listTeacherNote.add(listLessonResultTemp[i]!.noteForTeacher!);
        listStatus.add(listLessonResultTemp[i]!.status!);
        listLessonInfo.add({
          'id': lessons
              .firstWhere((element) =>
                  element.lessonId == listLessonResultTemp[i]!.lessonId)
              .lessonId,
          'title': lessons
              .firstWhere((element) =>
                  element.lessonId == listLessonResultTemp[i]!.lessonId)
              .title
        });
        LessonModel temp = lessons.firstWhere(
            (element) => element.lessonId == listLessonResultTemp[i]!.lessonId);
        lessons.remove(lessons.firstWhere((element) =>
            element.lessonId == listLessonResultTemp[i]!.lessonId));
        lessons.insert(i, temp);
      } else {
        listSpNote.add("");
        listTeacherNote.add("");
        listStatus.add("Pending");
        listLessonInfo
            .add({'id': lessons[i].lessonId, 'title': lessons[i].title});
      }
    }
    List<int> listTeacherId = [];
    for (var i in listLessonResult) {
      if (!listTeacherId.contains(i.teacherId)) {
        listTeacherId.add(i.teacherId);
      }
    }

    List<TeacherModel> teachers =
        await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
    List<TeacherModel?> listTeacher = [];
    for (var i in listLessonResultTemp) {
      if (i != null) {
        listTeacher.add(
            teachers.firstWhere((element) => element.userId == i.teacherId));
      } else {
        listTeacher.add(null);
      }
    }

    List<StudentClassModel> listStdClass =
        await FireBaseProvider.instance.getStudentClassInClass(classId);
    List<StudentClassModel> listStdClassTemp = listStdClass
        .where((i) =>
            i.classStatus != "Remove" &&
            i.classStatus != "Dropped" &&
            i.classStatus != "Deposit" &&
            i.classStatus != "Retained" &&
            i.classStatus != "Moved" &&
            i.classStatus == "Viewer")
        .toList();
    List<int> sdtIdsTemp = [];
    for (var i in listStdClassTemp) {
      sdtIdsTemp.add(i.userId);
    }
    List<int> studentIds = [];
    for (var i in listStdClass) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        studentIds.add(i.userId);
      }
    }

    List<StudentModel> students =
        await FireBaseProvider.instance.getAllStudentInFoInClass(studentIds);
    students.sort((a, b) => a.userId.compareTo(b.userId));
    List<String> names = [];
    for (var i in students) {
      names.add(i.name);
    }
    List<StudentLessonModel> listStdLesson =
        await FireBaseProvider.instance.getStudentLessons(classId, studentIds);
    List<double?> listAttendance = [];
    List<double?> listHw = [];
    List<bool?> listHwStatus = [];
    List<Map<String, dynamic>?> listDetailLesson = [];
    for (var i in listLessonResultTemp) {
      if (i == null) {
        listAttendance.add(null);
        listHw.add(null);
        listHwStatus.add(null);
        listDetailLesson.add(null);
      } else {
        List<StudentLessonModel> list = listStdLesson
            .where((element) => element.lessonId == i.lessonId)
            .toList();
        List<StudentLessonModel> tempList = listStdLesson
            .where((element) =>
                element.lessonId == i.lessonId &&
                element.timekeeping != 0 &&
                !sdtIdsTemp.contains(element.studentId))
            .toList();
        double tempAttendance = 0;
        double tempHw = 0;
        bool? status;
        for (var j in tempList) {
          if (j.timekeeping < 5 && j.timekeeping > 0) {
            tempAttendance++;
          }
          if (j.hw != -2) {
            tempHw++;
          }
        }

        if (tempList.isEmpty) {
          status = null;
        } else {
          int submitCount = 0;
          int checkCount = 0;
          int notSubmitCount = 0;
          for (var k in tempList) {
            if (k.hw != -2) {
              submitCount++;
            }
            if (k.hw > -1) {
              checkCount++;
            }
            if (k.hw == -2) {
              notSubmitCount++;
            }
          }
          if (checkCount == submitCount) {
            status = true;
          } else {
            status = false;
          }
          if (notSubmitCount == tempList.length) {
            status = null;
          }
        }
        List<int?> attendanceDetail = [];
        List<int?> hwDetail = [];
        List<String> noteDetail = [];
        for (var k in students) {
          bool check = false;
          for (var j in list) {
            if (k.userId == j.studentId) {
              check = true;
            }
          }
          if (check) {
            attendanceDetail.add(list
                .firstWhere((element) => element.studentId == k.userId)
                .timekeeping);
            hwDetail.add(lessonNotBTVNIds.contains(i.lessonId)
                ? null
                : list
                    .firstWhere((element) => element.studentId == k.userId)
                    .hw);
            noteDetail.add(list
                .firstWhere((element) => element.studentId == k.userId)
                .teacherNote);
          } else {
            attendanceDetail.add(null);
            hwDetail.add(lessonNotBTVNIds.contains(i.lessonId) ? null : -2);
            noteDetail.add("");
          }
        }

        listAttendance
            .add(tempAttendance / (tempList.isEmpty ? 1 : tempList.length));
        if (lessonNotBTVNIds.contains(i.lessonId)) {
          listHw.add(null);
        } else {
          listHw.add(tempHw / (tempList.isEmpty ? 1 : tempList.length));
        }

        listHwStatus.add(status);
        listDetailLesson.add({
          'names': names,
          'attendance': attendanceDetail,
          'hw': hwDetail,
          'note': noteDetail
        });
      }
    }

    return ListLessonDataModel(
        classModel: classModel,
        listAttendance: listAttendance,
        listHw: listHw,
        listTeacher: listTeacher,
        listDetailLesson: listDetailLesson,
        listSpNote: listSpNote,
        listStatus: listStatus,
        listTeacherNote: listTeacherNote,
        listHwStatus: listHwStatus,
        listLessonInfo: listLessonInfo);
  }

  @override
  Future<List<TeacherModel>> getListTeacherByListId(
      List<int> teacherIds) async {
    if (teacherIds.isEmpty) {
      return [];
    }
    return (await FireStoreDb.instance.getListTeacherByListId(teacherIds))
        .docs
        .map((e) => TeacherModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentLessonModel>> getStudentLessons(
      int classId, List<int> studentIds) async {
    if (studentIds.isEmpty) {
      return [];
    }
    if (studentIds.length <= 10) {
      return (await FireStoreDb.instance.getStudentLesson(classId, studentIds))
          .docs
          .map((e) => StudentLessonModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < studentIds.length; i += 10) {
      List<int> subList = studentIds.sublist(
          i, i + 10 > studentIds.length ? studentIds.length : i + 10);
      subLists.add(subList);
    }

    List<StudentLessonModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getStudentLesson(classId, subLists[i]))
              .docs
              .map((e) => StudentLessonModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<ListTestDataModel> getDataForTestTab(int classId) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);

    List<TestModel> listTest = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);

    List<int> listTestIds = [];
    for (var i in listTest) {
      listTestIds.add(i.id);
    }

    List<StudentTestModel> listStudentTest =
        await FireBaseProvider.instance.getListStudentTestByIDs(listTestIds);

    List<StudentTestModel> listStdTest =
        listStudentTest.where((element) => element.classId == classId).toList();
    List<List<StudentTestModel>> listTestState = [];
    for (var i in listTestIds) {
      List<StudentTestModel> listTemp =
          listStdTest.where((element) => element.testID == i).toList();
      listTestState.add(listTemp);
    }
    List<StudentClassModel> listStudentClass =
        await FireBaseProvider.instance.getStudentClassInClass(classId);
    List<int> listStudentIds = [];
    for (var element in listStudentClass) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStudentIds.add(element.userId);
      }
    }

    List<StudentModel> listStudents = await FireBaseProvider.instance
        .getAllStudentInFoInClass(listStudentIds);

    List<double> listSubmit = [];
    List<double> listGPA = [];
    for (var i in listTestState) {
      int temp = 0;
      int sum = 0;
      int count = 0;
      if (i.isNotEmpty) {
        for (var j in i) {
          if (j.score > -2) {
            temp++;
            if (j.score > -1) {
              sum = sum + j.score;
              count++;
            }
          }
        }
      }
      listSubmit.add(temp / listStudents.length);
      listGPA.add(sum / (count == 0 ? 1 : count));
    }
    List<TestResultModel> listTestResult =
        await FireBaseProvider.instance.getListTestResult(classId);

    return ListTestDataModel(
        listTest: listTest,
        listTestState: listTestState,
        classModel: classModel,
        listTestResult: listTestResult,
        listSubmit: listSubmit,
        listGPA: listGPA,
        listStudents: listStudents);
  }

  @override
  Future<List<StudentTestModel>> getListStudentTestByIDs(
      List<int> listTestIds) async {
    if (listTestIds.isEmpty) {
      return [];
    }
    if (listTestIds.length <= 10) {
      return (await FireStoreDb.instance.getStudentTestByIds(listTestIds))
          .docs
          .map((e) => StudentTestModel.fromSnapshot(e))
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < listTestIds.length; i += 10) {
      List<int> subList = listTestIds.sublist(
          i, i + 10 > listTestIds.length ? listTestIds.length : i + 10);
      subLists.add(subList);
    }

    List<StudentTestModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getStudentTestByIds(subLists[i]))
              .docs
              .map((e) => StudentTestModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<GradingTabDataModel> getDataForGradingTab(int classId) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);
    List<LessonResultModel> listLessonResult =
        await FireBaseProvider.instance.getLessonResultByClassId(classId);
    List<LessonModel> lessons = await FireBaseProvider.instance
        .getLessonsByCourseId(classModel.courseId);
    List<StudentLessonModel> listStudentLessons =
        await FireBaseProvider.instance.getAllStudentLessonsInClass(classId);
    List<TestModel> tests = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);
    List<TestResultModel> listTestResult =
        await FireBaseProvider.instance.getListTestResult(classId);
    List<StudentTestModel> listStudentTests =
        await FireBaseProvider.instance.getAllStudentTest(classId);
    return GradingTabDataModel(
        classModel: classModel,
        lessons: lessons,
        listStudentLessons: listStudentLessons,
        listLessonResult: listLessonResult,
        listTestResult: listTestResult,
        listStudentTests: listStudentTests,
        tests: tests);
  }

  @override
  Future<List<CourseModel>> getCourseByListId(List<int> listCourseIds) async {
    if (listCourseIds.isEmpty) {
      return [];
    }
    if (listCourseIds.length <= 10) {
      return (await FireStoreDb.instance.getCourseByListId(listCourseIds))
          .docs
          .map((e) => CourseModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < listCourseIds.length; i += 10) {
      List<int> subList = listCourseIds.sublist(
          i, i + 10 > listCourseIds.length ? listCourseIds.length : i + 10);
      subLists.add(subList);
    }

    List<CourseModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getCourseByListId(subLists[i]))
              .docs
              .map((e) => CourseModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessonsInListClassId(
      List<int> listClassId) async {
    if (listClassId.isEmpty) {
      return [];
    }
    if (listClassId.length <= 10) {
      return (await FireStoreDb.instance
              .getAllStudentLessonsInListClassId(listClassId))
          .docs
          .map((e) => StudentLessonModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < listClassId.length; i += 10) {
      List<int> subList = listClassId.sublist(
          i, i + 10 > listClassId.length ? listClassId.length : i + 10);
      subLists.add(subList);
    }

    List<StudentLessonModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance
                  .getAllStudentLessonsInListClassId(subLists[i]))
              .docs
              .map((e) => StudentLessonModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<SessionDataModel> getDataForSessionCubit(
      int classId, int lessonId) async {
    List<StudentClassModel> listStudentClass =
        await FireBaseProvider.instance.getStudentClassInClass(classId);
    List<int> listStudentId = [];
    for (var i in listStudentClass) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        listStudentId.add(i.userId);
      }
    }

    List<StudentModel> listStudent =
        await FireBaseProvider.instance.getAllStudentInFoInClass(listStudentId);

    List<StudentLessonModel> listStudentLesson = await FireBaseProvider.instance
        .getAllStudentLessonInLesson(classId, lessonId);

    return SessionDataModel(
        listStudent: listStudent,
        listStudentLesson: listStudentLesson,
        listStudentClass: listStudentClass);
  }

  @override
  Future<DetailGradingDataModel> getDataForDetailGrading(
      int classId, int lessonId, String type) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);
    CourseModel courseModel =
        await FireBaseProvider.instance.getCourseById(classModel.courseId);
    String token = courseModel.token;
    List<QuestionModel> listQuestions = [];
    if (type == "type=test") {
      listQuestions = await FireBaseProvider.instance.getQuestionByUrl(
          AppConfigs.getDataUrl("test_$lessonId.json", token));
    } else {
      listQuestions = await FireBaseProvider.instance.getQuestionByUrl(
          AppConfigs.getDataUrl("btvn_$lessonId.json", token));
    }
    List<AnswerModel> listAnswer =
        await FireBaseProvider.instance.getListAnswer(lessonId, classId);

    if (listAnswer.isEmpty) {
      return DetailGradingDataModel(
          classModel: classModel,
          listQuestions: listQuestions,
          listAnswer: listAnswer,
          listStudent: [],
          courseModel: courseModel,
          listStudentId: [],
          listState: []);
    }

    List<StudentClassModel> listStudentClass =
        await FireBaseProvider.instance.getStudentClassInClass(classId);

    List<int> listStudentId = [];

    for (var j in listStudentClass) {
      for (var i in listAnswer) {
        if (j.userId == i.studentId &&
            j.classStatus != "Remove" &&
            j.classStatus != "Dropped") {
          listStudentId.add(j.userId);
          break;
        }
      }
    }

    List<StudentModel> listStudent =
        await FireBaseProvider.instance.getAllStudentInFoInClass(listStudentId);

    return DetailGradingDataModel(
        classModel: classModel,
        listQuestions: listQuestions,
        listAnswer: listAnswer,
        listStudent: listStudent,
        courseModel: courseModel,
        listStudentId: listStudentId,
        listState: []);
  }

  @override
  Future<List<StudentModel>> get10Student(int lastId) async {
    return (await FireStoreDb.instance.get10Student(lastId))
        .docs
        .map((e) => StudentModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentModel>> get10StudentFirst() async {
    return (await FireStoreDb.instance.get10StudentFirst())
        .docs
        .map((e) => StudentModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<int> getTotalPage(String tableName) async {
    int count = (await FireStoreDb.instance.getCount(tableName)).count;

    if (count <= 10) {
      return 1;
    }

    int length = count ~/ 10;

    int check = count % 10;

    if (check != 0) {
      length++;
    }

    return length;
  }

  @override
  Future<int> getCountWithCondition(
      String tableName, String field, dynamic condition) async {
    int count = (await FireStoreDb.instance
            .getCountWithCondition(tableName, field, condition))
        .count;
    return count;
  }

  @override
  Future<TeacherHomeClass> getDataForManageClassTab() async {
    final List<ClassModel> allClassNotRemove =
        (await FireStoreDb.instance.getListClassNotRemove())
            .docs
            .map((e) => ClassModel.fromSnapshot(e))
            .toList();
    allClassNotRemove.sort((a, b) => a.classId.compareTo(b.classId));

    final List<LessonModel> allLessonNotBTVN =
        await FireBaseProvider.instance.getListLessonNotBTVN();

    List<int> listLessonException = [];

    for (var i in allLessonNotBTVN) {
      listLessonException.add(i.lessonId);
    }

    final List<CourseModel> listAllCourse =
        await FireBaseProvider.instance.getAllCourse();

    // final List<CourseModel> listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    // List<int> courseIdsTemp = [];
    // for(var i in listAllCourse){
    //   courseIdsTemp.add(i.courseId);
    // }
    // List<ClassModel> listClassEnable = [];
    // for(var i in allClassNotRemove){
    //   if(courseIdsTemp.contains(i.courseId)){
    //     listClassEnable.add(i);
    //   }
    // }

    List<int> listClassIds = [];
    List<String> listClassCodes = [];
    List<String> listClassStatus = [];
    List<int> listClassType = [];
    List<int> courseIds = [];
    List<String> listClassDes = [];
    List<String> listClassNote = [];
    for (var i in allClassNotRemove) {
      listClassIds.add(i.classId);
      listClassCodes.add(i.classCode);
      listClassStatus.add(i.classStatus);
      listClassType.add(i.classType);
      courseIds.add(i.courseId);
      listClassDes.add(i.description);
      listClassNote.add(i.note);
    }

    List<String> listBigTitle = [];
    List<int> listLessonCount = [];
    List<int> listLessonAvailable = [];
    for (var i in courseIds) {
      for (var k in listAllCourse) {
        if (i == k.courseId) {
          listBigTitle.add("${k.name} ${k.level} ${k.termName}");
          listLessonCount.add(k.lessonCount);
          break;
        }
      }
    }
    List<double> rateAttendance = [];
    List<double> rateSubmit = [];
    List<List<int>> rateAttendanceChart = [];
    List<List<int>> rateSubmitChart = [];
    List<List<double>> colStd = [];
    List<StudentLessonModel> listStdLesson = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(listClassIds);
    List<StudentClassModel> listStdClass =
        await FireBaseProvider.instance.getStudentClassByListId(listClassIds);
    for (var i in listClassIds) {
      final List<StudentLessonModel> list =
          listStdLesson.where((e) => e.classId == i).toList();

      final List<StudentClassModel> listStdCol =
          listStdClass.where((element) => element.classId == i).toList();
      double col1 = 0;
      double col2 = 0;
      double col3 = 0;
      double col4 = 0;
      double col5 = 0;
      for (var j in listStdCol) {
        if (j.classStatus == "Completed" ||
            j.classStatus == "InProgress" ||
            j.classStatus == "ReNew") {
          col1++;
        }
        if (j.classStatus == "Viewer") {
          col2++;
        }
        if (j.classStatus == "UpSale" || j.classStatus == "Force") {
          col4++;
        }
        if (j.classStatus == "Moved") {
          col3++;
        }
        if (j.classStatus == "Retained" ||
            j.classStatus == "Dropped" ||
            j.classStatus == "Deposit") {
          col5++;
        }
      }

      colStd.add([col1, col2, col3, col4, col5]);

      final List<StudentClassModel> listStd = listStdClass
          .where((element) =>
              element.classId == i &&
              (element.classStatus != "Remove" &&
                  element.classStatus != "Moved" &&
                  element.classStatus != "Retained" &&
                  element.classStatus != "Dropped" &&
                  element.classStatus != "Deposit" &&
                  element.classStatus != "Viewer"))
          .toList();
      List<int> listStdId = [];
      for (var k in listStd) {
        listStdId.add(k.userId);
      }
      int temp1 = 0;
      int temp2 = 0;
      List<int> listLessonIds = [];

      final List<StudentLessonModel> listStdLessonTemp =
          list.where((e) => listStdId.contains(e.studentId)).toList();

      for (var j in listStdLessonTemp) {
        if (j.timekeeping < 5 && j.timekeeping != 0) {
          temp1++;
        }
        if (j.hw != -2 && j.timekeeping != 0) {
          temp2++;
        }
        if (!listLessonIds.contains(j.lessonId)) {
          listLessonIds.add(j.lessonId);
        }
      }
      var listTemp1 = listStdLessonTemp
          .where((element) =>
              element.timekeeping != 0 && listStdId.contains(element.studentId))
          .toList();
      var listTemp2 = listStdLessonTemp
          .where((element) =>
              element.timekeeping != 0 &&
              listStdId.contains(element.studentId) &&
              !listLessonException.contains(element.lessonId))
          .toList();
      rateAttendance.add(temp1 / (listTemp1.isNotEmpty ? listTemp1.length : 1));
      rateSubmit.add(temp2 / (listTemp2.isNotEmpty ? listTemp2.length : 1));
      listLessonAvailable.add(listLessonIds.length);

      List<int> attendances = [], submits = [];
      for (var j in listLessonIds) {
        int att = listTemp1.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == i &&
                        e.lessonId == j &&
                        e.timekeeping > 0 &&
                        e.timekeeping < 5)
                    ? 1
                    : 0));
        int sub = listTemp2.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == i && e.lessonId == j && e.hw > -2) ? 1 : 0));
        attendances.add(att);
        if (listLessonException.contains(j)) {
          submits.add(0);
        } else {
          submits.add(sub);
        }
      }
      rateAttendanceChart.add(attendances);
      rateSubmitChart.add(submits);
    }

    return TeacherHomeClass(
        listClassIds: listClassIds,
        listClassCodes: listClassCodes,
        listClassStatus: listClassStatus,
        listClassType: listClassType,
        listBigTitle: listBigTitle,
        rateAttendance: rateAttendance,
        rateSubmit: rateSubmit,
        rateAttendanceChart: rateAttendanceChart,
        rateSubmitChart: rateSubmitChart,
        listLessonCount: listLessonCount,
        listLessonAvailable: listLessonAvailable,
        listCourse: listAllCourse,
        listCourseId: courseIds,
        colStd: colStd,
        listClassDes: listClassDes,
        listClassNote: listClassNote,
        listLastLessonTitle: []);
  }

  @override
  Future<List<CourseModel>> getAllCourseEnable() async {
    var snapshot = await FireStoreDb.instance.getAllCourseEnable();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    final courses =
        snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    return courses;
  }

  @override
  Future<bool> addNewCourse(CourseModel model) async {
    final temp =
        await FireStoreDb.instance.getCourseByDocs("course_${model.courseId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addCourse(model);
      return true;
    }
    return false;
  }

  @override
  Future<void> updateCourseState(CourseModel courseModel, bool state) async {
    await FireStoreDb.instance.updateCourseState(courseModel, state);
  }

  @override
  Future<void> addCourseFromJson(String jsonData) async {
    final data = json.decode(jsonData);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    for (final temp in data) {
      try {
        await db
            .collection('courses')
            .doc('course_${temp['course_id']}')
            .set(temp);
      } catch (e) {
        debugPrint('=>>>>>error: $e');
      }
    }
  }

  @override
  Future<void> addLessonFromJson(String jsonData) async {
    final data = json.decode(jsonData);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    for (final temp in data) {
      try {
        await db
            .collection('lessons')
            .doc('lesson_${temp['lesson_id']}_course_${temp['course_id']}')
            .set(temp);
      } catch (e) {
        debugPrint('=>>>>>error: $e');
      }
    }
  }

  @override
  Future<void> addTestFromJson(String jsonData) async {
    final data = json.decode(jsonData);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    for (final temp in data) {
      try {
        await db
            .collection('test')
            .doc('test_${temp['id']}_course_${temp['course_id']}')
            .set(temp);
      } catch (e) {
        debugPrint('=>>>>>error: $e');
      }
    }
  }

  @override
  Future<List<StudentClassModel>> getStudentClassByListId(List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    if (ids.length <= 10) {
      return (await FireStoreDb.instance.getAllStudentClassByListIds(ids))
          .docs
          .map((e) => StudentClassModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<StudentClassModel> list = [];
    for (int i = 0; i < subLists.length; i++) {
      list = list +
          (await FireStoreDb.instance.getAllStudentClassByListIds(subLists[i]))
              .docs
              .map((e) => StudentClassModel.fromSnapshot(e))
              .toList();
    }

    return list;
  }

  @override
  Future<List<ClassModel>> getListClassForTeacher(List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    if (ids.length <= 10) {
      return (await FireStoreDb.instance.getListClassAvailableForTeacher(ids))
          .docs
          .map((e) => ClassModel.fromSnapshot(e))
          .toList();
    }
    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<ClassModel> temp = [];
    for (int i = 0; i < subLists.length; i++) {
      temp = temp +
          (await FireStoreDb.instance
                  .getListClassAvailableForTeacher(subLists[i]))
              .docs
              .map((e) => ClassModel.fromSnapshot(e))
              .toList();
    }
    List<ClassModel> list = [];
    for (var i in temp) {
      if (i.classStatus == "InProgress" ||
          i.classStatus == "Completed" ||
          i.classStatus == "Preparing") {
        list.add(i);
      }
    }

    return list;
  }

  @override
  Future<List<LessonModel>> getListLessonNotBTVN() async {
    final listLesson = (await FireStoreDb.instance.getAllLessonNotBTVN())
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .toList();
    return listLesson;
  }

}
