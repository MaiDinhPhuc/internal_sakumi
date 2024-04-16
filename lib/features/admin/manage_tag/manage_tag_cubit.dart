import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/group_tag_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageTagCubit extends Cubit<int> {
  ManageTagCubit() : super(0);

  int currentIndex = 0;
  List<GroupTagModel> listGroupTags = [];

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  setCurrentIndex(int value) {
    currentIndex = value;
    emitState();
  }

  load() async {
    listGroupTags = await FireBaseProvider.instance.getListGroupTags();
    currentIndex = 0;
    emitState();
  }

  bool checkCodeTagExist(String code) {
    var list = <String>[];
    for (var item in listGroupTags) {
      list.addAll(item.tags
          .map((e) => TagModel.fromMap(e))
          .map((e) => e.code.toLowerCase()));
    }
    if (list.contains(code.toLowerCase())) return true;
    return false;
  }

  void updateTag(TagModel tagModel) {
    listGroupTags[currentIndex].tags.add(tagModel.toJson());
    emitState();
  }

  void updateGroupTag(GroupTagModel groupTagModel) {
    listGroupTags.add(groupTagModel);
    currentIndex = listGroupTags.indexOf(groupTagModel);
    emitState();
  }

  bool checkCodeGroupTagExist(String value) {
    var list = <String>[];
    for (var item in listGroupTags) {
      list.add(item.code.toLowerCase());
    }
    if (list.contains(value.toLowerCase())) return true;
    return false;
  }

  Future<bool> deleteGroupTag(int index) async {
    bool value =
        await FireBaseProvider.instance.deleteGroupTag(listGroupTags[index].id);

    if (value) {
      listGroupTags.removeAt(index);
      if (index == currentIndex) {
        currentIndex = 0;
      }
      if(currentIndex > index) {
        currentIndex--;
      }
      emitState();
    }

    return value;
  }
}
