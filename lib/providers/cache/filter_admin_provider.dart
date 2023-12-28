import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterClassType { group, one }

extension FilterClassTypeEx on FilterClassType {
  String get title {
    switch (this) {
      case FilterClassType.group:
        return "Lớp Nhóm";
      case FilterClassType.one:
        return "Lớp 1:1";
    }
  }

  int get type {
    switch (this) {
      case FilterClassType.group:
        return 0;
      case FilterClassType.one:
        return 1;
    }
  }
}

enum FilterClassCourse { kaiwa, jlpt, general, kid }

extension FilterClassCourseEx on FilterClassCourse {
  String get title {
    switch (this) {
      case FilterClassCourse.kaiwa:
        return "Kaiwa";
      case FilterClassCourse.jlpt:
        return "JLPT";
      case FilterClassCourse.general:
        return "General";
      case FilterClassCourse.kid:
        return "Kid";
    }
  }
}

enum FilterClassLevel { n1, n2, n3, n4, n5, other }

extension FilterClassLevelEx on FilterClassLevel {
  String get title {
    switch (this) {
      case FilterClassLevel.n1:
        return "N1";
      case FilterClassLevel.n2:
        return "N2";
      case FilterClassLevel.n3:
        return "N3";
      case FilterClassLevel.n4:
        return "N4";
      case FilterClassLevel.n5:
        return "N5";
      case FilterClassLevel.other:
        return "Other";
    }
  }
}

enum FilterClassStatus { preparing, completed, studying, cancel }

extension FilterClassStatusEx on FilterClassStatus {
  String get status {
    switch (this) {
      case FilterClassStatus.preparing:
        return "Preparing";
      case FilterClassStatus.completed:
        return "Completed";
      case FilterClassStatus.studying:
        return "InProgress";
      case FilterClassStatus.cancel:
        return "Cancel";
    }
  }

  String get title {
    switch (this) {
      case FilterClassStatus.preparing:
        return "Mới tạo";
      case FilterClassStatus.completed:
        return "Hoàn thành";
      case FilterClassStatus.studying:
        return "Đang học";
      case FilterClassStatus.cancel:
        return "Huỷ";
    }
  }
}

enum AdminFilter { type, course, level, status }
// extension AdminFilterController on AdminFilter {}

class AdminClassFilterCubit extends Cubit<int> {
  AdminClassFilterCubit() : super(0) {
    _init();
  }

  static const Map<AdminFilter, List> defaultFilter = {
    AdminFilter.type: [FilterClassType.group],
    AdminFilter.course: [],
    AdminFilter.level: [],
    AdminFilter.status: [
      FilterClassStatus.preparing,
      FilterClassStatus.studying
    ],
  };

  Map<AdminFilter, List> _filter = {};

  Map<AdminFilter, List> get filter => _filter;


  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(_filter);
    prefs.setString('filter', jsonString);
  }

  Future<Map<AdminFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filter');
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  _init() async {
    _filter = await _fromPref() ??
        defaultFilter.keys.fold({}, (pre, key) {
          pre[key] = defaultFilter[key]!;
          return pre;
        });

    emit(state + 1);
  }

  String filterListString(AdminFilter adminFilter) {
    return '';
  }

  update(AdminFilter adminFilter, List<Object> selectedList) async {

    if (_filter[adminFilter] != selectedList) {

      _filter[adminFilter] = selectedList;

      _saveToPref();

      emit(state + 1);
    }
  }
}
