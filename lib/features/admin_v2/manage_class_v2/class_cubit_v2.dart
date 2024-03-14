import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_teacher_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassCubit extends Cubit<int> {
  ClassCubit() : super(0);
  bool isLastPage = false;

  List<ClassModel>? listClass;

  List<List<ClassModel>> listLastClass = [];

  List<String> listClassStatusMenuAdmin2 = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel"
  ];

  String? role;

  loadDataAdmin(AdminClassFilterCubit filterCubit) async {
    if (filterCubit.filter.keys.isNotEmpty) {
      List<int> listCourseId = filterCubit.getCourseId(
          filterCubit.filter[AdminFilter.course]!,
          filterCubit.filter[AdminFilter.level]!);
      int courseSize = (30 /
              (filterCubit.filter[AdminFilter.status]!.length *
                  filterCubit.filter[AdminFilter.type]!.length))
          .floor();

      listClass = [];
      List<List<int>> subLists = [];
      for (int i = 0; i < listCourseId.length; i += courseSize) {
        List<int> subList = listCourseId.sublist(
            i,
            i + courseSize > listCourseId.length
                ? listCourseId.length
                : i + courseSize);
        subLists.add(subList);
      }
      List<ClassModel> lastClasses = [];
      for (int i = 0; i < subLists.length; i++) {
        List<ClassModel> list =
            await DataProvider.classListAdmin(filterCubit.filter, 1, subLists[i]);
        listClass!.addAll(list);
        lastClasses.add(listClass!.last);
      }
      listLastClass.add(lastClasses);
    }

    role = "admin";
    emit(state + 1);
  }

  loadMore(AdminClassFilterCubit filterCubit) async {
    List<int> listCourseId = filterCubit.getCourseId(
        filterCubit.filter[AdminFilter.course]!,
        filterCubit.filter[AdminFilter.level]!);
    int courseSize = (30 /
            (filterCubit.filter[AdminFilter.status]!.length *
                filterCubit.filter[AdminFilter.type]!.length))
        .floor();
    List<List<int>> subLists = [];
    for (int i = 0; i < listCourseId.length; i += courseSize) {
      List<int> subList = listCourseId.sublist(
          i,
          i + courseSize > listCourseId.length
              ? listCourseId.length
              : i + courseSize);
      subLists.add(subList);
    }
    List<ClassModel> lastClasses = listLastClass.last;
    List<ClassModel> lastClassesNew = [];
    for (var i in subLists) {
      List<ClassModel> list = await DataProvider.classListAdmin(
          filterCubit.filter, 1, i,
          lastItem: lastClasses[subLists.indexOf(i)]);
      if (list.isEmpty) {
        isLastPage = true;
      }
      if(list.isNotEmpty){
        listClass!.addAll(list);
        lastClassesNew.add(list.last);
      }
    }

    if(lastClassesNew.isNotEmpty){
      listLastClass.add(lastClassesNew);
    }

    emit(state + 1);
  }

  updateClass(ClassModel classModel) {
    var index = listClass!
        .indexOf(listClass!.firstWhere((e) => e.classId == classModel.classId));

    listClass![index] = classModel;
    emit(state + 1);
  }

  loadDataTeacher(TeacherClassFilterCubit filterController)async{
    role = "teacher";
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);
    listClass = await DataProvider.classListTeacher(userId!, filterController.filter);
    emit(state+1);
  }
}
