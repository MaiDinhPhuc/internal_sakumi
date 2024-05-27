import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/tag_model.dart';

class TagFilterCubit extends Cubit<int> {
  TagFilterCubit() : super(0);

  List<TagModel> listFilterTags = [];


  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterTagHistory');
    if(jsonString != null) {
      var data = json.decode(jsonString);
      listFilterTags = (data as List).map((tagMap) => TagModel.fromMap(tagMap)).toList();
    }
    emit(state + 1);
  }


  changeListTag(List<TagModel> value) async{
    listFilterTags = [...value];
    await _saveToPref();
    emit(state + 1);
  }
  addTag(TagModel value)async {
    listFilterTags.add(value);
   await  _saveToPref();
    emit(state + 1);
  }
  deleteTag(TagModel value) async {
    listFilterTags.remove(value);
    await _saveToPref();
    emit(state + 1);
  }

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(listFilterTags.map((tag) => tag.toJson()).toList());
    prefs.setString('filterTagHistory', jsonString);
  }

}
