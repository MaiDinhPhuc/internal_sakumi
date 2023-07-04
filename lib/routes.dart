import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/add_teacher_screen.dart';
import 'package:internal_sakumi/screens/admin_screen.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/master_screen.dart';
import 'package:internal_sakumi/screens/teacher_screen.dart';

class Routes {
  static FluroRouter router = FluroRouter();

  static const splash = "/";

  static const login = "/login";
  static const home = "/home";

  static const admin = "/admin";
  static const classes = "/classes";
  static const detailClass = "/detailClass";
  static const addClass = "/addClass";
  static const addStudent = "/addStudent";
  static const detailStudent = "/detailStudent";
  static const addUserToClass = "/addUserToClass";

  static const master = "/master";
  static const addTeacher = "/addTeacher";

  static const teacher = "/teacher";

  static const profile = "/profile";
  static const changePassword = "/changePassword";

  static const lesson = '/lesson';
  static const empty = '/empty';

  static const demoSimple = "/demo";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
    router.define(admin,
        handler: adminHandler, transitionType: TransitionType.fadeIn);
    router.define(master,
        handler: masterHandler, transitionType: TransitionType.fadeIn);
    router.define(addTeacher,
        handler: addTeacherHandler, transitionType: TransitionType.fadeIn);
  }
}

var emptyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const EmptyScreen();
});

var teacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherScreen(params['name']?.first);
});

var adminHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return AdminScreen(params['name']?.first);
});

var masterHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const MasterScreen();
});

var addTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return AddTeacherScreen();
});
