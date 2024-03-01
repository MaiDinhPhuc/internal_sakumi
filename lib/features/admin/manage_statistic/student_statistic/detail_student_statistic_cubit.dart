import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class DetailStudentStatisticCubit extends Cubit<int>{
  DetailStudentStatisticCubit(this.listLog):super(0){
    loadData();
  }

  final List<StudentClassLogModel> listLog;
  List<StudentModel> students = [];
  List<ClassModel> listClass = [];

  List<bool> level = [true,true,true,true,true];

  List<String> listContentType = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];

  List<String> listContentTypeSub = [
    "Hoàn thành",
    "Đang học",
    "Người xem",
    "Đăng ký lại",
    "Lên kỳ",
    "Chuyển lớp",
    "Bảo lưu",
    "Nghỉ học",
    "Bỏ cọc",
    "Bắt buộc lên kỳ",
    "Xoá"
  ];

  List<String> listLevel = [
    'N5',
    'N4',
    'N3',
    'N2',
    'N1'
  ];

  List<bool> type = [true,true,true,true];

  List<String> listType = [
    'Kaiwa',
    'JLPT',
    'General',
    'Kid'
  ];

  List<String> subType = [
    'kaiwa',
    'JLPT',
    'general',
    'Kid'
  ];

  List<bool> classType = [true,true];

  List<String> listClassType = [
    'Lớp Nhóm',
    'Lớp 1:1'
  ];

  loadData() async {
    var stdIds = listLog.map((e) => e.userId).toList();
    var classIds = listLog.map((e) => e.classId).toList();
    for (var i in stdIds) {
      DataProvider.studentById(i, loadStudentInfo);
    }
    listClass =
    await FireBaseProvider.instance.getListClassByListIdV2(classIds);
    emit(state + 1);
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
  }

  String getStudentName(int stdId) {
    var std = students.where((e) => e.userId == stdId).toList();
    if (std.isEmpty) {
      return "";
    }
    return std.first.name;
  }

  String getStudentPhone(int stdId) {
    var std = students.where((e) => e.userId == stdId).toList();
    if (std.isEmpty) {
      return "";
    }
    return std.first.phone == "" ? 'Chưa nhập' : std.first.phone;
  }

  String getClassCode(int classId) {
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if (classModel.isEmpty) {
      return "";
    }
    return classModel.first.classCode;
  }

  List<StudentClassLogModel> getListLog(StatisticFilterCubit filterController){
    List<int> listCourseId = [];
    List<int> classTypes = [];

    List<String> types = [];
    List<String> levels = [];

    for(int i = 0; i < type.length; i++ ){
      if(type[i]){
        types.add(subType[i]);
      }
    }

    for(int i = 0; i < level.length; i++ ){
      if(level[i]){
        levels.add(listLevel[i]);
      }
    }

    for(int i = 0; i < classType.length; i++ ){
      if(classType[i]){
        classTypes.add(i);
      }
    }

    for(var i in filterController.listCourse!){
      if(types.contains(i.type) && levels.contains(i.level)){
        listCourseId.add(i.courseId);
      }
    }
    return listLog.where((e) => listCourseId.contains(e.courseId) && classTypes.contains(e.classType)).toList();
  }

  String getContent(StudentClassLogModel logModel){
    if(logModel.from == 'none'){
      return AppText.txtStudentAddToClass.text;
    }
    return AppText.txtContentLog.text.replaceAll('@', listContentTypeSub[listContentType.indexOf(logModel.from)]).replaceAll('#', listContentTypeSub[listContentType.indexOf(logModel.to)]);
  }
}