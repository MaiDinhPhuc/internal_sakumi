import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageProcedureCubit extends Cubit<int>{
  ManageProcedureCubit():super(0){
    loadData();
  }

  List<ProcedureModel>? listProcedure;
  String filterState = "Checklist";
  String statusNow = 'checklist';

  loadData()async{
    listProcedure = await FireBaseProvider.instance.getAllProcedure();
    emit(state+1);
  }

  List<ProcedureModel> getProcedure() {

    if(listProcedure == null) return [];

    return listProcedure!.where((e)=> e.type == statusNow).toList();
  }

  addProcedure(ProcedureModel newProcedure)async{
    listProcedure!.add(newProcedure);
    await FireBaseProvider.instance.addNewProcedure(newProcedure);
    emit(state+1);
  }

  updateProcedure(ProcedureModel newProcedure)async{
    var index = listProcedure!.indexWhere((e)=>e.id == newProcedure.id);
    listProcedure![index] = newProcedure;
    await FireBaseProvider.instance.addNewProcedure(newProcedure);
    emit(state+1);
  }

  removeProcedure(ProcedureModel removeProcedure)async{
    listProcedure!.removeWhere((e)=>e.id == removeProcedure.id);
    await FireBaseProvider.instance.addNewProcedure(removeProcedure);
    emit(state+1);
  }

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

}