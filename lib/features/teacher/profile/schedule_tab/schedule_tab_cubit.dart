import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
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
  bool isLoadingSchedule = true;

  List<LessonResultModel>? listLessonResult;

  List<ScheduleModel>? listCyclicSchedule;
  List<ScheduleModel>? listSingleSchedule;

  List<DateTime> listDate = [];

  List<int> listClassId = [];
  List<ClassModel> listClass = [];

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

    DateTime dateTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    DateTime startOfWeek =
        dateTime.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    startDate = startOfWeek;
    endDate = endOfWeek;

    for (DateTime date = startDate!;
        date.isBefore(endDate!);
        date = date.add(const Duration(days: 1))) {
      listDate.add(date);
    }

    listDate.add(endDate!);

    emit(state + 1);

    await getSchedule();
  }

  getSchedule() async {
    listLessonResult = await FireBaseProvider.instance.getLessonResultWithDateAndTeacherId(
        startDate!.millisecondsSinceEpoch,
        endDate!.millisecondsSinceEpoch,
        teacherId!);

    listCyclicSchedule =
        await FireBaseProvider.instance.getTeacherCyclicSchedule(teacherId!);

    var listClassIdTemp = listCyclicSchedule!.map((e) => e.classId).toList();

    if (listClassIdTemp.isEmpty) {
      listSingleSchedule = [];
    } else {
      listSingleSchedule = await FireBaseProvider.instance
          .getTeacherSingleSchedule(
              listClassIdTemp,
              startDate!.millisecondsSinceEpoch,
              endDate!.millisecondsSinceEpoch);
    }

    for (var i in listLessonResult!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }

    for (var i in listCyclicSchedule!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }

    for (var i in listSingleSchedule!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }

    for (var i in listClassId) {
      DataProvider.classById(i, loadClass);
    }

    isLoadingSchedule = false;
    emit(state + 1);
  }

  String convertTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String getClassCode(int classId) {
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if (classModel.isEmpty) return "";
    return classModel.first.classCode;
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

  List<LessonResultModel> getResult(int index) {
    var time1 = listDate[index];
    var time2 = time1.add(const Duration(days: 1));

    var results = listLessonResult!
        .where((e) =>
            e.date <= time2.millisecondsSinceEpoch &&
            e.date >= time1.millisecondsSinceEpoch)
        .toList();

    return results;
  }

  bool checkExistResult(int index, int classId) {
    var listResult = getResult(index);

    for (var i in listResult) {
      if (i.classId == classId) return true;
    }

    return false;
  }

  List<ScheduleModel> getScheduleItem(int index, String day) {
    var date = listDate[index];
    DateTime dateTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    DateTime startOfWeek =
        dateTime.subtract(Duration(days: currentWeekday - 1));

    if (date.millisecondsSinceEpoch < startOfWeek.millisecondsSinceEpoch) {
      return [];
    }

    List<ScheduleModel> list = [];

    for (var i in listCyclicSchedule!) {
      if (i.role.contains(day) && checkExistResult(index, i.classId) == false) {
        list.add(i);
      }
    }

    for (var i in listSingleSchedule!) {
      if (i.date == date.millisecondsSinceEpoch &&
          checkExistResult(index, i.classId) == false) {
        var temp =
            listCyclicSchedule!.firstWhere((e) => e.classId == i.classId);
        list.remove(temp);
        list.add(i);
      }
    }

    return list;
  }

  String getRangeDate() {
    if (startDate == null || endDate == null) return "dd/MM/YYYY - dd/MM/YYYY";
    return "${DateFormat('dd/MM/yyyy').format(startDate!)} - ${DateFormat('dd/MM/yyyy').format(endDate!)} ";
  }

  String getDate(int index) {
    return DateFormat('dd/MM/yyyy').format(listDate[index]);
  }

  previous() async {
    isLoadingSchedule = true;
    emit(state + 1);

    DateTime start = startDate!;
    DateTime end = endDate!;

    startDate = start.subtract(const Duration(days: 7));
    endDate = end.subtract(const Duration(days: 7));

    listDate.clear();

    for (DateTime date = startDate!;
        date.isBefore(endDate!);
        date = date.add(const Duration(days: 1))) {
      listDate.add(date);
    }

    listDate.add(endDate!);
    await getSchedule();
  }

  next() async {
    isLoadingSchedule = true;
    emit(state + 1);
    DateTime start = startDate!;
    DateTime end = endDate!;

    startDate = start.add(const Duration(days: 7));
    endDate = end.add(const Duration(days: 7));

    listDate.clear();

    for (DateTime date = startDate!;
        date.isBefore(endDate!);
        date = date.add(const Duration(days: 1))) {
      listDate.add(date);
    }

    listDate.add(endDate!);
    await getSchedule();
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
        schedule: schedule!, email: teacher!.email);
    Update.updateTeacherProfile(teacherModel);
    // await FireBaseProvider.instance
    //     .updateProfileTeacher(teacher!.userId.toString(), teacherModel);
    DataProvider.updateTeacherInfo(teacher!.userId, teacherModel);
  }

  changeEdit() {
    isEdit = !isEdit;
    emit(state + 1);
  }

  loadTeacherInfo(Object teacher) {
    this.teacher = teacher as TeacherModel;
  }

  loadClass(Object classModel) {
    var classModelTemp = classModel as ClassModel;
    if(listClass.contains(classModelTemp) == false){
      listClass.add(classModelTemp);
    }
    if(listClass.length == listClassId.length){
      emit(state+1);
    }
  }
}
