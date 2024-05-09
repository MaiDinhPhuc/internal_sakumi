import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/group_tag_model.dart';
import '../../../../model/tag_model.dart';
import '../../../../providers/firebase/firebase_provider.dart';

class AddTagFilterCubit extends Cubit<int> {
  AddTagFilterCubit(this.listOldTags) : super(0);

  int currentIndex = 0;
  List<GroupTagModel> listGroupTags = [];
  final List<TagModel> listOldTags;
  List<TagModel> listTags = [];
  List<TagModel> listChooseTags = [];

  List<TagModel> get listCurrentTags =>
      listTags.where((element) => element.groupId ==
          listGroupTags[currentIndex].id).toList();

  addTag(TagModel value) {
    listChooseTags.add(value);
    emit(state + 1);
  }
  deleteTag(TagModel value) {
    listChooseTags.remove(value);
    emit(state + 1);
  }
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
    listChooseTags = [...listOldTags];
    emitState();
  }
}
