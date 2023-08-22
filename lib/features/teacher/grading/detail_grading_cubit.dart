import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';


class DetailGradingCubit extends Cubit<int> {
  DetailGradingCubit() : super(-1);

  List<QuestionModel>? listQuestions;
  QuestionModel? question;
  List<AnswerModel>? listAnswer;
  List<StudentModel>? listStudent;
  int count = 0;
  List<int> listChecked = [];
  bool isShowName = true;
  bool isGeneralComment = false;
  List<int>? listStudentId;
  init(context) async {
    await loadFirst(context);
  }

  String getStudentName(AnswerModel answerModel){
    for(var i in listStudent!){
      if(i.userId == answerModel.studentId){
        return i.name;
      }
    }
    return "";
  }

  updateAnswerView(int questionId)async{
   emit(0);
   emit(questionId);
  }
  updateAfterGrading(int questionId)async{
    emit(-2);
    await Future.delayed(const Duration(milliseconds: 2000));
    emit(questionId);
  }

  List<AnswerModel> get answers => listAnswer!.where((answer) => answer.questionId == state && listStudentId!.contains(answer.studentId)).toList();

  loadFirst(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    UserRepository userRepository =
    UserRepository.fromContext(context);
    listQuestions = await teacherRepository.getQuestionByLessonId(TextUtils.getName());
    listAnswer = await teacherRepository.getAnswersOfQuestion(int.parse(TextUtils.getName()),int.parse(TextUtils.getName(position: 2)));

    List<StudentClassModel> listStudentClass = await teacherRepository.getStudentClassInClass(int.parse(TextUtils.getName(position: 2)));
    listStudent = [];
    for(var i in listStudentClass){
      for(var j in listAnswer!){
        if(i.userId == j.studentId){
          listStudent!.add(await userRepository.getStudentInfo(i.userId));
          break;
        }
      }
    }
    listStudentId = [];
    for(var i in listStudent!){
      listStudentId!.add(i.userId);
    }
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
