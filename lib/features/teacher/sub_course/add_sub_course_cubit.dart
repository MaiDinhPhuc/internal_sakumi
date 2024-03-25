import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class AddSubCourseCubit extends Cubit<int>{
  AddSubCourseCubit():super(0){
    loadData();
  }

  List<CourseModel>? courses;
  String? selector;
  int? courseId;

  loadData() async {
    courses = (await FireBaseProvider.instance.getAllCourseEnable())
    .where((e) => e.courseId != 999999999)
        .toList();
    emit(state + 1);
  }


  String findCourse(int courseId)  {
    for(var i in courses!){
      if(i.courseId == courseId){
        return '${i.title} ${i.termName} ${i.code}';
      }
    }
    return AppText.textChooseCourse.text;
  }

  chooseCourse(String? text) async {
    selector = text;
    await getCourseId(selector!);
    emit(state + 1);
  }

  getCourseId(String text) async {
    CourseModel course = courses!.singleWhere((element) => '${element.title} ${element.termName} ${element.code}' == text);
    courseId = course.courseId;
  }
}