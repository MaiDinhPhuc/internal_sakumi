import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageBrowseDownloadCubit extends Cubit<int>{
  ManageBrowseDownloadCubit() : super(0){
    loadCount();
  }

  int count = 0;

  List<BrowseDownloadModel>? listBrowseDownload;
  List<ClassModel>? listClass;
  List<TeacherModel>? listTeacher;
  List<LessonModel>? listLesson;

  loadCount()async{
    count = await FireBaseProvider.instance
        .getCountWithCondition("browse_download", "status", "waiting");
    emit(count);
  }

  loadData()async{
    if(listBrowseDownload == null){
      listBrowseDownload = await FireBaseProvider.instance.getBrowseDownloadWaiting();
      var listClassId = listBrowseDownload!.map((e) => e.classId).toSet().toList();
      var listLessonId = listBrowseDownload!.map((e) => e.lessonId).toSet().toList();
      var listTeacherId = listBrowseDownload!.map((e) => e.teacherId).toSet().toList();
      listClass = await FireBaseProvider.instance.getListClassByListId(listClassId);
      listLesson = await FireBaseProvider.instance.getLessonsByLessonId(listLessonId);
      listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
      emit(state+1);
    }

  }

  update(int count){
    this.count = count;
    emit(state+1);
  }

}