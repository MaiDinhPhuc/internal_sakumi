import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CheckListItemsCubit extends Cubit<int>{
  CheckListItemsCubit():super(0);

  List<ProcedureItemModel>? checkListItems;
  List<ProcedureGroupModel>? listProcedureGroup;

  ProcedureItemModel? procedureNow;
  
  bool isEdit = false;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];
  List<bool> checkList = [];
  List<String> listGroupTitle = [];
  List<int> listGroupId = [];
  int index = 0;
  List<String> listTitleChoose = ["KHÔNG CÓ GROUP"];
  List<int> listIdChoose = [0];
  
  init()async{
    
    checkListItems = await FireBaseProvider.instance.getAllProcedureItem('checklist');

    listProcedureGroup = (await FireBaseProvider.instance.getAllProcedureGroup()).where((e)=>e.type == "checklist").toList();

    for(var i in listProcedureGroup!){
      listTitleChoose.add(i.title);
      listIdChoose.add(i.id);
    }

    for(var i in checkListItems!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
      checkList.add(i.isProgress);
      listGroupId.add(i.group);
      String title = "KHÔNG CÓ GROUP";
      if(i.group != 0){
        var group = listProcedureGroup!.where((e)=>e.id == i.group).firstOrNull;
        if(group != null){
          title = group.title;
        }
      }
      listGroupTitle.add(title);
    }
    
    emit(state+1);
  }

  chooseItem(ProcedureItemModel data){
    procedureNow = data;

    index = checkListItems!.indexOf(data);

    isEdit = false;
    emit(state+1);
  }

  updateGroup(String value){
    var temp = listTitleChoose.indexOf(value);
    listGroupTitle[index] = value;
    listGroupId[index] = listIdChoose[temp];
    emit(state+1);
  }

  openEdit(){
    isEdit = !isEdit;
    emit(state+1);
  }
  
  addItem(ProcedureItemModel newItem)async{
    checkListItems!.add(newItem);
    procedureNow = newItem;
    titleConList.add(TextEditingController(text: newItem.title));
    desConList.add(TextEditingController(text: newItem.des));
    checkList.add(newItem.isProgress);
    listGroupId.add(0);
    listGroupTitle.add('KHÔNG CÓ GROUP');
    isEdit = true;
    index = checkListItems!.indexOf(newItem);
    emit(state+1);
  }
  
  updateDataToFb(ProcedureItemModel data)async{
    await FireBaseProvider.instance.addNewProcedureItem(data);
    isEdit = false;
    updateItem(data);
  }

  checkInProgress(bool newValue){
    checkList[index] = newValue;
    emit(state+1);
  }

  removeItem(ProcedureItemModel data)async{
    var index = checkListItems!.indexWhere((e)=>e.id == data.id);
    titleConList.removeAt(index);
    desConList.removeAt(index);
    checkList.removeAt(index);
    checkListItems!.removeAt(index);
    listGroupId.removeAt(index);
    listGroupTitle.removeAt(index);
    await FireBaseProvider.instance.addNewProcedureItem(data);
    isEdit = false;
    procedureNow = null;
    emit(state+1);
  }

  updateItem(ProcedureItemModel data)async{
    var index = checkListItems!.indexWhere((e)=>e.id == data.id);
    checkListItems![index] = data;
    procedureNow = data;
    emit(state+1);
  }
}