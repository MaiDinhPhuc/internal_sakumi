import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

enum FilterTeacherClassStatus { preparing, completed, studying }

extension FilterClassStatusEx on FilterTeacherClassStatus {
  String get status {
    switch (this) {
      case FilterTeacherClassStatus.preparing:
        return "Preparing";
      case FilterTeacherClassStatus.completed:
        return "Completed";
      case FilterTeacherClassStatus.studying:
        return "InProgress";
    }
  }

  String get title {
    switch (this) {
      case FilterTeacherClassStatus.preparing:
        return "Mới tạo";
      case FilterTeacherClassStatus.completed:
        return "Hoàn thành";
      case FilterTeacherClassStatus.studying:
        return "Đang học";
    }
  }
}

enum TeacherFilter { status }

class TeacherClassFilterCubit extends Cubit<int> {
  TeacherClassFilterCubit() : super(0) {
    _init();
  }

  static const Map<TeacherFilter, List> defaultFilter = {
    TeacherFilter.status: [
      FilterTeacherClassStatus.preparing,
      FilterTeacherClassStatus.studying
    ],
  };

  Map<TeacherFilter, List> _filter = {};

  Map<TeacherFilter, List> get filter => _filter;

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(convertFilterEncode());
    prefs.setString('filterTeacher', jsonString);
  }

  Map<String, dynamic> convertFilterEncode() {
    var listStatus = filter[TeacherFilter.status]!
        .map((e) => (e as FilterTeacherClassStatus).title)
        .toList();

    return {
      "status": listStatus
    };
  }

  Map<TeacherFilter, List> convertFilterDecode(dynamic json) {
    var listStatus = [];
    for (var i in json["status"]) {
      switch (i) {
        case "Mới tạo":
          listStatus.add(FilterTeacherClassStatus.preparing);
          break;
        case "Hoàn thành":
          listStatus.add(FilterTeacherClassStatus.completed);
          break;
        case "Đang học":
          listStatus.add(FilterTeacherClassStatus.studying);
          break;
      }
    }


    return {
      TeacherFilter.status: listStatus
    };
  }

  Future<Map<TeacherFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterTeacher');
    if (jsonString != null) {
      return convertFilterDecode(json.decode(jsonString));
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

  update(TeacherFilter teacherFilter, List selectedList) async {
    bool areListsEqual =
    const ListEquality().equals(_filter[teacherFilter], selectedList);
    if (!areListsEqual) {
      _filter[teacherFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}
