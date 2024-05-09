import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/manage_tag_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ListManageTagsCubit extends Cubit<int> {
  ListManageTagsCubit() : super(0);


  List<ManageTagModel> listManageTags = [];
  List<TagModel> listTags = [];
  load()  async {
    listManageTags= await FireBaseProvider.instance.getManageTags();
    listTags= await FireBaseProvider.instance.getListTags();
    emit(state+1);
  }
}
