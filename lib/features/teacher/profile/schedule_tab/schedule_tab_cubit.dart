import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleTabCubit extends Cubit<int> {
  ScheduleTabCubit(this.role) : super(0) {
    loadData();
  }

  final String role;
  TeacherModel? teacher;
  int? teacherId;
  bool isEdit = false;
  Map? schedule;
  Map? oldSchedule;

  DateTime? startDate, endDate;
  final DateTime now = DateTime.now();
  int currentWeekday = DateTime.now().weekday;

  List<String> listDay = [
    "Thứ HAI",
    "Thứ BA",
    "Thứ TƯ",
    "Thứ NĂM",
    "Thứ SÁU",
    "Thứ BẢY",
    "CHỦ NHẬT"
  ];

  loadData() async {
    if (role == "admin") {
      teacherId = int.parse(TextUtils.getName());
    } else {
      SharedPreferences localData = await SharedPreferences.getInstance();
      int userId = localData.getInt(PrefKeyConfigs.userId)!;
      teacherId = userId;
    }
    await DataProvider.teacherById(teacherId!, loadTeacherInfo);
    schedule = teacher!.schedule;

    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    startDate = startOfWeek;
    endDate = endOfWeek;

    emit(state + 1);
  }

  updateSchedule(String day, int time) {
    String dayKey = 'Mon';

    switch (day) {
      case "Thứ HAI":
        dayKey = 'Mon';
        break;
      case "Thứ BA":
        dayKey = 'Tue';
        break;
      case "Thứ TƯ":
        dayKey = 'Wed';
        break;
      case "Thứ NĂM":
        dayKey = 'Thu';
        break;
      case "Thứ SÁU":
        dayKey = 'Fri';
        break;
      case "Thứ BẢY":
        dayKey = 'Sat';
        break;
      case "CHỦ NHẬT":
        dayKey = 'Sun';
        break;
    }
    var listTime = schedule![dayKey];
    if (listTime.contains(time)) {
      listTime.remove(time);
      schedule!.update(dayKey, (value) => listTime);
    } else {
      listTime.add(time);
      schedule!.update(dayKey, (value) => listTime);
    }
    emit(state + 1);
  }

  bool getValue(String day, int time) {
    if (schedule == null || schedule == {}) return false;

    String dayKey = 'Mon';

    switch (day) {
      case "Thứ HAI":
        dayKey = 'Mon';
        break;
      case "Thứ BA":
        dayKey = 'Tue';
        break;
      case "Thứ TƯ":
        dayKey = 'Wed';
        break;
      case "Thứ NĂM":
        dayKey = 'Thu';
        break;
      case "Thứ SÁU":
        dayKey = 'Fri';
        break;
      case "Thứ BẢY":
        dayKey = 'Sat';
        break;
      case "CHỦ NHẬT":
        dayKey = 'Sun';
        break;
    }

    var listTime = schedule![dayKey];

    if (listTime.isEmpty) return false;

    if (listTime.contains(time)) {
      return true;
    }

    return false;
  }

  String getDate(){
    if(startDate == null || endDate == null) return "dd/MM/YYYY - dd/MM/YYYY";
    return "${DateFormat('dd/MM/yyyy').format(startDate!)} - ${DateFormat('dd/MM/yyyy').format(endDate!)} ";
  }

  previous(){

    DateTime start = startDate!;
    DateTime end = endDate!;

    startDate = start.subtract(const Duration(days: 7));
    endDate = end.subtract(const Duration(days: 7));
    emit(state+1);
  }

  next(){
    DateTime start = startDate!;
    DateTime end = endDate!;

    startDate = start.add(const Duration(days: 7));
    endDate = end.add(const Duration(days: 7));
    emit(state+1);
  }

  updateScheduleData() async {
    var teacherModel = TeacherModel(
        name: teacher!.name,
        url: teacher!.url,
        note: teacher!.note,
        userId: teacher!.userId,
        phone: teacher!.phone,
        teacherCode: teacher!.teacherCode,
        status: teacher!.status,
        schedule: schedule!);
    await FireBaseProvider.instance.updateProfileTeacher(
        teacher!.userId.toString(),teacherModel
        );
    DataProvider.updateTeacherInfo(teacher!.userId,teacherModel);
  }

  changeEdit() {
    isEdit = !isEdit;
    emit(state + 1);
  }

  loadTeacherInfo(Object teacher) {
    this.teacher = teacher as TeacherModel;
  }
}
