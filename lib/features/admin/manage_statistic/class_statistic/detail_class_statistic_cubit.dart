import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:intl/intl.dart';

import 'class_statistic_cubit.dart';

class DetailClassStatisticCubit extends Cubit<int>{
  DetailClassStatisticCubit(this.classStatisticCubit):super(0){
    loadData();
  }
  final ClassStatisticCubit classStatisticCubit;

  List<ClassModel> listClass = [];
  List<CourseModel> listCourse = [];
  List<int> listCourseId = [];
  List<int> listLessonResultCount = [];

  List<bool> level = [true,true,true,true,true];

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
    listClass.addAll(classStatisticCubit.listClass0);
    listClass.addAll(classStatisticCubit.listClass1);

    for(var i in listClass){
      if(listCourseId.contains(i.courseId) == false){
        listCourseId.add(i.courseId);
      }
      int count = (await FireStoreDb.instance.getCountLessonResult(i.classId)).count??0;
      listLessonResultCount.add(count);
      DataProvider.courseById(i.courseId, onCourseLoaded);
    }
  }

  double getPercent(int classId){
    if(listClass.isEmpty || listCourse.isEmpty) return 0;

    var index = listClass.indexOf(listClass.firstWhere((e) => e.classId == classId));

    if(index >= listLessonResultCount.length) return 0;

    return listLessonResultCount[index]/getCountLesson(classId);
  }

  int getLessonResult(int classId){
    if(listClass.isEmpty || listCourse.isEmpty) return 0;

    var index = listClass.indexOf(listClass.firstWhere((e) => e.classId == classId));

    if(index >= listLessonResultCount.length) return 0;

    return listLessonResultCount[index];
  }

  List<ClassModel> getListClass(StatisticFilterCubit filterController){

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

    return listClass.where((e) => listCourseId.contains(e.courseId) && classTypes.contains(e.classType)).toList();
  }

  String getCourse(int courseId){
    var courseModel = listCourse.where((e) => e.courseId == courseId).toList();

    if(courseModel.isEmpty) return "";

    return "${courseModel.first.name} ${courseModel.first.level} ${courseModel.first.termName}";
  }

  String convertDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  int getCountLesson(int classId){
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if(classModel.isEmpty) return 18;

    var courseModel = listCourse.where((e) => e.courseId == classModel.first.courseId).toList();

    if(courseModel.isEmpty) return 18;

    int count = courseModel.first.lessonCount;

    if(classModel.first.customLessons.isNotEmpty){
      count = count + classModel.first.customLessons.length;
    }
    return count;
  }

  update(){
    emit(state+1);
  }

  onCourseLoaded(Object course) {
    listCourse.add(course as CourseModel);
    emit(state+1);
  }

}