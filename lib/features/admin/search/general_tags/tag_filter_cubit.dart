import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_history_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/tag_model.dart';

class TagFilterCubit extends Cubit<int> {
  TagFilterCubit() : super(0);

  List<TagModel> listFilterTags = [];


  load() async {
    listFilterTags = await TagHistoryProvider.loadList();
    emit(state + 1);
  }


  changeListTag(List<TagModel> value) async{
    listFilterTags = [...value];
    await TagHistoryProvider.saveToPref(listFilterTags);
    emit(state + 1);
  }
  addTag(TagModel value)async {
    listFilterTags.add(value);
    await TagHistoryProvider.saveToPref(listFilterTags);
    emit(state + 1);
  }
  deleteTag(TagModel value) async {
    listFilterTags.remove(value);
    await TagHistoryProvider.saveToPref(listFilterTags);
    emit(state + 1);
  }


}
