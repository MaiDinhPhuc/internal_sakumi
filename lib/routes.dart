import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/screens/admin/add_teacher_screen.dart';
import 'package:internal_sakumi/screens/admin/add_user_to_class_screen.dart';
import 'package:internal_sakumi/screens/admin/admin_screen.dart';
import 'package:internal_sakumi/screens/admin/detail_class_screen.dart';
import 'package:internal_sakumi/screens/admin/manage_general_screen.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/master_screen.dart';
import 'package:internal_sakumi/screens/splash_screen.dart';
import 'package:internal_sakumi/screens/teacher/class_screen.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_overview_tab.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_test_tab.dart';
import 'package:internal_sakumi/screens/teacher/detail_lesson_screen.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_grading_tab.dart';
import 'package:internal_sakumi/screens/teacher/tab/list_lesson_tab.dart';
import 'package:internal_sakumi/screens/teacher/teacher_screen.dart';
import 'package:internal_sakumi/screens/teacher/teacher_screen2.dart';

import 'screens/teacher/teacher_profile.dart';

class Routes {
  static FluroRouter router = FluroRouter();

  static const splash = "/";

  static const login = "/login";
  static const home = "/home";

  static const classes = "/classes";
  static const detailClass = "/detailClass";
  static const addClass = "/addClass";
  static const addStudent = "/addStudent";
  static const detailStudent = "/detailStudent";
  static const addUserToClass = "/addUserToClass";
  static const profile = "/profile";
  static const changePassword = "/changePassword";

  static const master = "/master";
  static const admin = "/admin";
  static const addTeacher = "/addTeacher";

  static const teacher = "/teacher";
  static const classScreen = "/classScreen";
  static const manageGeneral = "manageGeneral";

  static const empty = '/empty';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      debugPrint("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(login,
        handler: loginScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(classScreen,
        handler: classScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(splash,
        handler: splashScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
    router.define(admin,
        handler: adminHandler, transitionType: TransitionType.fadeIn);
    router.define(master,
        handler: masterHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageGeneral',
        handler: manageGeneralHandler, transitionType: TransitionType.fadeIn);
    router.define('$teacher/profile',
        handler: profileTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define(addTeacher,
        handler: addTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/overview/:classId',
        handler: overViewHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/grading/:classId',
        handler: gradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/lesson/:classId',
        handler: lessonsHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/:test/:classId',
        handler: testHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/grading/:classId/:type/:parentId',
        handler: detailGradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/lesson/:classId/:lessonId',
        handler: detailLessonHandler, transitionType: TransitionType.fadeIn);
    // router.define('$admin/:classId',
    //     handler: detailClassHandler, transitionType: TransitionType.fadeIn);
    router.define(addUserToClass,
        handler: addUserToClassHandler, transitionType: TransitionType.fadeIn);
  }
}

var emptyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const EmptyScreen();
});

var classScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ClassScreen();
});
var splashScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return  SplashScreen();
});
var loginScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return LogInScreen();
});

var teacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherScreen2();
});

var adminHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const AdminScreen();
});

var addUserToClassHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return AddUserToClassScreen(params['classId']?.first);
});

var masterHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const MasterScreen();
});

var addTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return AddTeacherScreen();
});
var manageGeneralHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageGeneralScreen();
});
var lessonsHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ListLessonTab(params['role'][0]);
});
var overViewHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassOverViewTab(params['role']?.first);
});
var gradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ClassGradingTab();
});
var testHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassTestTab(params['role'][0]);
});
var detailClassHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailClassScreen(params['classId'][0]);
});
var detailGradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailGradingScreen(params['type'][0]);
});
var detailLessonHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const DetailLessonScreen();
});
var profileTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const TeacherProfile();
});
