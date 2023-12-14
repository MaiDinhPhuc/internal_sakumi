import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/screens/admin/manage_general_screen.dart';
import 'package:internal_sakumi/screens/admin/student_info_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_classes_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_feedbacks_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_statistics_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/search_general_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_tags_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/tool_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/voucher_screen.dart';
import 'package:internal_sakumi/screens/admin/teacher_info_screen.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/master/detail_survey_screen.dart';
import 'package:internal_sakumi/screens/master/survey_tab.dart';
import 'package:internal_sakumi/screens/master/manage_course_tab.dart';
import 'package:internal_sakumi/screens/splash_screen.dart';
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
      debugPrint("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(login,
        handler: loginScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(splash,
        handler: splashScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/manageCourse',
        handler: manageCourseHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/manageSurvey',
        handler: manageSurveyHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageGeneral',
        handler: manageGeneralHandler, transitionType: TransitionType.fadeIn);
    router.define('$teacher/profile',
        handler: profileTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/searchGeneral',
        handler: searchScreenHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageClasses',
        handler: manageClassesHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageTags',
        handler: manageTagsHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageStatistics',
        handler: manageStatisticsHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageFeedbacks',
        handler: manageFeedbacksHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/tools',
        handler: toolsHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/voucher',
        handler: voucherHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/teacherInfo/:teacherId',
        handler: teacherInfoHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/studentInfo/:studentId',
        handler: studentInfoHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/manageSurvey/:id',
        handler: manageSurveyDetailHandler, transitionType: TransitionType.fadeIn);
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
  }
}

var emptyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const EmptyScreen();
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
  return const TeacherScreen();
});

var manageCourseHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageCourseTab();
});

var manageSurveyHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const SurveyTab();
});

var manageSurveyDetailHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailSurveyScreen();
});

var manageGeneralHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageGeneralScreen();
});
var searchScreenHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return SearchGeneralScreen();
});
var manageClassesHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageClassesScreen();
});
var manageTagsHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageTagsScreen();
});
var manageStatisticsHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageStatisticsScreen();
});
var manageFeedbacksHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageFeedBacksScreen();
});
var toolsHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ToolScreen();
});
var voucherHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return VoucherScreen();
});
var studentInfoHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return StudentInfoScreen();
});
var teacherInfoHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherInfoScreen();
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
  return ClassGradingTab();
});
var testHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassTestTab(params['role'][0]);
});
var detailGradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailGradingScreen(params['type'][0]);
});
var detailLessonHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailLessonScreen();
});
var profileTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const TeacherProfile();
});
