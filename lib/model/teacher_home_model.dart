import 'course_model.dart';

class TeacherHomeClass {
  final List<int> listClassIds,
      listClassType,
      listLessonCount,
      listLessonAvailable,
      listCourseId;
  final List<String> listClassCodes,
      listClassStatus,
      listBigTitle,
      listLastLessonTitle,
      listClassNote,
      listClassDes;
  final List<double> rateAttendance, rateSubmit;
  final List<List<int>> rateAttendanceChart, rateSubmitChart;
  final List<List<double>> colStd;
  final List<CourseModel> listCourse;

  const TeacherHomeClass(
      {required this.listClassIds,
      required this.listClassCodes,
      required this.listClassStatus,
      required this.listClassType,
      required this.listBigTitle,
      required this.rateAttendance,
      required this.rateSubmit,
      required this.rateAttendanceChart,
      required this.rateSubmitChart,
      required this.listLessonCount,
      required this.listLessonAvailable,
      required this.listCourse,
      required this.listCourseId,
      required this.colStd,
      required this.listClassDes,
      required this.listClassNote,
      required this.listLastLessonTitle});
  factory TeacherHomeClass.fromData(
      List<int> listClassIds,
      List<String> listClassCodes,
      List<String> listClassStatus,
      List<int> listClassType,
      List<String> listBigTitle,
      List<double> rateAttendance,
      List<double> rateSubmit,
      List<List<int>> rateAttendanceChart,
      List<List<int>> rateSubmitChart,
      List<int> listLessonCount,
      List<int> listLessonAvailable,
      List<CourseModel> listCourse,
      List<int> listCourseIds,
      List<List<double>> colStd,
      List<String> listClassDes,
      List<String> listClassNote,
      List<String> listLastLessonTitle) {
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
        listCourse: listCourse,
        listCourseId: listCourseIds,
        colStd: colStd,
        listClassDes: listClassDes,
        listClassNote: listClassNote,
        listLastLessonTitle: listLastLessonTitle);
  }
}
