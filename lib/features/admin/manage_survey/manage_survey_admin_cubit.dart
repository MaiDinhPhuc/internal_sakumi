import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/survey_answer_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ManageSurveyAdminCubit extends Cubit<int> {
  ManageSurveyAdminCubit() : super(0);

  List<SurveyResultModel>? surveyResults;
  List<SurveyAnswerModel>? listSurveyAnswer;
  List<StudentClassModel>? stdClasses;

  loadSurvey() async {
    int classId = int.parse(TextUtils.getName());
    surveyResults =
        await FireBaseProvider.instance.getSurveyResultByClassId(classId);
    stdClasses = (await FireBaseProvider.instance
            .getStudentClassInClass(classId))
        .where((e) =>
            !["Remove", "Dropped", "Deposit", "Moved"].contains(e.classStatus))
        .toList();
    listSurveyAnswer =
        await FireBaseProvider.instance.getSurveyAnswerInClass(classId);
    emit(state + 1);
  }

  addSurveyToClass(SurveyModel survey, int id, int classId) {
    surveyResults!.add(SurveyResultModel(
        status: 'waiting',
        classId: classId,
        surveyId: survey.id,
        id: id,
        title: survey.title,
        surveyCode: survey.surveyCode,
        dateAssign: 0));
    emit(state + 1);
  }

  updateSurvey(SurveyResultModel result) {
    var index = surveyResults!
        .indexOf(surveyResults!.firstWhere((e) => e.id == result.id));
    surveyResults![index] = result;
    emit(state + 1);
  }

  deleteSurvey(SurveyResultModel result) {
    surveyResults!.remove(result);
    emit(state + 1);
  }

  int getNumber(int id) {
    var listAnswer = listSurveyAnswer!.where((e) => e.surveyId == id).toList();

    return listAnswer.isEmpty ? 0 : listAnswer.length;
  }
}
