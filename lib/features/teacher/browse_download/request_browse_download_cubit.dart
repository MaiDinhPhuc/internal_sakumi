import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RequestBrowseDownloadCubit extends Cubit<int> {
  RequestBrowseDownloadCubit(this.listLessons, this.classModel) : super(0) {
    loadData();
  }

  final List<LessonModel> listLessons;
  final ClassModel classModel;
  List<BrowseDownloadModel>? listBrowseDownload;
  List<LessonModel> listCustomLesson = [];
  List<CourseModel> listCourse = [];

  int? teacherId;

  bool loading = true;

  loadData() async {
    loading = false;

    DataProvider.courseById(classModel.courseId, onCourseLoaded);

    SharedPreferences localData = await SharedPreferences.getInstance();
    teacherId = localData.getInt(PrefKeyConfigs.userId)!;

    listBrowseDownload = await FireBaseProvider.instance
        .getBrowseDownloadWaitingAndAcceptByClassAndTeacherId(
            classModel.classId, teacherId!);

    var listCourseId = [classModel.courseId];

    for (var i in listLessons) {
      if (i.isCustom) {
        List<int> listCustomLessonId = [];
        for (var j in i.customLessonInfo) {
          listCustomLessonId.add(j['lesson_id']);
          if(listCourseId.contains(j['course_id']) == false){
            listCourseId.add(j['course_id']);
          }
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

    for(var i in listCourseId){
      await DataProvider.courseById(i, onCourseLoaded);
    }

    emit(1);
  }

  createNewRequest(BrowseDownloadModel newRequest) {
    listBrowseDownload!.add(newRequest);
    emit(state + 1);
  }

  updateRequest(BrowseDownloadModel request) {
    listBrowseDownload!.remove(request);
    emit(state + 1);
  }

  List<LessonModel> getListCustom(List<int> listCustomLessonId) {
    List<LessonModel> list = [];
    for (var i in listCustomLesson) {
      if (listCustomLessonId.contains(i.lessonId)) {
        list.add(i);
      }
    }
    return list;
  }

  onCourseLoaded(Object course) {
    listCourse.add(course as CourseModel);
  }

  void downloadFile(String url) {

    var newWindow = js.context.callMethod('open', [url, '_blank']);

    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;

    newWindow.document.body.append(anchorElement);
    anchorElement.click();
    print(url);
  }

  bool checkRequest(int lessonId){

    if(listBrowseDownload == null) return false;

    var list = listBrowseDownload!.where((element) => element.lessonId == lessonId).toList();
    if(list.isEmpty) return false;
    return true;
  }

  bool checkCustomRequest(int lessonId, int parentId){

    if(listBrowseDownload == null) return false;

    var list = listBrowseDownload!.where((element) => element.lessonId == lessonId && element.parentId == parentId).toList();
    if(list.isEmpty) return false;
    return true;
  }

  checkEnableDownload(int lessonId){
    if(listBrowseDownload == null) return false;
    var list = listBrowseDownload!.where((e) => e.status == 'accept' && e.lessonId == lessonId ).toList();
    if(list.isEmpty) return false;
    return true;
  }

  checkCustomEnableDownload(int lessonId, int parentId){
    if(listBrowseDownload == null) return false;
    var list = listBrowseDownload!.where((e) => e.status == 'accept' && e.lessonId == lessonId && e.parentId == parentId).toList();
    if(list.isEmpty) return false;
    return true;
  }

  String getLinkDownload(LessonModel lessonModel){
    if(listBrowseDownload == null) return '';
    var list = listCourse.where((element) => element.courseId == lessonModel.courseId).toList();
    if(list.isEmpty) return '';
    if(list.first.dataToken == "_") return '';

    String hash = md5.convert(utf8.encode('${lessonModel.courseId} ${lessonModel.lessonId} sakumi2024')).toString();

    String fileToken = '${lessonModel.courseId}_${lessonModel.lessonId}_${hash.substring(0,10)}';

    return AppConfigs.getDownloadUrl(fileToken, list.first.dataToken);
    //return AppConfigs.getDataUrl("", list.first.dataToken) ;
  }
}
