import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class Create {

  static createSingleSchedule(ScheduleModel schedule)async{
    await FireBaseProvider.instance.addNewSchedule(schedule);
  }

  static addStudentToClass(StudentClassModel model){
    FireBaseProvider.instance.addStudentToClass(model);
  }

  static addNewLog(StudentClassLogModel stdClassLog){
    FireBaseProvider.instance.addNewLog(stdClassLog);
  }

  static Future<bool> createNewStudent(StudentModel model, UserModel userModel)async{
    var result =  await FireBaseProvider.instance.createNewStudent(model, userModel);
    return result;
  }

  static Future<bool> createNewClass(ClassModel model)async{
    var result = await FireBaseProvider.instance.createNewClass(model);
    return result;
  }

  static createSubClass(ClassModel subClass)async{
    await FireStoreDb.instance.createNewClass(subClass);
  }

  static Future<bool> addStudentLesson(StudentLessonModel model) async {
    var check = await FireBaseProvider.instance.addStudentLesson(model);
    return check;
  }

  static addLessonResult(LessonResultModel newLessonResult){
    FireBaseProvider.instance.addLessonResult(newLessonResult);
  }

  static Future<bool> createNewTeacher(TeacherModel model, UserModel userModel)async{
    var result = await FireBaseProvider.instance.createNewTeacher(model, userModel);
    return result;
  }

  static addTeacherToClass( TeacherClassModel model) async {
    await FireBaseProvider.instance.addTeacherToClass(model);
  }

  static addSurveyResult(SurveyModel survey, int classId, int id) async{
    await FireBaseProvider.instance.addSurveyToClass(survey, classId, id);
  }

  static addTeacherSurvey(TeacherSurveyModel model) async{
    await FireBaseProvider.instance.addTeacherSurvey(model);
  }

  static Future<bool> createNewCourse(CourseModel model)async{
    var result = await FireBaseProvider.instance.addNewCourse(model);
    return result;
  }

  static Future<bool> createNewLesson(LessonModel model)async{
    var result = await FireBaseProvider.instance.addNewLesson(model);
    return result;
  }

  static Future<bool> createNewTest(TestModel model)async{
    var result = await FireBaseProvider.instance.addNewTest(model);
    return result;
  }

  static createNewBrowseDownload(BrowseDownloadModel model)async{
    await FireBaseProvider.instance.createNewBrowseDownload(model);
  }

}