import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/homework_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailGradingCubit extends Cubit<int> {
  DetailGradingCubit() : super(0);

  List<QuestionModel>? listQuestions;
  HomeworkModel? homework;
  QuestionModel? question;
  List<AnswerModel>? listAnswer;

  init(context) async {
    await loadQuestionInLesson(context);
  }

  loadQuestionInLesson(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    homework = await teacherRepository.getHomework(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)));

    listQuestions = [];
    if (homework != null) {
      for (int i in homework!.questions) {
        listQuestions!.add(await teacherRepository.getQuestionByQuestionId(i));
      }
    } else {
      listQuestions = await teacherRepository
          .getDefaultHwQuestionByLessonId(int.parse(TextUtils.getName()));
    }
    listAnswer = await teacherRepository.getAnswerOfQuestion(listQuestions!.first.id,int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)));
    for(var i in listQuestions!){
      if(i.id == listQuestions!.first.id){
        question = i;
        break;
      }
    }
    emit(listQuestions!.first.id);


  }

  change(int questionId, context)async {
    TeacherRepository teacherRepository = TeacherRepository.fromContext(context);
    listAnswer = await teacherRepository.getAnswerOfQuestion(questionId,int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)));
    emit(questionId);
    for(var i in listQuestions!){
      if(i.id == state){
        question = i;
        break;
      }
    }
  }
}
