import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/calculator/calculator.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverViewTabCubit extends Cubit<int> {
  OverViewTabCubit(this.role) : super(0) {
    loadData();
  }
  final String role;
  int? userId;
  List<TeacherClassModel>? teacherClasses;
  List<ClassModel>? classes;

  List<LessonModel> lessons = [];
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;

  double? hwPercent, attendancePercent, levelUpPercent;

  loadData() async {
    if (role == 'teacher') {
      SharedPreferences localData = await SharedPreferences.getInstance();
      int userId = localData.getInt(PrefKeyConfigs.userId)!;
      this.userId = userId;
    } else {
      int userId = int.parse(TextUtils.getName());
      this.userId = userId;
    }
    teacherClasses =
    (await FireBaseProvider.instance.getTeacherClassById(userId!)).where((e) => e.responsibility == true).toList();
    var listClassId = teacherClasses!.map((e) => e.classId).toList();
    classes =
    await FireBaseProvider.instance.getListClassByListIdV2(listClassId);
    stdLessons = await FireBaseProvider.instance.getAllStudentLessonsInListClassId(listClassId);
    stdClasses = await FireBaseProvider.instance.getStudentClassByListId(listClassId);
    for(var i in classes!){
      if(i.customLessons.isEmpty){
        await DataProvider.lessonByCourseId(i.courseId, loadLessonInClass);
      }else{
        await DataProvider.lessonByCourseAndClassId(i.courseId,i.classId, loadLessonInClass);

        var lessonId = lessons.map((e) => e.lessonId).toList();

        if(i.customLessons.isNotEmpty){
          for(var j in i.customLessons){
            if(!lessonId.contains(j['custom_lesson_id'])){
              lessons.add(LessonModel(
                  lessonId: j['custom_lesson_id'],
                  courseId: -1,
                  description: j['description'],
                  content: "",
                  title: j['title'],
                  btvn: -1,
                  vocabulary: 0,
                  listening: 0,
                  kanji: 0,
                  grammar: 0,
                  flashcard: 0,
                  alphabet: 0,
                  order: 0,
                  reading: 0,
                  enable: true,
                  customLessonInfo: j['lessons_info'],
                  isCustom: true));
            }
          }
        }
      }
    }

    attendancePercent = Calculator.classAttendancePercent(stdClasses!, stdLessons!, lessons);

    hwPercent = Calculator.classHwPercent(stdClasses!, stdLessons!, lessons);

    levelUpPercent = Calculator.getPercentUpSale(stdClasses!);

    emit(state+1);
  }

  loadLessonInClass(Object lessons) {
    var newLessons = lessons as List<LessonModel>;
    for(var i in newLessons){
      if(this.lessons.contains(i) == false){
        this.lessons.add(i);
      }
    }
  }
}
