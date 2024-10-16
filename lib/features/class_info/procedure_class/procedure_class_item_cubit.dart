import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ProcedureClassItemCubit extends Cubit<int>{
  ProcedureClassItemCubit(this.procedureClass): super(0){
    updateValue = procedureClass;
  }

  final ProcedureClassModel procedureClass;

  ProcedureClassModel? updateValue;
  ProcedureModel? procedure;
  List<ProcedureItemModel>? listItem;

  bool isConfirm = false;

  updateListItem(List<ProcedureItemModel> list){
    listItem = list;
    emit(state+1);
  }

  init()async{
    procedure = await FireBaseProvider.instance.getProcedure(procedureClass.procedureId);
    emit(state+1);
    var listItemId = procedureClass.info.map((e)=>e['item_id']).toList();
    listItem = await FireBaseProvider.instance.getProcedureItemByIDs(listItemId);
    emit(state+1);
  }

  double checkPercent(ProcedureItemModel item){
    if(updateValue == null) return 0;
    for(var i in updateValue!.info){
      if(i['item_id'] == item.id){
        return i['progress'];
      }
    }
    return 0;
  }

  bool checkBool(ProcedureItemModel item){
    if(updateValue == null) return false;
    for(var i in updateValue!.info){
      if(i['item_id'] == item.id){
        return i['check'];
      }
    }
    return false;
  }

  setValueProgress(ProcedureItemModel item, double newValue){

    var newInfo = [];

    for(var i in updateValue!.info){
      if(i['item_id'] == item.id){
        newInfo.add({
          'item_id' : i['item_id'],
          'progress' : newValue,
          'check': newValue == 100 ? true : false
        });
      }else{
        newInfo.add(i);
      }
    }

    updateValue = updateValue!.copyWith(info: newInfo);
    isConfirm = true;
    emit(state+1);
  }

  double getPercentTotal(){
    if(updateValue == null || updateValue!.info.isEmpty) return 0;
    int total = 0;
    for(var i in updateValue!.info){
      if(i['check'] == true){
        total = total + 1;
      }
    }

    return total/updateValue!.info.length;
  }

  updateProcedureClass()async{
    await FireBaseProvider.instance.addNewProcedureClass(updateValue!);
    isConfirm = false;
    emit(state+1);
  }

  update(int index, Map newValue){
    updateValue!.info[index] = newValue;
    emit(state+1);
  }
}