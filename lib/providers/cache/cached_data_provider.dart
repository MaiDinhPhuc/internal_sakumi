import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';

enum FilterClassType { group, one }
extension FilterClassTypeEx on FilterClassType {

  String get title {
    switch(this) {
      case FilterClassType.group : return  "Lớp Nhóm";
      case FilterClassType.one : return  "Lớp 1:1";
    }
  }


}



enum FilterClassCourse { kaiwa, jlpt, general, kid }
enum FilterClassLevel { n1, n2, n3, n4, n5, other }
enum FilterClassStatus { preparing, completed, studying }
enum AdminFilter { type, course, level, status }
// extension AdminFilterController on AdminFilter {}

class AdminClassFilterCubit extends Cubit<int> {
  AdminClassFilterCubit() : super(0) {
    _init();
  }
  static const Map<AdminFilter, List> defaultFilter = {
    AdminFilter.type: [FilterClassType.one],
    AdminFilter.course: [],
    AdminFilter.level: [],
    AdminFilter.status: [],
  };
  Map<AdminFilter, List> _filter = {};

  Future<void> _saveToPref() async {
  }
  Future<Map<AdminFilter, List>?> _fromPref() async {
    return null;
  }
  _init() async {
    _filter = await _fromPref() ?? defaultFilter;
    emit(state + 1);
  }
  String filterListString(AdminFilter adminFilter)  {
    return '';
  }
  update(AdminFilter adminFilter, List<Object> selectedList) {


    if (_filter[adminFilter] != selectedList) {
      _filter[adminFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}

class CacheObject {
  Object? data;
  DateTime? time;

  List<Function()> callbacks = [];
}

class DataProvider {
  static Map<String, CacheObject> cached = {};


  Future<List<ClassModel>> clasList(Map<AdminFilter, List> _filter, int admin, {ClassModel? lastItem}) async {
    return [];
  }

  Future<CourseModel> courseById(int id) async {

  }


}
