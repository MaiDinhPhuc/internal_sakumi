import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CustomLessonCubit extends Cubit<int>{
  CustomLessonCubit(this.classModel):super(0){
    loadData();
  }

  final TextEditingController desCon = TextEditingController();
  final TextEditingController titleCon = TextEditingController();
  ClassModel classModel;

  List<Map> listLessonInfo = [];

  Map temp = {};

  List<CourseModel>? courses;
  List<LessonModel> lessons = [];
  int count = 1;

  loadData()async{
    courses = (await FireBaseProvider.instance.getAllCourseEnable()).where((e) => e.courseId != classModel.courseId).toList();
    emit(state+1);
  }


  chooseCourse(String? text) async {
    CourseModel course = courses!.singleWhere((element) => '${element.title} ${element.termName} ${element.code}' == text);
    int courseId = course.courseId;
    if(temp != {} && course.courseId != temp["courseId"]){
      lessons = [];
      emit(state+1);
      //DataProvider.lessonByCourseId(courseId, loadLesson);
    }else{
      temp = {
        "courseId" : courseId
      };
      DataProvider.lessonByCourseId(courseId, loadLesson);
    }
  }

  chooseLesson(String? text) async {
    LessonModel lesson = lessons.singleWhere((element) => element.title == text);
    int lessonId = lesson.lessonId;
    temp = {
      "courseId" : temp["courseId"],
      "lessonId" : lessonId
    };
    listLessonInfo.add(temp);
    temp = {};
  }

  loadLesson(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
    emit(state+1);
  }

}