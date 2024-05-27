import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class RequestBrowseDownloadCubit extends Cubit<int> {
  RequestBrowseDownloadCubit(this.listLessons, this.classModel) : super(0) {
    loadData();
  }

  final List<LessonModel> listLessons;
  final ClassModel classModel;
  List<BrowseDownloadModel>? listBrowseDownload;
  List<LessonModel> listCustomLesson = [];
  CourseModel? course;

  bool loading = true;

  loadData() async {
    loading = false;

    DataProvider.courseById(classModel.courseId, onCourseLoaded);

    listBrowseDownload = await FireBaseProvider.instance
        .getBrowseDownloadWaitingByClassId(classModel.classId);

    for (var i in listLessons) {
      if (i.isCustom) {
        List<int> listCustomLessonId = [];
        for (var j in i.customLessonInfo) {
          listCustomLessonId.add(j['lesson_id']);
        }
        var listTemp = await FireBaseProvider.instance
            .getLessonsByLessonId(listCustomLessonId);
        for (var k in listTemp) {
          if (listCustomLesson.contains(k) == false) {
            listCustomLesson.add(k);
          }
        }
      }
    }

    emit(1);
  }

  createNewRequest(BrowseDownloadModel newRequest) {
    listBrowseDownload!.add(newRequest);
    emit(state + 1);
  }

  updateRequest(BrowseDownloadModel newRequest) {
    var index = listBrowseDownload!
        .indexWhere((element) => element.id == newRequest.id);
    listBrowseDownload![index] = newRequest;
    emit(state + 1);
  }

  getListCustom(List<int> listCustomLessonId) {
    var list = [];
    for(var i in listCustomLesson) {
      if(listCustomLessonId.contains(i.lessonId)) {
        list.add(i);
      }
    }
    return list;
  }


  onCourseLoaded(Object course) {
    course = (course as CourseModel);
    emit(state + 1);
  }
}
