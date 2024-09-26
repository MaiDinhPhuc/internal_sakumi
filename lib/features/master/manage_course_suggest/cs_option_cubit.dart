import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_suggest_model.dart';
import 'package:internal_sakumi/model/cs_option.dart';

import '../../../model/course_model.dart';
import '../../../model/tag_model.dart';
import '../../../providers/firebase/firebase_provider.dart';
import '../../../utils/functions.dart';

class CSOptionCubit extends Cubit<int> {
  CSOptionCubit(this.courseSuggest) : super(0);
  final CourseSuggestModel? courseSuggest;
  List<TagModel> tags = [];
  List<CourseModel> courses = [];

  CSOption? csTag;
  CSOption? csCourse;
  bool favorite = false;

  update(){
    favorite = !favorite;
    emit(state+1);
  }

  load() async {
    if(courseSuggest != null) {
      favorite = courseSuggest!.favorite;
      csTag = await FireBaseProvider.instance.getCSOptionByIdAndType(courseSuggest!.id, 1);
      csCourse = await FireBaseProvider.instance.getCSOptionByIdAndType(courseSuggest!.id, 2);

      if(csTag != null) {
        tags = await Functions.getTags(csTag!.parents.map((e) => e as int).toList());
      }
      if(csCourse != null) {
        courses = await Functions.getCourses(csCourse!.parents.map((e) => e as int).toList());
      }
    }
    emit(state + 1);
  }

  Future<bool> changeListTag(List<TagModel> t) async {
    bool value = false;
    tags = [...t];
    if(csTag == null) {
      csTag = CSOption(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 1, csId: courseSuggest!.id,
          parents: tags.map((e) => e.id).toList());
      value = await FireBaseProvider.instance.addCSOption(csTag!);
    }
    else {
      csTag = csTag!.copyWith(
          parents: tags.map((e) => e.id).toList()
      );
      value = await FireBaseProvider.instance.addCSOption(csTag!);
    }
    emit(state+1);
    return value;
  }

  Future<bool> deleteTagItem(TagModel item) async {
    tags.remove(item);
    return changeListTag(tags);
  }

  Future<bool> changeListCourse(List<CourseModel> t) async {
    bool value = false;
    courses = [...t];
    if(csCourse == null) {
      csCourse = CSOption(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 2, csId: courseSuggest!.id,
          parents: courses.map((e) => e.courseId).toList());
      value = await FireBaseProvider.instance.addCSOption(csCourse!);
    }
    else {
      csCourse = csCourse!.copyWith(
          parents: courses.map((e) => e.courseId).toList()
      );
      value = await FireBaseProvider.instance.addCSOption(csCourse!);
    }
    emit(state+1);
    return value;
  }

  Future<bool> deleteCourseItem(CourseModel e)async {
    courses.remove(e);
    return changeListCourse(courses);
  }
}