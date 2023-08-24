import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/screens/admin/add_teacher_screen.dart';
import 'package:internal_sakumi/screens/admin/add_user_to_class_screen.dart';
import 'package:internal_sakumi/screens/admin/admin_screen.dart';
import 'package:internal_sakumi/screens/admin/detail_class_screen.dart';
import 'package:internal_sakumi/screens/admin/manage_general_screen.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/master_screen.dart';
import 'package:internal_sakumi/screens/teacher/class_screen.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_overview_tab.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_test_tab.dart';
import 'package:internal_sakumi/screens/teacher/detail_lesson_screen.dart';
import 'package:internal_sakumi/screens/teacher/tab/class_grading_tab.dart';
import 'package:internal_sakumi/screens/teacher/tab/list_lesson_tab.dart';
import 'package:internal_sakumi/screens/teacher/teacher_screen.dart';

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
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(classScreen, handler: classScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
    router.define(admin,
        handler: adminHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/manageGeneral',
        handler: manageGeneralHandler, transitionType: TransitionType.fadeIn);
    router.define(master,
        handler: masterHandler, transitionType: TransitionType.fadeIn);
    router.define(addTeacher,
        handler: addTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/overview/:classId',
        handler: overViewHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/lesson/:classId',
        handler: lessonsHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/test/:classId',
        handler: testHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/grading/:classId',
        handler: gradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/grading/:classId/:lessonId',
        handler: detailGradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:name/lesson/:classId/:lessonId',
        handler: detailLessonHandler, transitionType: TransitionType.fadeIn);
    // router.define('$admin/:classId',
    //     handler: detailClassHandler, transitionType: TransitionType.fadeIn);
    router.define(addUserToClass,
        handler: addUserToClassHandler, transitionType: TransitionType.fadeIn);

    router.define('/:name/profile',
        handler: profileTeacherHandler, transitionType: TransitionType.fadeIn);
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

var teacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherScreen(params['name']?.first);
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
  return ManageGeneralScreen();
});
var lessonsHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ListLessonTab(params['name'][0], params['classId'][0]);
});
var overViewHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassOverViewTab(params['name'][0]);
});
var gradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassGradingTab(params['name'][0]);
});
var testHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassTestTab(params['name'][0]);
});
var detailClassHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailClassScreen(params['classId'][0]);
});
var detailGradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailGradingScreen(params['name'][0]);
});
var detailLessonHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailLessonScreen(
      params['name'][0], params['classId'][0], params['lessonId'][0]);
});
var profileTeacherHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherProfile(params['name'][0]);
});