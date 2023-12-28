import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';

class ClassDetailCubit extends Cubit<int>{
  ClassDetailCubit(this.classModel):super(0){
    loadTitle();
  }
  final ClassModel classModel;
  String? title;

  loadTitle()async{
    title = (await DataProvider.courseById(classModel.courseId)).title;
    emit(state+1);
  }
}