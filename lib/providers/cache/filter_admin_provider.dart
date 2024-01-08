import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'cached_data_provider.dart';

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

enum FilterClassLevel { n1, n2, n3, n4, n5 }

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

class AdminClassFilterCubit extends Cubit<int> {
  AdminClassFilterCubit() : super(0) {
    _init();
  }

  List<CourseModel>? listCourse;

  static const Map<AdminFilter, List> defaultFilter = {
    AdminFilter.type: [FilterClassType.group],
    AdminFilter.course: [FilterClassCourse.general],
    AdminFilter.level: [FilterClassLevel.n5],
    AdminFilter.status: [
      FilterClassStatus.preparing,
      FilterClassStatus.studying
    ],
  };

  String courseType(FilterClassCourse type) {
    switch (type) {
      case FilterClassCourse.kaiwa:
        return "kaiwa";
      case FilterClassCourse.jlpt:
        return "JLPT";
      case FilterClassCourse.general:
        return "general";
      case FilterClassCourse.kid:
        return "kid";
    }
  }

  String level(FilterClassLevel level) {
    switch (level) {
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
    }
  }

  List<int> getCourseId(List<dynamic> listCourse, List<dynamic> listLevel){

    List<int> listId = [];

    var types = listCourse.map((e) => courseType(e)).toList();
    var levels = listLevel.map((e) => level(e)).toList();

    for(var i in this.listCourse!){
      if(types.contains(i.type) && levels.contains(i.level)){
        listId.add(i.courseId);
      }
    }

    return listId;
  }

  Map<AdminFilter, List> _filter = {};

  Map<AdminFilter, List> get filter => _filter;

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(convertFilterEncode());
    prefs.setString('filter', jsonString);
  }

  Map<String, dynamic> convertFilterEncode() {
    var listType = filter[AdminFilter.type]!
        .map((e) => (e as FilterClassType).title)
        .toList();
    var listCourse = filter[AdminFilter.course]!
        .map((e) => (e as FilterClassCourse).title)
        .toList();
    var listLevel = filter[AdminFilter.level]!
        .map((e) => (e as FilterClassLevel).title)
        .toList();
    var listStatus = filter[AdminFilter.status]!
        .map((e) => (e as FilterClassStatus).title)
        .toList();

    return {
      "type": listType,
      "course": listCourse,
      "level": listLevel,
      "status": listStatus
    };
  }

  Map<AdminFilter, List> convertFilterDecode(dynamic json) {
    var listType = [];
    for (var i in json["type"]) {
      if (i == "Lớp Nhóm") {
        listType.add(FilterClassType.group);
      }
      if (i == "Lớp 1:1") {
        listType.add(FilterClassType.one);
      }
    }
    var listStatus = [];
    for (var i in json["status"]) {
      switch (i) {
        case "Mới tạo":
          listStatus.add(FilterClassStatus.preparing);
          break;
        case "Hoàn thành":
          listStatus.add(FilterClassStatus.completed);
          break;
        case "Đang học":
          listStatus.add(FilterClassStatus.studying);
          break;
        case "Huỷ":
          listStatus.add(FilterClassStatus.cancel);
          break;
      }
    }

    var listCourse = [];
    for (var i in json["course"]) {
      switch (i) {
        case "Kaiwa":
          listCourse.add(FilterClassCourse.kaiwa);
          break;
        case "JLPT":
          listCourse.add(FilterClassCourse.jlpt);
          break;
        case "General":
          listCourse.add(FilterClassCourse.general);
          break;
        case "Kid":
          listCourse.add(FilterClassCourse.kid);
          break;
      }
    }

    var listLevel = [];
    for (var i in json["level"]) {
      switch (i) {
        case "N1":
          listLevel.add(FilterClassLevel.n1);
          break;
        case "N2":
          listLevel.add(FilterClassLevel.n2);
          break;
        case "N3":
          listLevel.add(FilterClassLevel.n3);
          break;
        case "N4":
          listLevel.add(FilterClassLevel.n4);
          break;
        case "N5":
          listLevel.add(FilterClassLevel.n5);
          break;
      }
    }


    return {
      AdminFilter.type: listType,
      AdminFilter.course: listCourse,
      AdminFilter.level: listLevel,
      AdminFilter.status: listStatus
    };
  }

  Future<Map<AdminFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filter');
    if (jsonString != null) {
      return convertFilterDecode(json.decode(jsonString));
    }
    return null;
  }

  _init() async {
    listCourse = await FireBaseProvider.instance.getAllCourseEnable();
    for (var i in listCourse!) {
      DataProvider.courseById(i.courseId, onLoaded, course: i);
    }
    _filter = await _fromPref() ??
        defaultFilter.keys.fold({}, (pre, key) {
          pre[key] = defaultFilter[key]!;
          return pre;
        });
    emit(state + 1);
  }

  onLoaded(Object object) {}

  update(AdminFilter adminFilter, List selectedList) async {
    bool areListsEqual =
        const ListEquality().equals(_filter[adminFilter], selectedList);
    if (!areListsEqual) {
      _filter[adminFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}
