import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAssignTeacherSurveyCubit extends Cubit<int>{
  ManageAssignTeacherSurveyCubit():super(0);


  List<TeacherSurveyModel>? listTeacherSurvey;
  List<TeacherModel> listTeacher = [];
  List<int> listTeacherId = [];

  int? userID;

  loadSurvey()async{
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    var role = localData.getString(PrefKeyConfigs.role);

    if (userId == null || userId == -1) return;

    if(userId != -1){
      userID = userId;
    }

    if(listTeacherSurvey != null) return;

    if (role == 'teacher' || role == "admin") return;

    if (role == 'master') {
      getDataFromFirebase();
    }
    debugPrint("==========>loadTeacherSurvey");
  }

  getDataFromFirebase()async{
    listTeacherSurvey = await FireBaseProvider.instance.getTeacherSurvey();
    listTeacherId = (listTeacherSurvey!.map((e) => e.teacherId)).toSet().toList();
    for(var i in listTeacherId){
      await DataProvider.teacherById(i, loadTeacherInfo);
    }
    emit(state+1);
  }

  update(){
    emit(state+1);
  }

  deleteTeacherSurvey(int id){
    listTeacherSurvey!.remove(listTeacherSurvey!.firstWhere((e) => e.id == id));
    emit(state+1);
  }

  addTeacherSurvey(TeacherSurveyModel model){
    listTeacherSurvey!.add(model);
  }


  loadTeacherInfo(Object student) {
    listTeacher.add(student as TeacherModel);
  }


  String convertDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  TeacherModel? getTeacher(int teacherId){
    var teacher = listTeacher.where((element) => element.userId == teacherId).toList();
    if(teacher.isEmpty) return null;
    return teacher.first;
  }

  deleteSurvey(TeacherSurveyModel model){
    listTeacherSurvey!.remove(model);
    emit(state+1);
  }
}