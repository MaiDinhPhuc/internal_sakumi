import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/bill_statistic_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/class_statistic/class_statistic_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic_cubit.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cached_data_provider.dart';
import 'filter_admin_provider.dart';

enum StatisticFilter { type, course, level }

class StatisticFilterCubit extends Cubit<int> {
  StatisticFilterCubit() : super(0) {
    _init();
  }

  String tabType = 'student';

  final ClassStatisticCubit classStatisticCubit = ClassStatisticCubit();
  final StudentStatisticCubit studentStatisticCubit = StudentStatisticCubit();
  final BillStatisticCubit billStatisticCubit = BillStatisticCubit();

  List<CourseModel>? listCourse;

  static const Map<StatisticFilter, List> defaultFilter = {
    StatisticFilter.type: [FilterClassType.group,FilterClassType.one],
    StatisticFilter.course: [FilterClassCourse.general,FilterClassCourse.kaiwa,FilterClassCourse.jlpt,FilterClassCourse.kid],
    StatisticFilter.level: [FilterClassLevel.n5,FilterClassLevel.n4,FilterClassLevel.n3,FilterClassLevel.n2,FilterClassLevel.n1],
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

  changeTab(String value){
    tabType = value;
    emit(state+1);
  }

  loadData(StatisticFilterCubit filterController)async{
    if(tabType == 'bill'){
      billStatisticCubit.loadData(filterController);
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

  Map<StatisticFilter, List> _filter = {};

  Map<StatisticFilter, List> get filter => _filter;

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(convertFilterEncode());
    prefs.setString('filterStatistic', jsonString);
  }

  Map<String, dynamic> convertFilterEncode() {
    var listType = filter[StatisticFilter.type]!
        .map((e) => (e as FilterClassType).title)
        .toList();
    var listCourse = filter[StatisticFilter.course]!
        .map((e) => (e as FilterClassCourse).title)
        .toList();
    var listLevel = filter[StatisticFilter.level]!
        .map((e) => (e as FilterClassLevel).title)
        .toList();

    return {
      "type": listType,
      "course": listCourse,
      "level": listLevel
    };
  }

  Map<StatisticFilter, List> convertFilterDecode(dynamic json) {
    var listType = [];
    for (var i in json["type"]) {
      if (i == "Lớp Nhóm") {
        listType.add(FilterClassType.group);
      }
      if (i == "Lớp 1:1") {
        listType.add(FilterClassType.one);
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
      StatisticFilter.type: listType,
      StatisticFilter.course: listCourse,
      StatisticFilter.level: listLevel
    };
  }

  Future<Map<StatisticFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterStatistic');
    if (jsonString != null) {
      return convertFilterDecode(json.decode(jsonString));
    }
    return null;
  }

  _init() async {
    listCourse = await FireBaseProvider.instance.getAllCourse();
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

  update(StatisticFilter adminFilter, List selectedList) async {
    bool areListsEqual =
    const ListEquality().equals(_filter[adminFilter], selectedList);
    if (!areListsEqual) {
      _filter[adminFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}