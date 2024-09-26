import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/advise_model.dart';
import 'package:internal_sakumi/model/banner_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:intl/intl.dart';

class ManageAdviseCubit extends Cubit<int>{
  ManageAdviseCubit():super(0){
    loadData();
  }

  List<AdviseModel>? listAdvise;
  List<StudentModel> students = [];
  List<CourseModel>? courses;
  List<BannerModel>? banners;
  String type = "course";

  bool isLoading = true;

  List<String> listStatus = ["unread", "done"];

  String statusNow = "unread";

  List<String> listStatusCheck = ["unread"];

  String filterState = AppText.txtUnread.text;

  loadData() async {
    courses ??= await FireBaseProvider.instance.getAllCourse();
    banners ??= await FireBaseProvider.instance.getBanners();
    listAdvise ??=
    await FireBaseProvider.instance.getListAdvise(statusNow, ['course', 'banner']);
    List<int> listStdId = (listAdvise!.where((e) => e.userId != -1)).map((e) => e.userId).toList();
    await getStudents(listStdId);
  }

  changeStatus(AdviseModel advise, String status) async {
    var index = listAdvise!.indexOf(listAdvise!.firstWhere(
            (e) => e.date == advise.date));
    listAdvise![index] = AdviseModel(
        userId: advise.userId,
        date: advise.date,
        status: status,
        phone: advise.phone, typeId: advise.typeId, email: advise.email, type: advise.type);
    await FireStoreDb.instance
        .updateAdviseStatus( advise.date, status);
    emit(state + 1);
  }

  checkData(String value) async {
    String check = "";
    switch (value) {
      case "Chưa đọc":
        check = "unread";
      case "Đã xử lí":
        check = "done";
    }
    if (!listStatusCheck.contains(check)) {
      listStatusCheck.add(check);
      var listData = await FireBaseProvider.instance.getListAdvise(statusNow, ['course', 'banner']);
      listAdvise!.addAll(listData);
      List<int> listStdId = (listData.where((e) => e.userId != -1)).map((e) => e.userId).toList();

      await getStudents(listStdId);
    }
  }

  List<AdviseModel> getAdvise() {
    List<AdviseModel> list = listAdvise!
        .where((e) => e.type == type && e.status == statusNow)
        .toList();
    return list;
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

  String getCourse(int id) {

    print(id);

    var ids = courses!.map((e)=>e.courseId).toList();
    print(ids);

    if (courses == null) {
      return "";
    }
    var course = courses!.where((e) => e.courseId == id).toList();

    if(course.isEmpty){
      return "";
    }

    var courseId = course.first.courseId;

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

  BannerModel? getBanner(int id){
    if(banners == null) return null;
    var banner = banners!.where((e)=>e.id == id).toList();
    if(banner.isEmpty) return null;
    return banner.first;
  }

  getStudents(List<int> listStdId) async {
    isLoading = true;
    emit(state+1);
    var stdTemp =
    await FireBaseProvider.instance.getAllStudentInFoInClass(listStdId);
    for(var i in stdTemp){
      if(!students.contains(i)){
        students.add(i);
      }
    }
    isLoading = false;
    emit(state+1);
  }

  filter(String value) {
    switch (value) {
      case "Chưa đọc":
        statusNow = "unread";
      case "Đã xử lí":
        statusNow = "done";
    }
    filterState = value;
    emit(state + 1);
  }

  changeType(String newType)async {
    type = newType;
    emit(state + 1);
  }

  int getCount(String type) {
    var list = listAdvise!
        .where((e) => e.type == type && e.status == statusNow)
        .toList();
    return list.length;
  }

}