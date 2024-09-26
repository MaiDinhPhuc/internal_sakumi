import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/course_suggest_model.dart';
import 'package:internal_sakumi/utils/functions.dart';

import '../../../providers/firebase/firebase_provider.dart';

class ManageCourseSuggestCubit extends Cubit<int> {
  ManageCourseSuggestCubit() : super(0);


  List<CourseSuggestModel> courseSuggests = [];
  List<CourseModel> courses = [];

  CourseSuggestModel? get currentCS => courseSuggests.isEmpty ? null : courseSuggests[csIndex];
  int csIndex = 0;

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load() async {
    courseSuggests = await FireBaseProvider.instance.getCourseSuggests();
    sort();
    courses = await Functions.getCourses(courseSuggests.map((e) => e.idCourse).toList());
    csIndex = 0;
    emitState();
  }

  setCurrentIndex(int index) {
    csIndex = index;
    emitState();
  }

  sort() {
    courseSuggests.sort((a,b) => a.idCourse.compareTo(b.idCourse));
  }

  updateFavorite()async{
    CourseSuggestModel model = CourseSuggestModel(id: courseSuggests[csIndex].id, idCourse: courseSuggests[csIndex].idCourse, favorite: !courseSuggests[csIndex].favorite);
    await FireBaseProvider.instance.addCourseSuggest(model);
    courseSuggests[csIndex] = model;
    //emit(state+1);
  }

  Future<bool> updateCourses(List<CourseModel> data) async {
    var temp = [...data];

    for (var i in courseSuggests) {
      if(!temp.map((e) => e.courseId).contains(i.idCourse)){
        final index  = courseSuggests.indexOf(i);
        deleteCS(index);
      }
    }
    temp.removeWhere((element) => courseSuggests.map((e) => e.idCourse).contains(element.courseId));
    for (var i in temp) {
      var cs = CourseSuggestModel(id: DateTime.now().millisecondsSinceEpoch, idCourse: i.courseId, favorite: false);
      courseSuggests.add(cs);
      await FireBaseProvider.instance.addCourseSuggest(cs);
    }
    courses = [...data];
    if(csIndex >= courses.length)  {
      csIndex = 0;
    }
    sort();
    emitState();

    return true;

  }

  Future<bool> deleteCS(int index) async {

    var csTag = await FireBaseProvider.instance.getCSOptionByIdAndType(courseSuggests[index].id, 1);
    var csCourse = await FireBaseProvider.instance.getCSOptionByIdAndType(courseSuggests[index].id, 2);
    if(csTag != null) {
      await FireBaseProvider.instance.deleteCSOption('cs_option_${csTag.id}');
    }
    if(csCourse != null) {
      await FireBaseProvider.instance.deleteCSOption('cs_option_${csCourse.id}');
    }
    bool value =
    await FireBaseProvider.instance.deleteCourseSuggest(courseSuggests[index]);

    if (value) {
      courses.removeWhere((element) => element.courseId == courseSuggests[index].idCourse);
      courseSuggests.removeAt(index);
      if (index == csIndex) {
        csIndex = 0;
      }
      if (csIndex > index) {
        csIndex--;
      }
      emitState();
    }

    return value;
  }


  // Future<bool> deleteBanner(int index) async {
  //
  //   var bannerTag = await FireBaseProvider.instance.getBannerOptionByIdAndType(banners[index].id, 1);
  //   var bannerCourse = await FireBaseProvider.instance.getBannerOptionByIdAndType(banners[index].id, 2);
  //   if(bannerTag != null) {
  //     await FireBaseProvider.instance.deleteBannerOption('banner_option_${bannerTag.id}');
  //   }
  //   if(bannerCourse != null) {
  //     await FireBaseProvider.instance.deleteBannerOption('banner_option_${bannerCourse.id}');
  //   }
  //   bool value =
  //   await FireBaseProvider.instance.deleteBanner('banner_${banners[index].id}');
  //
  //   if (value) {
  //     banners.removeAt(index);
  //     if (index == bannerIndex) {
  //       bannerIndex = 0;
  //     }
  //     if (bannerIndex > index) {
  //       bannerIndex--;
  //     }
  //     emitState();
  //   }
  //
  //   return value;
  // }
}
