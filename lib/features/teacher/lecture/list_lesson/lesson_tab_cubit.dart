import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class LessonTabCubit extends Cubit<int> {
  LessonTabCubit() : super(0);

  ClassModel? classModel;
  List<String?>? listSpNote;
  List<String?>? listTeacherNote;
  List<Map<String, dynamic>?>? listDetailLesson;
  List<TeacherModel?>? listTeacher;
  List<double?>? listAttendance;
  List<double?>? listHw;
  List<bool?>? listHwStatus;
  List<String>? listStatus;
  List<Map<String, dynamic>>? listLessonInfo;
  List<String>? listTeachingDay;

  load(ClassModel2 classModel2, DataCubit dataCubit)async{
    if(classModel2.stdLessons == null){
      classModel = classModel2.classModel;
      emit(state + 1);
      dataCubit.loadLessonInfoOfClass(classModel2.classModel);
    }{
      classModel = classModel2.classModel;
      emit(state + 1);
      List<LessonModel> lessons = classModel2.listLesson!;

      List<LessonModel> lessonNotBTVN =
      lessons.where((element) => element.btvn == 0).toList();

      List<int> lessonNotBTVNIds = [];
      for (var i in lessonNotBTVN) {
        lessonNotBTVNIds.add(i.lessonId);
      }

      List<LessonResultModel> listLessonResult = classModel2.lessonResults!;

      List<LessonResultModel?> listLessonResultTemp = [];

      for (var i in listLessonResult) {
        listLessonResultTemp.add(i);
      }

      while (listLessonResultTemp.length < lessons.length) {
        listLessonResultTemp.add(null);
      }
      List<String> listSpNote = [];
      List<String> listTeachingDay = [];
      List<String> listTeacherNote = [];
      List<String> listStatus = [];
      List<Map<String, dynamic>> listLessonInfo = [];
      for (int i = 0; i < listLessonResultTemp.length; i++) {
        if (listLessonResultTemp[i] != null) {
          listSpNote.add(listLessonResultTemp[i]!.noteForSupport!);
          listTeacherNote.add(listLessonResultTemp[i]!.noteForTeacher!);
          listStatus.add(listLessonResultTemp[i]!.status!);
          listLessonInfo.add({
            'id': lessons
                .firstWhere((element) =>
            element.lessonId == listLessonResultTemp[i]!.lessonId)
                .lessonId,
            'title': lessons
                .firstWhere((element) =>
            element.lessonId == listLessonResultTemp[i]!.lessonId)
                .title
          });
          listTeachingDay.add(listLessonResultTemp[i]!.date!.split(" ").first);
          LessonModel temp = lessons.firstWhere(
                  (element) => element.lessonId == listLessonResultTemp[i]!.lessonId);
          lessons.remove(lessons.firstWhere((element) =>
          element.lessonId == listLessonResultTemp[i]!.lessonId));
          lessons.insert(i, temp);
        } else {
          listTeachingDay.add("");
          listSpNote.add("");
          listTeacherNote.add("");
          listStatus.add("Pending");
          listLessonInfo
              .add({'id': lessons[i].lessonId, 'title': lessons[i].title});
        }
      }
      List<int> listTeacherId = [];
      for (var i in listLessonResult) {
        if (!listTeacherId.contains(i.teacherId)) {
          listTeacherId.add(i.teacherId);
        }
      }

      List<TeacherModel> teachers =
      await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
      List<TeacherModel?> listTeacher = [];
      for (var i in listLessonResultTemp) {
        if (i != null) {
          listTeacher.add(
              teachers.firstWhere((element) => element.userId == i.teacherId));
        } else {
          listTeacher.add(null);
        }
      }

      List<StudentClassModel> listStdClass = classModel2.stdClasses!;
      List<StudentClassModel> listStdClassTemp = listStdClass
          .where((i) =>
      i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" &&
          i.classStatus == "Viewer")
          .toList();
      List<int> sdtIdsTemp = [];
      for (var i in listStdClassTemp) {
        sdtIdsTemp.add(i.userId);
      }
      List<int> studentIds = [];
      for (var i in listStdClass) {
        if (i.classStatus != "Remove" &&
            i.classStatus != "Dropped" &&
            i.classStatus != "Deposit" &&
            i.classStatus != "Retained" &&
            i.classStatus != "Moved") {
          studentIds.add(i.userId);
        }
      }

      List<StudentModel> students =
      await FireBaseProvider.instance.getAllStudentInFoInClass(studentIds);
      students.sort((a, b) => a.userId.compareTo(b.userId));
      List<String> names = [];
      for (var i in students) {
        names.add(i.name);
      }
      List<StudentLessonModel> listStdLesson = classModel2.stdLessons!;
      List<double?> listAttendance = [];
      List<double?> listHw = [];
      List<bool?> listHwStatus = [];
      List<Map<String, dynamic>?> listDetailLesson = [];
      for (var i in listLessonResultTemp) {
        if (i == null) {
          listAttendance.add(null);
          listHw.add(null);
          listHwStatus.add(null);
          listDetailLesson.add(null);
        } else {
          List<StudentLessonModel> list = listStdLesson
              .where((element) => element.lessonId == i.lessonId)
              .toList();
          List<StudentLessonModel> tempList = listStdLesson
              .where((element) =>
          element.lessonId == i.lessonId &&
              element.timekeeping != 0 &&
              !sdtIdsTemp.contains(element.studentId))
              .toList();
          double tempAttendance = 0;
          double tempHw = 0;
          bool? status;
          for (var j in tempList) {
            if (j.timekeeping < 5 && j.timekeeping > 0) {
              tempAttendance++;
            }
            if (j.hw != -2) {
              tempHw++;
            }
          }

          if (tempList.isEmpty) {
            status = null;
          } else {
            int submitCount = 0;
            int checkCount = 0;
            int notSubmitCount = 0;
            for (var k in tempList) {
              if (k.hw != -2) {
                submitCount++;
              }
              if (k.hw > -1) {
                checkCount++;
              }
              if (k.hw == -2) {
                notSubmitCount++;
              }
            }
            if (checkCount == submitCount) {
              status = true;
            } else {
              status = false;
            }
            if (notSubmitCount == tempList.length) {
              status = null;
            }
          }
          List<int?> attendanceDetail = [];
          List<int?> hwDetail = [];
          List<String> noteDetail = [];
          for (var k in students) {
            bool check = false;
            for (var j in list) {
              if (k.userId == j.studentId) {
                check = true;
              }
            }
            if (check) {
              attendanceDetail.add(list
                  .firstWhere((element) => element.studentId == k.userId)
                  .timekeeping);
              hwDetail.add(lessonNotBTVNIds.contains(i.lessonId)
                  ? null
                  : list
                  .firstWhere((element) => element.studentId == k.userId)
                  .hw);
              noteDetail.add(list
                  .firstWhere((element) => element.studentId == k.userId)
                  .teacherNote);
            } else {
              attendanceDetail.add(null);
              hwDetail.add(lessonNotBTVNIds.contains(i.lessonId) ? null : -2);
              noteDetail.add("");
            }
          }

          listAttendance
              .add(tempAttendance / (tempList.isEmpty ? 1 : tempList.length));
          if (lessonNotBTVNIds.contains(i.lessonId)) {
            listHw.add(null);
          } else {
            listHw.add(tempHw / (tempList.isEmpty ? 1 : tempList.length));
          }

          listHwStatus.add(status);
          listDetailLesson.add({
            'names': names,
            'attendance': attendanceDetail,
            'hw': hwDetail,
            'note': noteDetail
          });
        }
      }
      this.listSpNote = listSpNote;
      this.listTeacherNote = listTeacherNote;
      this.listDetailLesson = listDetailLesson;
      this.listTeacher = listTeacher;
      this.listAttendance = listAttendance;
      this.listHw = listHw;
      this.listHwStatus = listHwStatus;
      this.listStatus = listStatus;
      this.listLessonInfo = listLessonInfo;
      this.listTeachingDay = listTeachingDay;
      emit(state+1);
    }
  }
}
