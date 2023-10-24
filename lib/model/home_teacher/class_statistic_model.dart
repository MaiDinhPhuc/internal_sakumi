import 'package:internal_sakumi/model/student_lesson_model.dart';

class ClassStatisticModel {
  final int classId;
  final double attendancePercent, hwPercent;
  final List<double> stds;
  final List<int> attChart, hwChart;

  static make(List<StudentLessonModel> stdLessons, List<String> listStatus,
      int classId, List<int> listLessonId) {
    double attendancePercent = 0;
    double hwPercent = 0;
    int count =
        stdLessons.where((element) => element.timekeeping != 0).toList().length;
    double attendanceTemp = 0;
    double hwPercentTemp = 0;
    for (var i in stdLessons) {
      if (i.timekeeping < 5 && i.timekeeping > 0) {
        attendanceTemp++;
        if (i.hw != -2) {
          hwPercentTemp++;
        }
      }
    }
    attendancePercent = attendanceTemp / (count == 0 ? 1 : count);
    hwPercent = hwPercentTemp / (count == 0 ? 1 : count);

    double col1 = 0;
    double col2 = 0;
    double col3 = 0;
    double col4 = 0;
    double col5 = 0;
    for (var i in listStatus) {
      if (i == "Completed" ||
          i == "InProgress" ||
          i == "ReNew") {
        col1++;
      }
      if (i == "Viewer") {
        col2++;
      }
      if (i == "UpSale" || i == "Force") {
        col4++;
      }
      if (i == "Moved") {
        col3++;
      }
      if (i == "Retained" ||
          i == "Dropped" ||
          i == "Deposit") {
        col5++;
      }
    }
    List<double> stds = [col1, col2, col3, col4, col5];

    List<int> attChart = [];
    List<int> hwChart = [];

    for(var i in listLessonId){
      List<StudentLessonModel> listTemp = stdLessons.where((e) => e.lessonId == i).toList();
      int att = 0;
      int hw = 0;
      for(var j in listTemp){
        if(j.timekeeping < 5 && j.timekeeping>0){
          att++;
          if(j.hw!=-2){
            hw++;
          }
        }
      }
      attChart.add(att);
      hwChart.add(hw);
    }

    return ClassStatisticModel(
        classId: classId,
        attendancePercent: attendancePercent,
        hwPercent: hwPercent,
        stds: stds,
        attChart: attChart,
        hwChart: hwChart);
  }

  ClassStatisticModel(
      {required this.classId,
      required this.attendancePercent,
      required this.hwPercent,
      required this.stds,
      required this.attChart,
      required this.hwChart});
}
