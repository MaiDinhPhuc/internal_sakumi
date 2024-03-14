import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class AddNewReportCubit extends Cubit<int> {
  AddNewReportCubit(this.reportModel, this.userId) : super(0) {
    load();
  }

  final ReportModel? reportModel;
  final int userId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleCon = TextEditingController();
  TextEditingController contentCon = TextEditingController();
  TextEditingController creatorCon = TextEditingController();
  String status = 'Tốt';
  List<dynamic> listPickerImage = [];
  List<dynamic> listUrl = [];

  List<String> listStatus = ['Tốt', 'Bình thường', 'Chưa tốt', 'Tệ'];

  String findReportStatus() {
    if (reportModel != null) return reportModel!.status;
    return 'Chọn trạng thái buổi họp';
  }

  chooseStatus(String value) {
    status = value;
    emit(state + 1);
  }

  pickImage() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      listPickerImage.add(f);
      emit(state + 1);
    }
  }

  removeImage(value) async {
    listPickerImage.remove(value);
    emit(state + 1);
  }

  bool checkIsUrl(value) {
    if (value is String) {
      return true;
    } else if (value is Uint8List) {
      return false;
    }
    return true;
  }

  load() {
    if (reportModel != null) {
      titleCon.text = reportModel!.title;
      contentCon.text = reportModel!.content;
      creatorCon.text = reportModel!.createName;
      status = reportModel!.status;
      listPickerImage = reportModel!.images;
      emit(state+1);
    }
  }

  addNewReport(TeacherReportCubit reportCubit) async {
    if (listPickerImage.isNotEmpty) {
      List<String> list = [];
      for (var j in listPickerImage) {
        if (checkIsUrl(j)) {
          list.add(j);
        } else {
          final url = await FireBaseProvider.instance
              .uploadImageAndGetUrl(j, 'report_image');
          list.add(url);
        }
      }
      listUrl = list;
    }
    int id = DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore.instance.collection('reports').doc('report_$id').set({
      'id': id,
      'teacher_id': userId,
      'status': status,
      'title': titleCon.text,
      'content': contentCon.text,
      'delete': false,
      'create_name': creatorCon.text,
      'images': listUrl
    });
    reportCubit.addNewReport(ReportModel(
        id: id,
        teacherId: userId,
        status: status,
        createName: creatorCon.text,
        title: titleCon.text,
        content: contentCon.text,
        delete: false,
        images: listUrl));
  }

  updateReport(TeacherReportCubit reportCubit)async{
    if (listPickerImage.isNotEmpty) {
      List<String> list = [];
      for (var j in listPickerImage) {
        if (checkIsUrl(j)) {
          list.add(j);
        } else {
          final url = await FireBaseProvider.instance
              .uploadImageAndGetUrl(j, 'report_image');
          list.add(url);
        }
      }
      listUrl = list;
    }
    int id = DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore.instance.collection('reports').doc('report_$id').update({
      'id': reportModel!.id,
      'teacher_id': userId,
      'status': status,
      'title': titleCon.text,
      'content': contentCon.text,
      'delete': reportModel!.delete,
      'create_name': creatorCon.text,
      'images': listUrl
    });
    reportCubit.updateReport(ReportModel(
        id: reportModel!.id,
        teacherId: userId,
        status: status,
        createName: creatorCon.text,
        title: titleCon.text,
        content: contentCon.text,
        delete: reportModel!.delete,
        images: listUrl));
  }
}
