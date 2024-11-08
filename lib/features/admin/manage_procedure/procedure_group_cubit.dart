import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class GroupProcedureCubit extends Cubit<int>{
  GroupProcedureCubit():super(0);

  List<ProcedureGroupModel>? procedureGroupList;

  ProcedureGroupModel? groupNow;

  bool isEdit = false;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];
  List<String> listType = [];

  int index = 0;

  init()async{

    procedureGroupList = await FireBaseProvider.instance.getAllProcedureGroup();

    for(var i in procedureGroupList!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
      listType.add(i.type);
    }

    emit(state+1);
  }

  chooseItem(ProcedureGroupModel data){
    groupNow = data;

    index = procedureGroupList!.indexOf(data);

    isEdit = false;
    emit(state+1);
  }

  openEdit(){
    isEdit = !isEdit;
    emit(state+1);
  }

  addItem(ProcedureGroupModel newItem)async{
    procedureGroupList!.add(newItem);
    groupNow = newItem;
    titleConList.add(TextEditingController(text: newItem.title));
    desConList.add(TextEditingController(text: newItem.des));
    listType.add(newItem.type);
    isEdit = true;
    index = procedureGroupList!.indexOf(newItem);
    emit(state+1);
  }

  updateDataToFb(ProcedureGroupModel data)async{
    await FireStoreDb.instance.addNewProcedureGroup(data);
    isEdit = false;
    updateItem(data);
  }

  changeType(String newValue){
    listType[index] = newValue;
    emit(state+1);
  }

  removeItem(ProcedureGroupModel data)async{
    var index = procedureGroupList!.indexWhere((e)=>e.id == data.id);
    titleConList.removeAt(index);
    desConList.removeAt(index);
    listType.removeAt(index);
    procedureGroupList!.removeAt(index);
    await FireStoreDb.instance.addNewProcedureGroup(data);
    isEdit = false;
    groupNow = null;
    emit(state+1);
  }

  updateItem(ProcedureGroupModel data)async{
    var index = procedureGroupList!.indexWhere((e)=>e.id == data.id);
    procedureGroupList![index] = data;
    groupNow = data;
    emit(state+1);
  }
}