import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';


class DetailGradingCubit extends Cubit<int> {
  DetailGradingCubit() : super(-1);

  List<QuestionModel>? listQuestions;
  QuestionModel? question;
  List<AnswerModel>? listAnswer;
  List<StudentModel>? listStudent;
  init(context) async {
    await loadQuestionInLesson(context);
  }

  loadQuestionInLesson(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    listQuestions = await teacherRepository.getQuestionByLessonId(TextUtils.getName());

    emit(listQuestions!.first.id);

  }

  change(int questionId, context)async {
    for(var i in listQuestions!){
      if(i.id == questionId){
        question = i;
        break;
      }
    }
    emit(questionId);
  }
}
