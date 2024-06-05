import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';

class ManageBrowseDownloadInClassCubit extends Cubit<int>{
  ManageBrowseDownloadInClassCubit() : super(0);

  List<BrowseDownloadModel>? listBrowseDownload;
  List<ClassModel>? listClass;
  List<TeacherModel>? listTeacher;
  List<LessonModel>? listLesson;

  loadData()async{
    if(listBrowseDownload == null){
      int classId = int.parse(TextUtils.getName());
      listBrowseDownload = await FireBaseProvider.instance.getAllBrowseDownloadByClassId(classId);
      var listClassId = listBrowseDownload!.map((e) => e.classId).toSet().toList();
      var listLessonId = listBrowseDownload!.map((e) => e.lessonId).toSet().toList();
      var listTeacherId = listBrowseDownload!.map((e) => e.teacherId).toSet().toList();
      listClass = await FireBaseProvider.instance.getListClassByListId(listClassId);
      listLesson = await FireBaseProvider.instance.getLessonsByLessonId(listLessonId);
      listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
      emit(state+1);
    }

  }

  String getClassCode(int classId){
    var classModel = listClass!.where((element) => element.classId == classId).toList();
    if(classModel.isEmpty) return "";
    return classModel.first.classCode;
  }

  TeacherModel? getTeacher(int teacherId){
    var teacher = listTeacher!.where((element) => element.userId == teacherId).toList();
    if(teacher.isEmpty) return null;
    return teacher.first;
  }

  String getTitle(int lessonId){
    var lesson = listLesson!.where((element) => element.lessonId == lessonId).toList();
    if(lesson.isEmpty) return "";
    return lesson.first.title;
  }

  String convertDate(int time){
    if(time == 0) return "";
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  updateRequest(BrowseDownloadModel model){
    var index = listBrowseDownload!.indexWhere((element) => element.id == model.id);
    listBrowseDownload![index] = model;
    emit(state+1);
  }

}