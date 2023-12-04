import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:intl/intl.dart';

class FeedBackCubit extends Cubit<int> {
  FeedBackCubit() : super(0) {
    loadData();
  }

  List<StudentModel> students = [];

  List<ClassModel> classes = [];

  List<CourseModel>? courses;

  List<int> listClassId = [];

  List<int> listStdId = [];

  bool isLoading = true;

  List<FeedBackModel>? listFeedBack;
  String type = "general";

  List<String> listStatus = ["unread", "waiting", "done"];

  String statusNow = "unread";

  List<String> listStatusCheck = ["unread"];

  loadData() async {
    courses ??= await FireBaseProvider.instance.getAllCourse();
    listFeedBack ??=
        await FireBaseProvider.instance.getListFeedBack(listStatusCheck.first);
    var listStdId =
    (getFeedBack().where((e) => e.userId != -1)).map((e) => e.userId).toList();
    List<int> listClassId = [];
    for (var i in getFeedBack()) {
      if (!listClassId.contains(i.classId)) {
        listClassId.add(i.classId);
      }
    }
    List<int> listClassTemp = listClassId
        .where((element) => !this.listClassId.contains(element))
        .toList();
    List<int> listStdTemp = listStdId
        .where((element) => !this.listStdId.contains(element))
        .toList();
    this.listClassId.addAll(listClassTemp);
    this.listStdId.addAll(listStdTemp);
    getStudents(listStdTemp, listClassTemp);
    emit(state + 1);
  }

  checkData(String value) async {
    String check = "";
    switch (value) {
      case "Chưa đọc":
        check = "unread";
      case "Đang chờ được xử lí":
        check = "waiting";
      case "Đã xử lí":
        check = "done";
    }
    if (!listStatusCheck.contains(check)) {
      listStatusCheck.add(check);
      var listData = await FireBaseProvider.instance.getListFeedBack(check);
      for(int i=0; i< listData.length; i++){
        for(int j=0; j< listFeedBack!.length; j++){
          if(listData[i].date == listFeedBack![j].date && listData[i].classId == listFeedBack![j].classId){
            listFeedBack!.remove(listFeedBack![j]);
            break;
          }
        }
      }
      listFeedBack!.addAll(listData);
    }
    emit(state + 1);
  }

  List<FeedBackModel> getFeedBack() {
    List<FeedBackModel> list = listFeedBack!
        .where((e) => e.category == type && e.status == statusNow)
        .toList();
    return list;
  }

  changeStatus(FeedBackModel feedBack, String status) async {
    var index = listFeedBack!.indexOf(listFeedBack!.firstWhere(
        (e) => e.date == feedBack.date && e.classId == feedBack.classId));
    listFeedBack![index] = FeedBackModel(
        userId: feedBack.userId,
        classId: feedBack.classId,
        date: feedBack.date,
        note: feedBack.note,
        status: status,
        content: feedBack.content,
        category: feedBack.category);
    await FireStoreDb.instance
        .updateFeedBackStatus(feedBack.classId, feedBack.date, status);
    emit(state + 1);
  }

  changeNote(FeedBackModel feedBack, List<dynamic> note) async {
    var index = listFeedBack!.indexOf(listFeedBack!.firstWhere(
            (e) => e.date == feedBack.date && e.classId == feedBack.classId));
    listFeedBack![index] = FeedBackModel(
        userId: feedBack.userId,
        classId: feedBack.classId,
        date: feedBack.date,
        note: note,
        status: feedBack.status,
        content: feedBack.content,
        category: feedBack.category);
  }

  String getCourse(int classId) {
    if (courses == null || classes.isEmpty) {
      return "";
    }

    for(var i in classes){

    }

    var courseId = classes.firstWhere((e) => e.classId == classId).courseId;
    String name = courses!.where((e) => e.courseId == courseId).isEmpty
        ? ""
        : "${courses!.where((e) => e.courseId == courseId).first.title} - ${courses!.where((e) => e.courseId == courseId).first.level}";

    return name;
  }

  String getDate(int value) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    String formattedDateTime =
        DateFormat('HH:mm:ss - dd/MM/yyyy').format(dateTime);
    return formattedDateTime;
  }

  String getClassCode(int classId) {
    if (classes.isEmpty) {
      return "";
    }
    return classes.where((e) => e.classId == classId).isEmpty
        ? ""
        : classes.where((e) => e.classId == classId).first.classCode;
  }

  String getAvt(int stdId) {
    if (students.isEmpty) {
      return "";
    }
    if (stdId == -1) {
      return "";
    }
    return students.where((e) => e.userId == stdId).isEmpty
        ? ""
        : students.where((e) => e.userId == stdId).first.url;
  }

  String getName(int stdId) {
    if (students.isEmpty) {
      return "Ẩn danh";
    }
    if (stdId == -1) {
      return "Ẩn danh";
    }
    return students.where((e) => e.userId == stdId).isEmpty
        ? ""
        : students.where((e) => e.userId == stdId).first.name;
  }


  getStudents(List<int> listStdId, List<int> listClassId) async {
    isLoading = true;
    emit(state+1);
    var stdTemp =
        await FireBaseProvider.instance.getAllStudentInFoInClass(listStdId);
    students.addAll(stdTemp);
    var classTemp =
        await FireBaseProvider.instance.getListClassForTeacher(listClassId);
    classes.addAll(classTemp);
    isLoading = false;
    emit(state+1);
  }

  filter(String value) {
    switch (value) {
      case "Chưa đọc":
        statusNow = "unread";
      case "Đang chờ được xử lí":
        statusNow = "waiting";
      case "Đã xử lí":
        statusNow = "done";
    }
    loadData();
    emit(state + 1);
  }

  changeType(String newType)async {
    type = newType;
    await loadData();
    statusNow = "unread";
    emit(state + 1);
  }

  int getCountUnRead(String type) {
    var list = listFeedBack!
        .where((e) => e.category == type && e.status == "unread")
        .toList();
    return list.length;
  }
}
