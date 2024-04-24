import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/group_tag_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageTagCubit extends Cubit<int> {
  ManageTagCubit() : super(0);

  int currentIndex = 0;
  List<GroupTagModel> listGroupTags = [];
  List<TagModel> listTags = [];

  List<TagModel> get listCurrentTags =>
      listTags.where((element) => element.groupId ==
          listGroupTags[currentIndex].id).toList();

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
    listTags = await FireBaseProvider.instance.getListTags();
    emitState();
  }

  bool checkCodeTagExist(String code) {
    var list = listTags.map((e) => e.code.toLowerCase());
    if (list.contains(code.toLowerCase())) return true;
    return false;
  }

  void updateTag(TagModel tagModel, bool isEdit) {
    if(isEdit) {
      final index = listTags.indexWhere((element) => element.id == tagModel.id);
      if(index != -1) {
        listTags.removeAt(index);
        listTags.insert(index, tagModel);
      }
    }
    else {
      listTags.add(tagModel);
    }
    emitState();
  }
  void deleteTag(TagModel tagModel) {
    listTags.removeWhere((element) => element.id == tagModel.id);
    emitState();
  }

  void updateGroupTag(GroupTagModel groupTagModel, bool isEdit) {
    if(isEdit) {
      final index = listGroupTags.indexWhere((element) => element.id == groupTagModel.id);
      if(index != -1) {
        listGroupTags.removeAt(index);
        listGroupTags.insert(index, groupTagModel);
      }
    }
    else {
      listGroupTags.add(groupTagModel);
      currentIndex = listGroupTags.indexOf(groupTagModel);
    }
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
    for (var item in listTags.where((element) => element.groupId ==
        listGroupTags[index].id).toList()) {
      FireBaseProvider.instance.deleteTag(item.id);

    }
    listTags.removeWhere((element) => element.groupId == listGroupTags[index].id);
    bool value =
      await FireBaseProvider.instance.deleteGroupTag(listGroupTags[index].id);

    if (value) {
      listGroupTags.removeAt(index);
      if (index == currentIndex) {
        currentIndex = 0;
      }
      if (currentIndex > index) {
        currentIndex--;
      }
      emitState();
    }

    return value;
  }
}
