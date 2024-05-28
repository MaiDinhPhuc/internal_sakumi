import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/manage_tag_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ListManageTagsCubit extends Cubit<int> {
  ListManageTagsCubit() : super(0);


  List<ManageTagModel> listManageTags = [];
  List<TagModel> listTags = [];

  List<TagModel> listFilterTags = [];

  load(List<TagModel> list)  async {
    print('lllll');
    listFilterTags = List.from(list);
    if(listFilterTags.isNotEmpty) {
      listManageTags= await FireBaseProvider.instance.getManageTagsWithSpecificTags(listFilterTags.map((e) => e.id).toList());
    }
    listTags= await FireBaseProvider.instance.getListTags();
    emit(state+1);
  }

  update() async {
    if(listFilterTags.isNotEmpty) {
      listManageTags= await FireBaseProvider.instance.getManageTagsWithSpecificTags(listFilterTags.map((e) => e.id).toList());
      print('listManageTags load');
    }
    emit(state+1);
  }

  setListFilter(List<TagModel> list) {
    listFilterTags = List.from(list);
  }
}
