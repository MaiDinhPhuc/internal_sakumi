import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ClassOverviewCubit extends Cubit<int> {
  ClassOverviewCubit() : super(0);
  ClassModel? classModel;
  List<StudentClassModel>? listStdClass;
  List<StudentModel>? students;
  List<double> listAttendance = [], listHomework = [];
  List<Map<String, dynamic>> listStdDetail = [];
  int countAvailable = 0;
  double percentHw = 0;
  List<String> listStudentStatusMenu = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];

  loadFirst(ClassModel2 classModel2, DataCubit dataCubit) async {
    if(classModel2.stdLessons == null){
      classModel = classModel2.classModel;
      emit(state + 1);
      dataCubit.loadLessonInfoOfClass(classModel2.classModel);
    }else{
      countAvailable = 0;
      listAttendance = [];
      listHomework = [];
      classModel = classModel2.classModel;
      emit(state + 1);
      List<int> listStdIds = [];
      for (var i in classModel2.stdClasses!) {
        if (i.classStatus != "Remove" &&
            i.classStatus != "Dropped" &&
            i.classStatus != "Deposit" &&
            i.classStatus != "Retained" &&
            i.classStatus != "Moved") {
          countAvailable++;
        }
        listStdIds.add(i.userId);
      }
      List<int> listLessonIds = [];
      for (var i in classModel2.lessonResults!) {
        if (listLessonIds.contains(i.lessonId) == false) {
          listLessonIds.add(i.lessonId);
        }
      }
      List<int> listStdIdsEnable = [];
      for (var element in classModel2.stdClasses!) {
        if (element.classStatus != "Remove" &&
            element.classStatus != "Moved" &&
            element.classStatus != "Retained" &&
            element.classStatus != "Dropped" &&
            element.classStatus != "Deposit" &&
            element.classStatus != "Viewer") {
          listStdIdsEnable.add(element.userId);
        }
      }

      for (var i in listLessonIds) {
        List<StudentLessonModel> listTemp = classModel2.stdLessons!
            .where((e) =>
        e.lessonId == i &&
            e.timekeeping != 0 &&
            listStdIdsEnable.contains(e.studentId))
            .toList();
        double tempAtt = 0;
        double tempHw = 0;
        for (var j in listTemp) {
          if (j.timekeeping < 5) {
            tempAtt++;
          }
          if (j.hw != -2) {
            tempHw++;
          }
        }

        listAttendance.add(tempAtt);
        listHomework.add(tempHw);
      }
      emit(state + 1);
      students =
      await FireBaseProvider.instance.getAllStudentInFoInClass(listStdIds);
      List<LessonModel> lessonTemp =
      classModel2.listLesson!.where((element) => element.btvn == 0).toList();
      List<int> lessonExceptionIds = [];
      for (var i in lessonTemp) {
        lessonExceptionIds.add(i.lessonId);
      }
      for (var i in classModel2.stdClasses!) {
        List<StudentLessonModel> stdLesson = classModel2.stdLessons!
            .where((element) => element.studentId == i.userId)
            .toList();
        List<int> listAttendance = [];
        List<int?> listHw = [];
        List<String> title = [];
        List<String> senseiNote = [];
        List<String> spNote = [];
        for (var j in stdLesson) {
          listAttendance.add(j.timekeeping);
          if (lessonExceptionIds.contains(j.lessonId)) {
            listHw.add(null);
          } else {
            listHw.add(j.hw);
          }
          title.add(classModel2.listLesson!
              .where((element) => element.lessonId == j.lessonId)
              .single
              .title);
          senseiNote.add(j.teacherNote);
          spNote.add(j.supportNote);
        }
        int tempAttendance = 0;
        int tempHw = 0;
        int countHw = 0;
        for (int j = 0; j < listAttendance.length; j++) {
          if (listAttendance[j] != 6 &&
              listAttendance[j] != 5 &&
              listAttendance[j] != 0) {
            tempAttendance++;
          }
          if (listAttendance[j] != 0) {
            if (listHw[j] != -2 && listHw[j] != null) {
              tempHw++;
            }
            if (listHw[j] != null) {
              countHw++;
            }
          }
        }

        int count = listAttendance.where((element) => element != 0).length;

        if (stdLesson.isEmpty) {
          listStdDetail.add({
            'id': i.userId,
            'status': i.classStatus,
            'attendance': listAttendance,
            'title': title,
            'hw': listHw,
            'attendancePercent': 0,
            'hwPercent': 0,
            'teacherNote': senseiNote,
            'spNote': spNote
          });
        } else {
          listStdDetail.add({
            'id': i.userId,
            'status': i.classStatus,
            'attendance': listAttendance,
            'title': title,
            'hw': listHw,
            'attendancePercent': tempAttendance / count,
            'hwPercent': tempHw / countHw,
            'teacherNote': senseiNote,
            'spNote': spNote
          });
        }
      }
      double count1 = 0;
      double total1 = 0;
      for (var i in classModel2.stdLessons!) {
        if (listStdIdsEnable.contains(i.studentId) && i.timekeeping != 0) {
          if (lessonExceptionIds.contains(i.lessonId) == false) {
            total1++;
            if (i.hw != -2) {
              count1++;
            }
          }
        }
      }
      percentHw = count1 / (total1 == 0 ? 1 : total1);
      listStdClass = classModel2.stdClasses;
      emit(state + 1);
    }
  }

  loadAfterRemove() async {
    emit(state + 1);
  }
}
