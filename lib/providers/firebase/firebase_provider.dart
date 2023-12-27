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
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/model/voucher_model.dart';
import 'package:internal_sakumi/providers/network_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
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
          sharedPreferences.setString(PrefKeyConfigs.role, "admin");
          if (context.mounted) {
            Navigator.pop(context);
            // var logoutYet =
            //     sharedPreferences.getString(PrefKeyConfigs.logoutYet);
            // if (logoutYet == "true") {
            //   BlocProvider.of<DataCubit>(context).loadClass();
            // }
            Navigator.pushReplacementNamed(
                context, '${Routes.admin}/searchGeneral');
          }
        }
        if (user.role == "teacher") {
          debugPrint("============> getTeacherById 1");
          TeacherModel teacherModel =
              await FireBaseProvider.instance.getTeacherById(user.id);
          sharedPreferences.setString(
              PrefKeyConfigs.code, teacherModel.teacherCode);
          sharedPreferences.setInt(PrefKeyConfigs.userId, teacherModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, teacherModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, email.text);
          sharedPreferences.setString(PrefKeyConfigs.role, "teacher");
          if (context.mounted) {
            Navigator.pop(context);
            // var logoutYet =
            //     sharedPreferences.getString(PrefKeyConfigs.logoutYet);
            // if (logoutYet == "true") {
            //   BlocProvider.of<DataCubit>(context).loadClass();
            // }
            await context.read<AppBarInfoTeacherCubit>().load();
          }

          Navigator.pushReplacementNamed(context, Routes.teacher);
        }
        if (user.role == "master") {
          sharedPreferences.setInt(PrefKeyConfigs.userId, user.id);
          sharedPreferences.setString(PrefKeyConfigs.email, email.text);
          sharedPreferences.setString(PrefKeyConfigs.role, "master");
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '${Routes.master}/manageCourse');
          }
        }
        email.clear();
        password.clear();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('You are Logged in ${user.role}')));
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
    sharedPreferences.setString(PrefKeyConfigs.role, '');
    sharedPreferences.setString(PrefKeyConfigs.logoutYet, 'true');
    BlocProvider.of<DataCubit>(context).changeNull();
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
          Navigator.pushReplacementNamed(
              context, '${Routes.admin}/searchGeneral');
        }
        if (user.role == "teacher") {
          Navigator.pushReplacementNamed(context, Routes.teacher);
        }
        if (user.role == "master") {
          Navigator.pushReplacementNamed(context, '${Routes.master}/manageCourse');
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
  Future<TeacherModel> getTeacherById(int id) async {
    final teacher = (await FireStoreDb.instance.getTeacherById(id))
        .docs
        .map((e) => TeacherModel.fromSnapshot(e))
        .single;
    return teacher;
  }

  @override
  Future<List<TeacherClassModel>> getTeacherClassById(int id) async {
    return (await FireStoreDb.instance.getTeacherClassById(id))
        .docs
        .map((e) => TeacherClassModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    final lessons = (await FireStoreDb.instance.getLessonsByCourseId(id))
        .docs
        .map((e) => LessonModel.fromSnapshot(e))
        .toList()
        .where((e) => e.enable == true)
        .toList();
    if(lessons.every((e) => e.order == 0) == false){
      lessons.sort((a, b) => a.order.compareTo(b.order));
    }else{
      lessons.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    }

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
          .toList()
          .where((e) => e.enable == true)
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<LessonModel> list = [];

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getLessonsByLessonId(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs
                  .map((e) => LessonModel.fromSnapshot(e))
                  .toList()
                  .where((e) => e.enable == true)
                  .toList()
            ]);
    if(list.every((e) => e.order == 0) == false){
      list.sort((a, b) => a.order.compareTo(b.order));
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
          .toList()
          .where((e) => e.enable == true)
          .toList();
    }

    List<List<int>> subLists = [];
    for (int i = 0; i < ids.length; i += 10) {
      List<int> subList =
          ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      subLists.add(subList);
    }

    List<LessonModel> list = [];

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getLessonsByListCourseId(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs
                  .map((e) => LessonModel.fromSnapshot(e))
                  .toList()
                  .where((e) => e.enable == true)
                  .toList()
            ]);
    if(list.every((e) => e.order == 0) == false){
      list.sort((a, b) => a.order.compareTo(b.order));
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(
          FireStoreDb.instance.getLessonsResultsByListClassIds(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => LessonResultModel.fromSnapshot(e)).toList()
            ]);

    list.sort((a, b) {
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
    var lesResults = (await FireStoreDb.instance.getLessonResultByClassId(id))
        .docs
        .map((e) => LessonResultModel.fromSnapshot(e))
        .toList();
    lesResults.sort((a, b) {
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
    return lesResults;
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
  Future<List<SurveyModel>> getAllSurvey() async {
    return (await FireStoreDb.instance
        .getAllSurvey())
        .docs
        .map((e) => SurveyModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentLessonModel>> getStudentLessonByStdId(
      int studentId) async {
    return (await FireStoreDb.instance.getStudentLessonByStdId(studentId))
        .docs
        .map((e) => StudentLessonModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<StudentTestModel>> getAllStudentTestInLesson(
      int classId, int testId) async {
    return (await FireStoreDb.instance
            .getAllStudentTestInLesson(classId, testId))
        .docs
        .map((e) => StudentTestModel.fromSnapshot(e))
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
  Future<List<StudentClassModel>> getStudentClassByStdId(int studentId) async {
    return (await FireStoreDb.instance.getStudentClassByStdId(studentId))
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
  Future<void> updateProfileStudent(String id, StudentModel model) async {
    await FireStoreDb.instance.updateProfileStudent(id, model);
  }

  @override
  Future<List<TestModel>> getListTestByCourseId(int courseId) async {
    final test = (await FireStoreDb.instance.getListTestByCourseId(courseId))
        .docs
        .map((e) => TestModel.fromSnapshot(e))
        .toList()
        .where((e) => e.enable == true)
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
  Future<List<StudentTestModel>> getStudentTestByStdId(int studentId) async {
    return (await FireStoreDb.instance.getStudentTestByStdId(studentId))
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
  Future<List<ClassModel>> getListClassForAdmin() async {
    final listClass = (await FireStoreDb.instance.getListClassForAdmin())
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
  Future<bool> addSurveyToClass(SurveyModel model, int classId, int id) async {
    var temp = await FireStoreDb.instance
        .getSurveyResultByDoc("class_${classId}_survey_${model.id}");
    if (!temp.exists) {
      await FireStoreDb.instance.addSurveyToClass(model, classId, id);
      return true;
    }
    await FireStoreDb.instance.updateSurveyToClass(model, classId);
    return false;
  }
  @override
  Future<void> assignSurveyResult(SurveyResultModel result)async{
    await FireStoreDb.instance.assignSurveyResult(result);
  }

  @override
  Future<bool> addTeacherToClass(TeacherClassModel model) async {
    final temp = await FireStoreDb.instance.getTeacherClassByDocs(
        "teacher_${model.userId}_class_${model.classId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addTeacherToClass(model);
      return true;
    } else {
      await FireStoreDb.instance.updateTeacherInClass(model);
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
  Future<void> updateLessonResult(
      int lessonId, int classId, String note) async {
    await FireStoreDb.instance
        .updateNoteInLessonResult(lessonId, classId, note);
  }

  @override
  Future<void> updateCourseInfo(CourseModel courseModel) async {
    await FireStoreDb.instance.updateCourseInfo(courseModel);
  }

  @override
  Future<void> updateLessonInfo(LessonModel lessonModel) async {
    await FireStoreDb.instance.updateLessonInfo(lessonModel);
  }

  @override
  Future<void> updateTestInfo(TestModel testModel) async {
    await FireStoreDb.instance.updateTestInfo(testModel);
  }

  @override
  Future<List<ClassModel2>> getClassByTeacherId(
      int teacherId, List<ClassModel>? listClasses) async {
    var teacherClassIDs =
        (await FireStoreDb.instance.getTeacherClassById(teacherId))
            .docs
            .map((e) => e.data()['class_id'] as int)
            .toList();
    if (listClasses != null) {
      var classes = listClasses
          .where((e) => teacherClassIDs.contains(e.classId))
          .toList()
          .where((e) =>
              e.classStatus == "Preparing" || e.classStatus == "InProgress")
          .toList();
      return ClassModel2.loadClass(classes);
    }
    var classes = (await FireBaseProvider.instance
            .getListClassForTeacher(teacherClassIDs))
        .where((e) =>
            e.classStatus == "Preparing" || e.classStatus == "InProgress")
        .toList();
    return ClassModel2.loadClass(classes);
  }

  @override
  Future<List<ClassModel2>> getClassByAdmin(
      List<ClassModel>? listClasses) async {
    if (listClasses != null) {
      var classes = listClasses
          .where(
              (e) => !["Remove", "Completed", "Cancel"].contains(e.classStatus))
          .toList();
      return ClassModel2.loadClass(classes);
    }
    var classes = await FireBaseProvider.instance.getListClassForAdmin();
    return ClassModel2.loadClass(classes);
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getAllStudentInFoInClass(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => StudentModel.fromSnapshot(e)).toList()
            ]);

    return list;
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getStudentLesson(classId, subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs
                  .map((e) => StudentLessonModel.fromSnapshot(e))
                  .toList()
            ]);

    return list;
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getStudentTestByIds(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => StudentTestModel.fromSnapshot(e)).toList()
            ]);

    return list;
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getCourseByListId(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => CourseModel.fromSnapshot(e)).toList()
            ]);

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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(
          FireStoreDb.instance.getAllStudentLessonsInListClassId(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs
                  .map((e) => StudentLessonModel.fromSnapshot(e))
                  .toList()
            ]);

    return list;
  }

  @override
  Future<DetailGradingDataModel> getDataForDetailGrading(
      int classId, int parentId, String type) async {
    ClassModel classModel =
        await FireBaseProvider.instance.getClassById(classId);
    CourseModel courseModel =
        await FireBaseProvider.instance.getCourseById(classModel.courseId);
    String token = courseModel.token;
    List<QuestionModel> listQuestions = [];
    if (type == "type=test") {
      listQuestions = await FireBaseProvider.instance.getQuestionByUrl(
          AppConfigs.getDataUrl("test_$parentId.json", token));
    } else {
      listQuestions = await FireBaseProvider.instance.getQuestionByUrl(
          AppConfigs.getDataUrl("btvn_$parentId.json", token));
    }
    List<String> listStatus = [
      "Remove",
      "Dropped",
      "Deposit",
      "Retained",
      "Moved"
    ];
    var listStdClass =
        (await FireBaseProvider.instance.getStudentClassInClass(classId))
            .where((e) => !listStatus.contains(e.classStatus))
            .toList();
    List<int> listStdId = [];
    if (type != "type=test") {
      var listStdLesson = (await FireBaseProvider.instance
              .getAllStudentLessonInLesson(classId, parentId))
          .where((e) => e.hw != -2)
          .toList();
      var listTemp1 = listStdClass.map((e) => e.userId).toList();
      var listTemp2 = listStdLesson.map((e) => e.studentId).toList();
      for (int element in listTemp1) {
        if (listTemp2.contains(element)) {
          listStdId.add(element);
        }
      }
    } else {
      var listStdTest = (await FireBaseProvider.instance
              .getAllStudentTestInLesson(classId, parentId))
          .where((e) => e.score != -2)
          .toList();
      var listTemp1 = listStdClass.map((e) => e.userId).toList();
      var listTemp2 = listStdTest.map((e) => e.studentId).toList();
      for (int element in listTemp1) {
        if (listTemp2.contains(element)) {
          listStdId.add(element);
        }
      }
    }

    List<AnswerModel> listAnswer =
        (await FireBaseProvider.instance.getListAnswer(parentId, classId))
            .where((e) => listStdId.contains(e.studentId))
            .toList();

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

    List<int> listStudentId = [];

    for (var j in listStdClass) {
      for (var i in listAnswer) {
        if (j.userId == i.studentId) {
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
  Future<StudentModel> getStudentById(int studentId) async {
    return (await FireStoreDb.instance.getStudentById(studentId))
        .docs
        .map((e) => StudentModel.fromSnapshot(e))
        .single;
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
  Future<bool> addNewLesson(LessonModel model) async {
    final temp = await FireStoreDb.instance
        .getLessonByDocs("lesson_${model.lessonId}_course_${model.courseId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addLesson(model);
      return true;
    }
    return false;
  }

  @override
  Future<bool> addNewTest(TestModel model) async {
    final temp = await FireStoreDb.instance
        .getTestByDocs("test_${model.id}_course_${model.courseId}");
    if (!temp.exists) {
      await FireStoreDb.instance.addTest(model);
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteLesson(int lessonId, int courseId) async {
    await FireStoreDb.instance
        .deleteLessonByDocs("lesson_${lessonId}_course_$courseId");
  }

  @override
  Future<void> deleteTest(int testId, int courseId) async {
    await FireStoreDb.instance
        .deleteTestByDocs("test_${testId}_course_$courseId");
  }

  @override
  Future<void> deleteSurvey(int id) async {
    await FireStoreDb.instance
        .deleteSurveyByDocs("survey_$id");
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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(FireStoreDb.instance.getAllStudentClassByListIds(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    list = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList()
            ]);

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

    List<Future<QuerySnapshot<Map<String, dynamic>>>> tempX = [];

    for (int i = 0; i < subLists.length; i++) {
      tempX.add(
          FireStoreDb.instance.getListClassAvailableForTeacher(subLists[i]));
    }
    List<QuerySnapshot<Map<String, dynamic>>> responses =
        await Future.wait(tempX);

    temp = responses.fold(
        [],
        (pre, res) => [
              ...pre,
              ...res.docs.map((e) => ClassModel.fromSnapshot(e)).toList()
            ]);

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
        .toList()
        .where((e) => e.enable == true)
        .toList();
    if(listLesson.every((e) => e.order == 0) == false){
      listLesson.sort((a, b) => a.order.compareTo(b.order));
    }
    return listLesson;
  }

  @override
  Future<List<FeedBackModel>> getListFeedBack(String status) async {
    final listFeedBack = (await FireStoreDb.instance.getListFeedBack(status))
        .docs
        .map((e) => FeedBackModel.fromSnapshot(e))
        .toList();
    return listFeedBack;
  }

  @override
  Future<VoucherModel> getVoucherByVoucherCode(String code) async {
    final res = (await FireStoreDb.instance.getVoucherByVoucherCode(code))
        .docs
        .map((e) => VoucherModel.fromSnapshot(e))
        .single;

    return res;
  }

  @override
  Future<bool> checkExistVoucher(String voucherCode) async {
    final temp =
        await FireStoreDb.instance.getVoucher("sakumi_voucher_$voucherCode");

    if (temp.exists) {
      return true;
    }
    return false;
  }

  @override
  Future<void> addNewVoucher(VoucherModel model) async {
    if ((await checkExistVoucher(model.voucherCode)) == false) {
      return await FireStoreDb.instance.addVoucher(model);
    } else {
      debugPrint('=========> duplicate voucher');
    }
  }

  @override
  Future<List<VoucherModel>> searchVoucher(String text, String type) async {
    debugPrint('==========> search voucher000 $text');
    final list = (await FireStoreDb.instance.getListSearchVoucher(text, type))
        .docs
        .map((e) => VoucherModel.fromSnapshot(e))
        .toList();

    debugPrint('==========> search voucher ${list.length}');

    return list;
  }

  @override
  Future<void> updateVoucher(String usedUserCode, String noted,
      String voucherCode, String date) async {
    await FireStoreDb.instance
        .updateVoucher(usedUserCode, noted, voucherCode, date);
  }


  @override
  Future<bool> checkNewSurvey(SurveyModel survey) async {
    await FireStoreDb.instance.createNewSurvey(survey);
    return true;
  }

  @override
  Future<SurveyModel> getSurveyById(int id)async {
    return (await FireStoreDb.instance.getSurveyById(id))
        .docs
        .map((e) => SurveyModel.fromSnapshot(e))
        .single;
  }

  @override
  Future<List<SurveyModel>> getSurveyEnable()async {
    return (await FireStoreDb.instance.getSurveyEnable())
        .docs
        .map((e) => SurveyModel.fromSnapshot(e))
        .toList();
  }

  @override
  Future<List<SurveyResultModel>> getSurveyResultByClassId(int classId)async {
    var listResult = (await FireStoreDb.instance.getSurveyResultByClassId(classId))
        .docs
        .map((e) => SurveyResultModel.fromSnapshot(e))
        .toList();
    listResult.sort((a, b) => a.dateAssign.compareTo(b.dateAssign));
    return listResult;
  }

  @override
  Future<void> activeSurvey(int id)async {
    await FireStoreDb.instance
        .activeSurveyByDocs("survey_$id");
  }

  @override
  Future<void> saveSurvey(int id, SurveyModel survey)async {
    await FireStoreDb.instance
        .saveSurveyByDocs("survey_$id", survey);
  }
}
