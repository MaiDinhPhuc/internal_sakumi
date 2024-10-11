import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/screens/admin/detail_survey_screen.dart';
import 'package:internal_sakumi/screens/admin/manage_general_screen.dart';
import 'package:internal_sakumi/screens/admin/student_info_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_bill_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_feedbacks_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_procedure_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_schedule_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_statistics_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_advises_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_survey_tab.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_teacher_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/search_general_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_tags_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/tool_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/voucher_screen.dart';
import 'package:internal_sakumi/screens/admin/teacher_info_screen.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_class_screen.dart';
import 'package:internal_sakumi/screens/class_info/class_overview_screen_v2.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_custom_screen.dart';
import 'package:internal_sakumi/screens/class_info/detail_lesson_v2.dart';
import 'package:internal_sakumi/screens/class_info/grading_screen_v2.dart';
import 'package:internal_sakumi/screens/class_info/list_lesson_screen_v2.dart';
import 'package:internal_sakumi/screens/class_info/list_test_screen_v2.dart';
import 'package:internal_sakumi/screens/class_info/report_screen.dart';
import 'package:internal_sakumi/screens/class_info/sub_course_screen.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/master/detail_answer_teacher_survey_screen.dart';
import 'package:internal_sakumi/screens/master/detail_student_survey_screen.dart';
import 'package:internal_sakumi/screens/master/detail_teacher_survey_screen.dart';
import 'package:internal_sakumi/screens/master/gift_code_tab.dart';
import 'package:internal_sakumi/screens/master/manage_banner_tab.dart';
import 'package:internal_sakumi/screens/master/manage_course_suggest_tab.dart';
import 'package:internal_sakumi/screens/master/manage_teacher_feed_back_tab.dart';
import 'package:internal_sakumi/screens/master/student_survey_tab.dart';
import 'package:internal_sakumi/screens/master/manage_course_tab.dart';
import 'package:internal_sakumi/screens/master/teacher_survey_tab.dart';
import 'package:internal_sakumi/screens/splash_screen.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/screens/teacher_v2/teacher_screen_v2.dart';
import 'package:internal_sakumi/screens/teacher_v2/teacher_survey_screen.dart';

import 'screens/teacher_v2/teacher_profile.dart';

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
  static const manageSchedule = "manageSchedule";

  static const empty = '/empty';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const EmptyScreen();
    });
    router.define(login,
        handler: loginScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(splash,
        handler: splashScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/manageCourse',
        handler: manageCourseHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/manageStudentSurvey',
        handler: manageStudentSurveyHandler,
        transitionType: TransitionType.fadeIn);
    router.define('$master/manageTeacherSurvey',
        handler: manageTeacherSurveyHandler,
        transitionType: TransitionType.fadeIn);
    router.define('$master/manageTeacherFeedBack',
        handler: manageTeacherFeedBackHandler,
        transitionType: TransitionType.fadeIn);
    router.define('$master/manageBanner',
        handler: manageBanner,
        transitionType: TransitionType.fadeIn);
    router.define('$master/giftCode',
        handler: giftCode,
        transitionType: TransitionType.fadeIn);
    router.define('$master/manageCourseSuggest',
        handler: manageCourseSuggest,
        transitionType: TransitionType.fadeIn);
    router.define('$admin/manageGeneral',
        handler: manageGeneralHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageSchedule',
        handler: manageScheduleHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageProcedure',
        handler: manageProcedureHandler, transitionType: TransitionType.fadeIn);
    router.define('$teacher/profile',
        handler: profileTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define('$teacher/:surveyId',
        handler: teacherSurveyHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/searchGeneral',
        handler: searchScreenHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageClasses',
        handler: manageClassesHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageTags',
        handler: manageTagsHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageBills',
        handler: manageBillsHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageTeachers',
        handler: manageTeacherHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageAdvises',
        handler: manageStudentHandler, transitionType: TransitionType.fadeIn);
    router.define('$admin/manageStatistics',
        handler: manageStatisticsHandler,
        transitionType: TransitionType.fadeIn);
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
    router.define('$master/manageStudentSurvey/:id',
        handler: manageStudentSurveyDetailHandler,
        transitionType: TransitionType.fadeIn);
    router.define('$master/manageTeacherSurvey/:id',
        handler: manageTeacherSurveyDetailHandler,
        transitionType: TransitionType.fadeIn);
    router.define('/:role/overview/:classId',
        handler: overViewHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/grading/:classId',
        handler: gradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/subCourse/:classId',
        handler: subCourseHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/survey/:classId',
        handler: surveyHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/lesson/:classId',
        handler: lessonsHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/test/:classId',
        handler: testHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/report/:classId',
        handler: reportHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/grading/:classId/:type/:parentId',
        handler: detailGradingHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/grading/:classId/:type/:customId/:parentId',
        handler: detailCustomGradingHandler,
        transitionType: TransitionType.fadeIn);
    router.define('/:role/lesson/:classId/:lessonId',
        handler: detailLessonHandler, transitionType: TransitionType.fadeIn);
    router.define('/:role/survey/:classId/:surveyId',
        handler: detailSurveyHandler, transitionType: TransitionType.fadeIn);
    router.define('$master/:surveyId/:teacherId/:date',
        handler: detailTeacherSurveyHandler, transitionType: TransitionType.fadeIn);
  }
}

var emptyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const EmptyScreen();
});

var splashScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return SplashScreen();
});
var loginScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return LogInScreen();
});

var teacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherScreenV2(); //const TeacherScreen();
});

var manageCourseHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageCourseTab();
});

var manageStudentSurveyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageStudentSurveyTab();
});

var manageTeacherSurveyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageTeacherSurveyTab();
});

var manageTeacherFeedBackHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageTeacherFeedBackTab();
});
var manageBanner =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageBannerTab();
});
var giftCode =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return GiftCodeTab();
});

var manageCourseSuggest =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageCourseSuggestTab();
});

var manageStudentSurveyDetailHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailStudentSurveyScreen();
});

var manageTeacherSurveyDetailHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailTeacherSurveyScreen();
});

var manageGeneralHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageGeneralScreen();
});

var manageScheduleHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageScheduleScreen();
});

var manageProcedureHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageProcedureScreen();
});

var searchScreenHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return SearchGeneralScreen();
});
var manageClassesHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //return const ManageClassesScreen();
  return const ManageClassScreenV2();
});
var manageTagsHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const ManageTagsScreen();
});
var manageBillsHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageBillScreen();
});
var manageTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageTeacherScreen();
});
var manageStudentHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageAdvisesScreen();
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
  return ToolScreen();
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
  return ListLessonScreenV2(
      role: params['role'][0]); //ListLessonTab(params['role'][0]);
});
var overViewHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ClassOverViewScreenV2(
      role: params['role']?.first); //ClassOverViewTab(params['role']?.first);
});
var gradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return GradingScreen();
});
var subCourseHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return SubCourseScreen(role: params['role']?.first);
});

var testHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ListTestScreenV2(role: params['role'][0]);
});

var reportHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ReportScreen(role: params['role'][0]);
});
var surveyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return ManageSurveyTab();
});
var detailGradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailGradingScreen(params['type'][0]);
});
var detailCustomGradingHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailGradingCustomScreen(params['type'][0]);
});
var detailLessonHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailLessonV2();
});
var detailSurveyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return DetailSurveyAdminScreen();
});
var profileTeacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherProfile();
});
var teacherSurveyHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const TeacherSurveyScreen();
});
var detailTeacherSurveyHandler =
Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const DetailAnswerTeacherSurveyScreen();
});
