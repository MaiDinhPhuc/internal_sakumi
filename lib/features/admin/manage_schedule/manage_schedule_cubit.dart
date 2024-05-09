import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';

class ManageScheduleCubit extends Cubit<int> {
  ManageScheduleCubit() : super(0) {
    loadDate();
  }

  DateTime? startDate, endDate;
  final DateTime now = DateTime.now();
  int currentWeekday = DateTime.now().weekday;

  List<String> listMenu = ["Đổi giáo viên", "Nghỉ", "Huỷ lịch dạy"];

  List<String> listDay = [
    "Thứ HAI",
    "Thứ BA",
    "Thứ TƯ",
    "Thứ NĂM",
    "Thứ SÁU",
    "Thứ BẢY",
    "CHỦ NHẬT"
  ];
  int? classId;
  TextEditingController classSearch = TextEditingController();
  String classSearchValue = "";

  int? teacherId;
  TextEditingController teacherSearch = TextEditingController();
  String teacherSearchValue = "";

  List<TeacherModel> listTeacher = [];
  List<int> listTeacherId = [];

  List<DateTime> listDate = [];

  List<int> listClassId = [];
  List<ClassModel> listClass = [];

  List<LessonResultModel>? listLessonResult;
  List<ScheduleModel>? listCyclicSchedule;
  List<ScheduleModel>? listSingleSchedule;

  bool isLoadingSchedule = false;

  loadDate() {
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

    listLessonResult = [];
    listCyclicSchedule = [];
    listSingleSchedule = [];

    emit(state + 1);
  }

  String convertTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat('HH:mm:ss').format(dateTime);
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

  String getClassCode(int classId) {
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if (classModel.isEmpty) return "";
    return classModel.first.classCode;
  }

  String getTeacherName(int teacherId) {
    if(this.teacherId != null) {
      var teacherModel = listTeacher.where((e) => e.userId == this.teacherId).toList();
      if (teacherModel.isEmpty) return "";
      return teacherModel.first.name;
    }
    var teacherModel = listTeacher.where((e) => e.userId == teacherId).toList();
    if (teacherModel.isEmpty) return "";
    return teacherModel.first.name;
  }

  chooseClass(String className, int classId) async {
    this.classId = classId;
    classSearch.text = className;
    emit(state + 1);
  }

  bool checkExistResult(int index, int classId) {
    var listResult = getResult(index);

    for (var i in listResult) {
      if (i.classId == classId) return true;
    }

    return false;
  }

  removeSchedule(ScheduleModel schedule) {
    var check1 = listSingleSchedule!.contains(schedule);
    var check2 = listCyclicSchedule!.contains(schedule);
    if (check1) {
      listSingleSchedule!.remove(schedule);
      emit(state + 1);
      return;
    }
    if (check2) {
      listCyclicSchedule!.remove(schedule);
      emit(state + 1);
      return;
    }
  }

  addSchedule(ScheduleModel schedule){
    listSingleSchedule!.add(schedule);
    if(listTeacherId.contains(schedule.teacherId) == false){
      listTeacherId.add(schedule.teacherId);
    }
    for (var i in listTeacherId) {
      DataProvider.teacherById(i, loadTeacher);
    }
    emit(state+1);
  }

  cancelSchedule(ScheduleModel schedule, int index) {

    var date = listDate[index].millisecondsSinceEpoch;

    var newSchedule = ScheduleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        teacherId: schedule.teacherId,
        status: "cancel",
        classId: schedule.classId,
        type: "single",
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        role: [],
        date: date);

    listSingleSchedule!.add(newSchedule);
    Create.createSingleSchedule(newSchedule);
    emit(state + 1);
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
        List<ScheduleModel> temp =
            listCyclicSchedule!.where((e) => e.classId == i.classId).toList();
        if (temp.isNotEmpty) {
          list.remove(temp.first);
          list.add(i);
        }
      }
    }

    return list;
  }

  bool checkSchedule(ScheduleModel schedule){

    if(teacherId != null){
      return false;
    }

    List<ScheduleModel> temp =
    listCyclicSchedule!.where((e) => e.classId == schedule.classId).toList();
    if(temp.length == 1 && temp.first.teacherId == schedule.teacherId){
      return false;
    }
    return true;
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
    if ((classId == null && teacherId == null) == false) {
      await getSchedule();
    } else {
      isLoadingSchedule = false;
      emit(state + 1);
    }
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
    if ((classId == null && teacherId == null) == false) {
      await getSchedule();
    } else {
      isLoadingSchedule = false;
      emit(state + 1);
    }
  }

  getSchedule() async {
    if (classId != null && teacherId == null) {
      listLessonResult = await FireBaseProvider.instance
          .getLessonResultWithDateAndClassId(startDate!.millisecondsSinceEpoch,
              endDate!.millisecondsSinceEpoch, classId!);

      listCyclicSchedule =
          await FireBaseProvider.instance.getClassCyclicSchedule(classId!);

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
    }

    if (classId == null && teacherId != null) {
      listLessonResult = await FireBaseProvider.instance
          .getLessonResultWithDateAndTeacherId(
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
    }

    if (classId != null && teacherId != null) {
      listLessonResult = await FireBaseProvider.instance
          .getLessonResultWithDateAndId(startDate!.millisecondsSinceEpoch,
              endDate!.millisecondsSinceEpoch, teacherId!, classId!);

      listCyclicSchedule = await FireBaseProvider.instance
          .getTeacherCyclicScheduleInClass(teacherId!, classId!);

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
    }

    for (var i in listLessonResult!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
      if (listTeacherId.contains(i.teacherId) == false) {
        listTeacherId.add(i.teacherId);
      }
    }

    for (var i in listCyclicSchedule!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
      if (listTeacherId.contains(i.teacherId) == false) {
        listTeacherId.add(i.teacherId);
      }
    }

    for (var i in listSingleSchedule!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
      if (listTeacherId.contains(i.teacherId) == false) {
        listTeacherId.add(i.teacherId);
      }
    }

    for (var i in listClassId) {
      DataProvider.classByClassId(i, loadClass);
    }

    for (var i in listTeacherId) {
      DataProvider.teacherById(i, loadTeacher);
    }

    isLoadingSchedule = false;
    emit(state + 1);
  }

  deleteClass() {
    listSingleSchedule = [];
    listCyclicSchedule = [];
    classId = null;
    classSearch.text = "";
    classSearchValue = "";
    emit(state + 1);
  }

  searchClass(String newValue) {
    classSearchValue = newValue;
    emit(state + 1);
  }

  searchTeacher(String newValue) {
    teacherSearchValue = newValue;
    emit(state + 1);
  }

  deleteTeacher() {
    listSingleSchedule = [];
    listCyclicSchedule = [];
    teacherId = null;
    teacherSearch.text = "";
    teacherSearchValue = "";
    emit(state + 1);
  }

  chooseTeacher(String teacher, int userId) {
    teacherId = userId;
    teacherSearch.text = teacher;
    emit(state + 1);
  }

  loadClass(Object classModel) {
    var classModelTemp = classModel as ClassModel;
    if (listClass.contains(classModelTemp) == false) {
      listClass.add(classModelTemp);
    }
    if (listClass.length == listClassId.length) {
      emit(state + 1);
    }
  }

  loadTeacher(Object teacherModel) {
    var teacherModelTemp = teacherModel as TeacherModel;
    if (listTeacher.contains(teacherModelTemp) == false) {
      listTeacher.add(teacherModelTemp);
    }
    if (listTeacher.length == listTeacherId.length) {
      emit(state + 1);
    }
  }
}
