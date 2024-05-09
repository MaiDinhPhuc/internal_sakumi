import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/tag_model.dart';

class TagFilterCubit extends Cubit<int> {
  TagFilterCubit() : super(0);

  List<TagModel> listFilterTags = [];


  load() {
    emit(state + 1);
  }


  changeListTag(List<TagModel> value) {
    listFilterTags = [...value];
    emit(state + 1);
  }
  addTag(TagModel value) {
    listFilterTags.add(value);
    emit(state + 1);
  }
  deleteTag(TagModel value) {
    listFilterTags.remove(value);
    emit(state + 1);
  }
}
