class TeacherHomeClass {
  final List<int> listClassIds,
      listCourseIds,
      listClassType,
      listLessonCount,
      listLessonAvailable;
  final List<String> listClassCodes, listClassStatus, listBigTitle;
  final List<double> rateAttendance, rateSubmit;
  final List<List<int>> rateAttendanceChart, rateSubmitChart;

  const TeacherHomeClass(
      {required this.listClassIds,
      required this.listClassCodes,
      required this.listClassStatus,
      required this.listClassType,
      required this.listCourseIds,
      required this.listBigTitle,
      required this.rateAttendance,
      required this.rateSubmit,
      required this.rateAttendanceChart,
      required this.rateSubmitChart,
      required this.listLessonCount,
      required this.listLessonAvailable});
  factory TeacherHomeClass.fromData(
      List<int> listClassIds,
      List<int> listCourseIds,
      List<String> listClassCodes,
      List<String> listClassStatus,
      List<int> listClassType,
      List<String> listBigTitle,
      List<double> rateAttendance,
      List<double> rateSubmit,
      List<List<int>> rateAttendanceChart,
      List<List<int>> rateSubmitChart,
      List<int> listLessonCount,
      List<int> listLessonAvailable) {
    return TeacherHomeClass(
        listClassIds: listClassIds,
        listClassCodes: listClassCodes,
        listClassStatus: listClassStatus,
        listClassType: listClassType,
        listCourseIds: listCourseIds,
        listBigTitle: listBigTitle,
        rateAttendance: rateAttendance,
        rateSubmit: rateSubmit,
        rateAttendanceChart: rateAttendanceChart,
        rateSubmitChart: rateSubmitChart,
        listLessonCount: listLessonCount,
        listLessonAvailable: listLessonAvailable);
  }
}
