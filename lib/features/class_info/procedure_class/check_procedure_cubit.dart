import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CheckProcedureCubit extends Cubit<int>{
  CheckProcedureCubit():super(0);

  List<ProcedureModel>? listProcedure;

  List<int> listId = [];

  List<ProcedureModel> listChoose = [];

  init(List<ProcedureClassModel> procedureClasses, String type)async{

    listId = procedureClasses.map((e)=>e.procedureId).toList();

    listProcedure = (await FireBaseProvider.instance.getAllProcedure()).where((e)=> listId.contains(e.id) == false && type == e.type).toList();

    emit(state+1);
  }

  choose(ProcedureModel value){
    listChoose.add(value);
    emit(state+1);
  }

  remove(ProcedureModel value){
    listChoose.remove(value);
    emit(state+1);
  }

}