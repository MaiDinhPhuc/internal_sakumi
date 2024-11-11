import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class ProcedureClassCubit extends Cubit<int>{
  ProcedureClassCubit(this.classId):super(0);

  List<ProcedureClassModel>? listProcedureClass;

  String filterState = "Checklist";
  String statusNow = 'checklist';

  final int classId;

  filter(String value) {
    switch (value) {
      case "Checklist":
        statusNow = "checklist";
      case "Meeting":
        statusNow = "meeting";
    }
    filterState = value;
    emit(state + 1);
  }

  List<ProcedureClassModel> getProcedureClass() {

    if(listProcedureClass == null) return [];

    var list = listProcedureClass!.where((e)=> e.type == statusNow).toList();

    return list;
  }

  init()async{
    listProcedureClass = await FireBaseProvider.instance.getAllProcedureClass(classId);
    emit(state+1);
  }

  addNewProcedureClass(ProcedureClassModel newItem)async{
    listProcedureClass!.add(newItem);
    await FireBaseProvider.instance.addNewProcedureClass(newItem);
  }

 updateProcedure(ProcedureClassModel newItem){
    var index = listProcedureClass!.indexWhere((e)=>e.id == newItem.id);
    listProcedureClass![index] = newItem;

    emit(state+1);
 }

  emitState(){
    emit(state+1);
  }

  removeProcedureClass(ProcedureClassModel removeItem)async{
    listProcedureClass!.removeWhere((e)=>e.id == removeItem.id);
    await FireStoreDb.instance.deleteProcedureClass(removeItem);
    emit(state+1);
  }

}