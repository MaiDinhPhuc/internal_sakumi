import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class FeedBackDialogCubit extends Cubit<int> {
  FeedBackDialogCubit() : super(0);

  String category = "curriculum_teacher";

  String content = "";

  bool isAnonymous = false;

  List<dynamic> listPickerFiles = [];

  List<String> listCurriculum = [
    'curriculum_teacher',
    'centre_teacher',
    'teaching_teacher',
    'support_teacher'
  ];

  checkAnonymous() {
    isAnonymous = !isAnonymous;
    emit(state + 1);
  }

  chooseCategory(String value) {
    var index = listType.indexOf(value);
    category = listCurriculum[index];
    emit(state + 1);
  }

  inputContent(String value) {
    content = value;
    emit(state + 1);
  }

  clearContent(){
    content = "";
    emit(state+1);
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

  sendFeedBack() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);
    int date = DateTime.now().millisecondsSinceEpoch;
    await FireBaseProvider.instance.addNewFeedBack(FeedBackModel(
        userId: isAnonymous ? -1 : userId!,
        classId: 999999999,
        date: date,
        note: [],
        status: 'unread',
        content: content,
        category: category,
        role: 'teacher',
        files: listPickerFiles
    ));
  }

  List<String> listType = [
    AppText.titleCurriculumFeedBack.text,
    AppText.txtCentreFeedBack.text,
    AppText.txtTeachingFeedBack.text,
    AppText.txtSupportFeedBack.text
  ];
}
