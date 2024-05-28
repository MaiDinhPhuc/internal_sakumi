import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/tag_model.dart';

class TagHistoryProvider {


  static Future<void> saveToPref(List<TagModel> listFilterTags) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(listFilterTags.map((tag) => tag.toJson()).toList());
    prefs.setString('filterTagHistory', jsonString);
  }

  static Future<List<TagModel>> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterTagHistory');
    if(jsonString != null) {
      var data = json.decode(jsonString);
      return (data as List).map((tagMap) => TagModel.fromMap(tagMap)).toList();
    }
    return [];
  }

  static Future<void> deleteTag(int tagId) async {
    List<TagModel> listFilterTags = await loadList();
    listFilterTags.removeWhere((tag) => tag.id == tagId);
    await saveToPref(listFilterTags);
  }

  static Future<void> updateTag(TagModel updatedTag) async {
    List<TagModel> listFilterTags = await loadList();
    for (int i = 0; i < listFilterTags.length; i++) {
      if (listFilterTags[i].id == updatedTag.id) {
        listFilterTags[i] = updatedTag;
        break;
      }
    }
    await saveToPref(listFilterTags);
  }

  static Future<void> deleteTags(List<int> tagIds) async {
    List<TagModel> listFilterTags = await loadList();
    listFilterTags.removeWhere((tag) => tagIds.contains(tag.id));
    await saveToPref(listFilterTags);
  }
}