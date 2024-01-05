import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';

class ClassCubit extends Cubit<int>{
  ClassCubit():super(0);

  bool isLastPage = false;

  List<ClassModel>? listClass;

  List<String> listClassStatusMenuAdmin2 = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel"
  ];

  reload(Map<AdminFilter, List> filter)async{
    if(filter.keys.isNotEmpty){
      listClass = await DataProvider.classList(filter, 1);
      if(listClass!.length < 10){
        isLastPage = true;
      }else{
        isLastPage = false;
      }
    }
    emit(state+1);
  }

  loadMore(Map<AdminFilter, List> filter)async{
    var list = await DataProvider.classList(filter, 1,lastItem: listClass!.last);
    if(list.length < 10){
      isLastPage = true;
    }
    listClass!.addAll(list);
    emit(state+1);
  }

  updateClass(ClassModel classModel){
    var index = listClass!.indexOf(listClass!.firstWhere((e) => e.classId == classModel.classId));

    listClass![index] = classModel;
    emit(state+1);
  }
}