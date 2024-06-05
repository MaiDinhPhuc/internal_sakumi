import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAssignTeacherSurveyCubit extends Cubit<int>{
  ManageAssignTeacherSurveyCubit():super(0);

  TextEditingController teacherCon = TextEditingController();

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
      DataProvider.teacherById(i, loadTeacherInfo);
    }
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
    if(listTeacherId.length == listTeacher.length){
      emit(state+1);
    }
  }

}