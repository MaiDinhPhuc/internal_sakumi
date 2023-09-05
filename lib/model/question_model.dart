import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final int id, lessonId, questionType, owner, skill;
  final String a,
      b,
      c,
      d,
      answer,
      question,
      explain,
      refer,
      instruction,
      part,
      paragraph;
  final String image, sound, video;
  final bool isHwDefault, isTestDefault;

  QuestionModel(
      {required this.id,
        required this.lessonId,
        required this.a,
        required this.b,
        required this.c,
        required this.d,
        required this.answer,
        required this.question,
        required this.skill,
        required this.image,
        required this.sound,
        required this.questionType,
        required this.isHwDefault,
        required this.isTestDefault,
        required this.video,
        required this.explain,
        required this.owner,
        required this.refer,
        required this.instruction,
        required this.paragraph,
        required this.part});

  List<String> get listImage => image.split(";").toList();
  List<String> get listSound => sound.split(";").toList();
  List<String> get listVideo => video.split(";").toList();
  List<String> get listAnswer => [a,b,c,d];
  String get convertQuestion => convert(question,questionType);

  String convert(String question, int questionType){
    String convertedQuestion = "";
    if (questionType == 7) {
      convertedQuestion = question.replaceAll("/", " ");
    } else if (questionType == 8) {
      convertedQuestion =
          question.replaceAll(";", "\n").replaceAll("|", "-");
    } else if (questionType == 10) {
      convertedQuestion = "";
    } else {
      convertedQuestion = question;
    }
    return convertedQuestion;
  }

  factory QuestionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return QuestionModel(
        id: data['id'],
        lessonId: data['lesson_id'],
        a: data['a'],
        b: data['b'],
        c: data['c'],
        d: data['d'],
        answer: data['answer'],
        question: data['question'],
        skill: data['skill'],
        image: data['image'],
        sound: data['sound'],
        video: data['video'],
        explain: data['explain'],
        refer: data['refer'],
        questionType: data['question_type'],
        isHwDefault: data['is_hw_default'],
        isTestDefault: data['is_test_default'],
        owner: data['owner'],
        instruction: data['instruction'],
        paragraph: data['paragraph'],
        part: data['part']);
  }

  factory QuestionModel.fromMap(Map<String, dynamic> json) => QuestionModel(
      id: json['id'],
      lessonId: json['lesson_id']??0,
      a: json['a']??"",
      b: json['b']??"",
      c: json['c']??"",
      d: json['d']??"",
      answer: json['answer']??"",
      question: json['question']??"",
      skill: json['skill_id']??0,
      image: json['image']??"",
      sound: json['sound']??"",
      video: json['video']??"",
      questionType: json['question_type']??0,
      refer: json['refer']??"",
      explain: json['explain']??"",
      isTestDefault: json['is_hw_default']??false,
      isHwDefault: json['is_test_default']??false,
      owner: json['owner']??0,
      instruction: json['instruction']??"",
      paragraph: json['paragraph']??"",
      part: json['part']??"");
}
