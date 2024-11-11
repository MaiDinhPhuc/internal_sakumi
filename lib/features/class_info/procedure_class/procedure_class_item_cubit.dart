import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
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

  List<ProcedureGroupModel>? listGroup;

  List<int> listGroupId = [];

  bool isConfirm = false;

  bool isSendReport = false;

  TextEditingController textEditingController = TextEditingController();

  updateListItem(List<ProcedureItemModel> list){
    listItem = list;
    emit(state+1);
  }

  init()async{
    listGroup = (await FireBaseProvider.instance.getAllProcedureGroup()).where((e)=>e.type == procedureClass.type).toList();
    procedure = await FireBaseProvider.instance.getProcedure(procedureClass.procedureId);
    textEditingController = TextEditingController(text: procedureClass.report);
    emit(state+1);
    var listItemId = procedureClass.info.map((e)=>e['item_id']).toList();
    listItem = await FireBaseProvider.instance.getProcedureItemByIDs(listItemId);
    for(var i in listItem!){
      if(listGroupId.contains(i.group) == false){
        listGroupId.add(i.group);
      }
    }
    emit(state+1);
  }

  getItemForGroup(int groupId){

    if(listItem == null) return [];

    return listItem!.where((e)=>e.group == groupId).toList();
  }

  String getTitle(int id){
    if(id == 0 || listGroup == null) return "KHÔNG CÓ GROUP";

    var temp = listGroup!.where((e)=>e.id == id).firstOrNull;

    if(temp == null) return "KHÔNG CÓ GROUP";

    return temp.title;
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

  changeIsRp(bool value){
    isSendReport = value;
    emit(state+1);
  }

  setReport(String value){
    updateValue = updateValue!.copyWith(report: value);
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
    if(updateValue == null || updateValue!.info.isEmpty || listItem == null) return 0;

    var listId = listItem!.map((e)=>e.id).toList();

    if(listId.isEmpty) return 0;

    int total = 0;
    for(var i in updateValue!.info){
      if(i['check'] == true && listId.contains(i['item_id'])){
        total = total + 1;
      }
    }

    return total/listId.length;
  }

  updateProcedureClass()async{
    await FireBaseProvider.instance.addNewProcedureClass(updateValue!);
    isConfirm = false;
    isSendReport = false;
    emit(state+1);
  }

  update(int index, Map newValue){
    updateValue!.info[index] = newValue;
    emit(state+1);
  }
}