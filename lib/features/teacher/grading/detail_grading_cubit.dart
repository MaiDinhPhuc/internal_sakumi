import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
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
  ClassModel? classModel;
  CourseModel? courseModel;
  int now = 0;
  List<int> listChecked = [];
  bool isShowName = true;
  bool isGeneralComment = false;
  List<int>? listStudentId;
  List<bool>? listState;
  String token = "";

  init(context,String type) async {
    await loadFirst(context, type);
  }

  String getStudentName(AnswerModel answerModel) {
    for (var i in listStudent!) {
      if (i.userId == answerModel.studentId) {
        return i.name;
      }
    }
    return "";
  }

  updateAnswerView(int questionId) async {
    now = questionId;
    emit(0);
    emit(questionId);
  }

  loadingState(){
    emit(-2);
  }

  updateAfterGrading(int questionId) async {
    now = questionId;
    emit(questionId);
  }

  List<AnswerModel> get answers => listAnswer!
      .where((answer) =>
          answer.questionId == now &&
          listStudentId!.contains(answer.studentId))
      .toList();

  loadFirst(context, String type) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    UserRepository userRepository = UserRepository.fromContext(context);
    classModel = await teacherRepository.getClassById(int.parse(TextUtils.getName(position: 2)));
    courseModel = await teacherRepository.getCourseById(classModel!.courseId);
    token = courseModel!.token;
    if(type == "test"){
      listQuestions =
      await teacherRepository.getQuestionByUrl(AppConfigs.getDataUrl("test_${TextUtils.getName()}.json",token));
    }else{
      // listQuestions =
      // await teacherRepository.getQuestionByUrl(AppConfigs.getDataUrl("btvn_${TextUtils.getName()}.json",token));
      listQuestions =
      await teacherRepository.getQuestionByUrl("https://noibo.sakumi.edu.vn/files/e6cceec3aec49617978e81ec107d6b618738f757547c602a8fdd2af2cfd5836d721ba6c2943e38f5914adb2eaccdfb9cf3ce4f97fe50ce5f81d6fa4b20a45f14/btvn_102501.json");
    }

    listAnswer = await teacherRepository.getListAnswer(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)));

    if (listAnswer!.isEmpty) {
      emit(0);
    } else {
      List<StudentClassModel> listStudentClass = await teacherRepository
          .getStudentClassInClass(int.parse(TextUtils.getName(position: 2)));
      listStudent = [];
      for (var i in listStudentClass) {
        for (var j in listAnswer!) {
          if (i.userId == j.studentId) {
            listStudent!.add(await userRepository.getStudentInfo(i.userId));
            break;
          }
        }
      }
      listStudentId = [];
      for (var i in listStudent!) {
        listStudentId!.add(i.userId);
      }
      listState = [];
      checkDone(true);
      if (listQuestions!.isNotEmpty) {
        now = listQuestions!.first.id;
        emit(listQuestions!.first.id);
      } else {
        emit(0);
      }
    }
  }

  bool checkDone(bool isFirst) {
    if (isFirst) {
      for (var i in listQuestions!) {
        bool check = false;
        int count = 0;
        for (var j in getAnswerById(i.id)) {
          if (j.newScore != -1) {
            count++;
          }
        }
        if (count == getAnswerById(i.id).length) {
          check = true;
        }
        listState!.add(check);
      }
    }
    bool isDone = listState!.every((element) => element == true);
    return isDone;
  }

  List<AnswerModel> getAnswerById(int questionId) {
    List<AnswerModel> list =
        listAnswer!.where((answer) => answer.questionId == questionId).toList();
    return list;
  }

  change(int questionId, context) async {
    for (var i in listQuestions!) {
      if (i.id == questionId) {
        question = i;
        break;
      }
    }
    now = questionId;
    emit(questionId);
  }
}
