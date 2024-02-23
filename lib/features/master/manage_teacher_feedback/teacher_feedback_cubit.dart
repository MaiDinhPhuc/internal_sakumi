import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:intl/intl.dart';

class TeacherFeedBackCubit extends Cubit<int> {
  TeacherFeedBackCubit() : super(0) {
    loadData();
  }

  List<TeacherModel> teachers = [];

  bool isLoading = true;

  List<FeedBackModel>? listFeedBack;

  String type = "general";

  List<String> listStatus = ["unread", "waiting", "done"];

  String statusNow = "unread";

  List<String> listStatusCheck = ["unread"];

  String filterState = AppText.txtUnread.text;

  loadData() async {
    listFeedBack ??=
        await FireBaseProvider.instance.getListFeedBack(statusNow, 'teacher');
    List<int> listTeacherId = (listFeedBack!.where((e) => e.userId != -1))
        .map((e) => e.userId)
        .toList();

    await getTeachers(listTeacherId);
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
      var listData = await FireBaseProvider.instance.getListFeedBack(check,'teacher');
      listFeedBack!.addAll(listData);
      List<int> listTeacherId =
          (listData.where((e) => e.userId != -1)).map((e) => e.userId).toList();
      await getTeachers(listTeacherId);
    }
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
        category: feedBack.category,
        role: feedBack.role);
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
        category: feedBack.category,
        role: feedBack.role);
  }

  String getDate(int value) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    String formattedDateTime =
        DateFormat('HH:mm:ss - dd/MM/yyyy').format(dateTime);
    return formattedDateTime;
  }

  String getAvt(int stdId) {
    if (teachers.isEmpty) {
      return "";
    }
    if (stdId == -1) {
      return "";
    }
    return teachers.where((e) => e.userId == stdId).isEmpty
        ? ""
        : teachers.where((e) => e.userId == stdId).first.url;
  }

  String getName(int stdId) {
    if (teachers.isEmpty) {
      return "Ẩn danh";
    }
    if (stdId == -1) {
      return "Ẩn danh";
    }
    return teachers.where((e) => e.userId == stdId).isEmpty
        ? ""
        : teachers.where((e) => e.userId == stdId).first.name;
  }

  getTeachers(List<int> listTeacherId) async {
    isLoading = true;
    emit(state + 1);
    var teacherTemp =
        await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
    for (var i in teacherTemp) {
      if (!teachers.contains(i)) {
        teachers.add(i);
      }
    }
    isLoading = false;
    emit(state + 1);
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
    filterState = value;
    emit(state + 1);
  }

  changeType(String newType) async {
    type = newType;
    emit(state + 1);
  }

  int getCount(String type) {
    var list = listFeedBack!
        .where((e) => e.category == type && e.status == statusNow)
        .toList();
    return list.length;
  }
}
