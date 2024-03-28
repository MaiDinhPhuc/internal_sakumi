import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';

class DetailSubCourseItemCubit extends Cubit<int> {
  DetailSubCourseItemCubit(this.lessonModel, this.cubit) : super(0) {
    loadData();
  }

  final LessonModel lessonModel;
  final SubCourseCubit cubit;
  List<StudentLessonModel>? stdLessons;
  List<StudentModel>? students;
  loadData() async {
    if (cubit.stdLessons != null) {
      stdLessons = cubit.stdLessons!
          .where((e) => e.lessonId == lessonModel.lessonId)
          .toList();
    }
    if (cubit.students.isNotEmpty) {
      var std = cubit.students;
      if(std.isNotEmpty){
        students = cubit.students;
      }else{
        students = [];
      }
    }
    emit(state + 1);
  }

  String getTime(int stdId, String field) {
    var stdLesson = stdLessons!.where((e) => e.studentId == stdId).toList();

    if (stdLesson.isEmpty) return "00:00:00";

    if (stdLesson.first.time.isEmpty) {
      return "00:00:00";
    } else if (stdLesson.first.time[field] == null) {
      return "00:00:00";
    } else {
      int seconds = stdLesson.first.time[field];

      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      String formattedTime =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
      return formattedTime;
    }
  }
}
