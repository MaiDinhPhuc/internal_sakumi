import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CheckListItemsCubit extends Cubit<int>{
  CheckListItemsCubit():super(0);

  List<ProcedureItemModel>? checkListItems;

  ProcedureItemModel? procedureNow;
  
  bool isEdit = false;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];

  int index = 0;
  
  init()async{
    
    checkListItems = await FireBaseProvider.instance.getAllProcedureItem('checklist');

    for(var i in checkListItems!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
    }
    
    emit(state+1);
  }

  chooseItem(ProcedureItemModel data){
    procedureNow = data;

    index = checkListItems!.indexOf(data);

    isEdit = false;
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
    isEdit = true;
    index = checkListItems!.indexOf(newItem);
    emit(state+1);
  }
  
  updateDataToFb(ProcedureItemModel data)async{
    await FireBaseProvider.instance.addNewProcedureItem(data);
    isEdit = false;
    updateItem(data);
  }

  removeItem(ProcedureItemModel data)async{
    var index = checkListItems!.indexWhere((e)=>e.id == data.id);
    titleConList.removeAt(index);
    desConList.removeAt(index);
    checkListItems!.removeAt(index);
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