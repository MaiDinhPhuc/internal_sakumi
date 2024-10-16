import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class MeetingItemsCubit extends Cubit<int>{
  MeetingItemsCubit():super(0);

  List<ProcedureItemModel>? meetingItems;

  ProcedureItemModel? procedureNow;

  bool isEdit = false;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];
  List<HtmlEditorController> contentCon = [];

  int index = 0;

  init()async{

    meetingItems = await FireBaseProvider.instance.getAllProcedureItem('meeting');

    for(var i in meetingItems!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
      contentCon.add(HtmlEditorController());
    }

    emit(state+1);
  }

  chooseItem(ProcedureItemModel data){
    procedureNow = data;

    index = meetingItems!.indexOf(data);

    isEdit = false;
    emit(state+1);
  }

  openEdit(){
    isEdit = !isEdit;
    emit(state+1);
  }

  addItem(ProcedureItemModel newItem)async{
    meetingItems!.add(newItem);
    procedureNow = newItem;
    titleConList.add(TextEditingController(text: newItem.title));
    desConList.add(TextEditingController(text: newItem.des));
    contentCon.add(HtmlEditorController());
    isEdit = true;
    index = meetingItems!.indexOf(newItem);
    emit(state+1);
  }

  updateDataToFb(ProcedureItemModel data)async{
    await FireBaseProvider.instance.addNewProcedureItem(data);
    isEdit = false;
    updateItem(data);
  }

  removeItem(ProcedureItemModel data)async{
    var index = meetingItems!.indexWhere((e)=>e.id == data.id);
    titleConList.removeAt(index);
    desConList.removeAt(index);
    contentCon.removeAt(index);
    meetingItems!.removeAt(index);
    await FireBaseProvider.instance.addNewProcedureItem(data);
    isEdit = false;
    procedureNow = null;
    emit(state+1);
  }

  updateItem(ProcedureItemModel data)async{
    var index = meetingItems!.indexWhere((e)=>e.id == data.id);
    meetingItems![index] = data;
    procedureNow = data;
    emit(state+1);
  }
}