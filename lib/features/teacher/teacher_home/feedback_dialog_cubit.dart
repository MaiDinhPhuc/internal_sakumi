import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackDialogCubit extends Cubit<int> {
  FeedBackDialogCubit() : super(0);

  String category = "curriculum_teacher";

  String content = "";

  bool isAnonymous = false;

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
        role: 'teacher'));
  }

  List<String> listType = [
    AppText.titleCurriculumFeedBack.text,
    AppText.txtCentreFeedBack.text,
    AppText.txtTeachingFeedBack.text,
    AppText.txtSupportFeedBack.text
  ];
}
