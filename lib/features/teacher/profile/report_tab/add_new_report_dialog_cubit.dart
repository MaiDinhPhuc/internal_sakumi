import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_cubit.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../../services/custom_firebase_firestore.dart';

class AddNewReportCubit extends Cubit<int> {
  AddNewReportCubit(this.reportModel, this.userId,this.classId) : super(0) {
    load();
  }

  final ReportModel? reportModel;
  final int userId;
  final int classId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleCon = TextEditingController();
  TextEditingController contentCon = TextEditingController();
  TextEditingController creatorCon = TextEditingController();
  String status = 'Tốt';
  String range = 'Quan trọng';
  List<dynamic> listPickerFiles = [];

  List<String> listStatus = ['Tốt', 'Bình thường', 'Chưa tốt', 'Tệ'];
  List<String> listRange = ['Quan trọng','Bình thường','Gợi ý'];


  String findReportRange() {
    if (reportModel != null) return reportModel!.range;
    return 'Chọn mức độ biên bản';
  }
  String findReportStatus() {
    if (reportModel != null) return reportModel!.status;
    return 'Chọn trạng thái buổi họp';
  }
  chooseRange(String value) {
    range = value;
    emit(state + 1);
  }

  chooseStatus(String value) {
    status = value;
    emit(state + 1);
  }

  pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      final url = await FireBaseProvider.instance
          .uploadImageAndGetUrl(fileBytes!, 'files', fileName);
      listPickerFiles.add({
        'file_name': fileName,
        'db': url
      });
      emit(state + 1);
    }
  }

  removeFile(value) async {
    listPickerFiles.remove(value);
    emit(state + 1);
  }

  load() {
    if (reportModel != null) {
      titleCon.text = reportModel!.title;
      contentCon.text = reportModel!.content;
      creatorCon.text = reportModel!.createName;
      status = reportModel!.status;
      listPickerFiles = reportModel!.files;
      emit(state+1);
    }
  }

  addNewReport(ReportCubit reportCubit) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    CustomFirebaseFireStore.database.collection('reports').doc('report_$id').set({
      'id': id,
      'teacher_id': userId,
      'status': status,
      'range': range,
      'title': titleCon.text,
      'content': contentCon.text,
      'delete': false,
      'create_name': creatorCon.text,
      'files': listPickerFiles,
      'type': reportCubit.type,
      'class_id': classId
    });
    reportCubit.addNewReport(ReportModel(
        id: id,
        teacherId: userId,
        status: status,
        range: range,
        createName: creatorCon.text,
        title: titleCon.text,
        content: contentCon.text,
        delete: false,
        files: listPickerFiles,type:  reportCubit.type,classId: classId));
  }

  updateReport(ReportCubit reportCubit)async{

    CustomFirebaseFireStore.database.collection('reports').doc('report_${reportModel!.id}').update({
      'id': reportModel!.id,
      'teacher_id': userId,
      'status': status,
      'range': range,
      'title': titleCon.text,
      'content': contentCon.text,
      'delete': reportModel!.delete,
      'create_name': creatorCon.text,
      'files': listPickerFiles,
      'type': reportCubit.type,
      'class_id':classId
    });
    reportCubit.updateReport(ReportModel(
        id: reportModel!.id,
        teacherId: userId,
        status: status,
        range:range,
        createName: creatorCon.text,
        title: titleCon.text,
        content: contentCon.text,
        delete: reportModel!.delete,
        files: listPickerFiles,type:  reportCubit.type, classId: classId));
  }
}
