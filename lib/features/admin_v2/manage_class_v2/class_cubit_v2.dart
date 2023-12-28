import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';

class ClassCubit extends Cubit<List<ClassModel>?>{
  ClassCubit():super(null);

  bool isLastPage = false;

  reload(Map<AdminFilter, List> filter)async{
    if(filter.keys.isNotEmpty){
      emit(await DataProvider.clasList(filter, 1));
    }
  }

  loadMore(){

  }
}