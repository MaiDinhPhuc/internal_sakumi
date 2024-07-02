import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/banner_model.dart';
import 'package:internal_sakumi/model/banner_option.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/utils/functions.dart';

import '../../../providers/firebase/firebase_provider.dart';

class BannerOptionCubit extends Cubit<int> {
  BannerOptionCubit(this.bannerModel) : super(0);
  final BannerModel? bannerModel;
  List<TagModel> tags = [];
  List<CourseModel> courses = [];

  BannerOption? bannerTag;
  BannerOption? bannerCourse;

  load() async {
    if(bannerModel != null) {
      bannerTag = await FireBaseProvider.instance.getBannerOptionByIdAndType(bannerModel!.id, 1);
      bannerCourse = await FireBaseProvider.instance.getBannerOptionByIdAndType(bannerModel!.id, 2);
      print('bannerTag: $bannerTag');
      if(bannerTag != null) {
        tags = await Functions.getTags(bannerTag!.parents.map((e) => e as int).toList());
      }
      if(bannerCourse != null) {
        courses = await Functions.getCourses(bannerCourse!.parents.map((e) => e as int).toList());
      }
    }
    emit(state + 1);
  }

  Future<bool> changeListTag(List<TagModel> t) async {
    bool value = false;
    tags = [...t];
    if(bannerTag == null) {
      bannerTag = BannerOption(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 1, bannerId: bannerModel!.id,
          parents: tags.map((e) => e.id).toList());
      value = await FireBaseProvider.instance.addBannerOption(bannerTag!);
    }
    else {
      bannerTag = bannerTag!.copyWith(
        parents: tags.map((e) => e.id).toList()
      );
      value = await FireBaseProvider.instance.addBannerOption(bannerTag!);
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
    if(bannerCourse == null) {
      bannerCourse = BannerOption(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 2, bannerId: bannerModel!.id,
          parents: courses.map((e) => e.courseId).toList());
      value = await FireBaseProvider.instance.addBannerOption(bannerCourse!);
    }
    else {
      bannerCourse = bannerCourse!.copyWith(
          parents: courses.map((e) => e.courseId).toList()
      );
      value = await FireBaseProvider.instance.addBannerOption(bannerCourse!);
    }
    emit(state+1);
    return value;
  }

  Future<bool> deleteCourseItem(CourseModel e)async {
    courses.remove(e);
    return changeListCourse(courses);
  }
}
