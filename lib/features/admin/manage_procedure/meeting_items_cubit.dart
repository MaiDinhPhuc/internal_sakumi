import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class MeetingItemsCubit extends Cubit<int>{
  MeetingItemsCubit():super(0);

  List<ProcedureItemModel>? meetingItems;

  ProcedureItemModel? procedureNow;
  List<ProcedureGroupModel>? listProcedureGroup;
  bool isEdit = false;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];
  List<HtmlEditorController> contentCon = [];
  List<String> listTitleChoose = ["KHÔNG CÓ GROUP"];
  List<int> listIdChoose = [0];
  List<String> listGroupTitle = [];
  List<int> listGroupId = [];

  int index = 0;

  init()async{

    meetingItems = await FireBaseProvider.instance.getAllProcedureItem('meeting');
    listProcedureGroup = (await FireBaseProvider.instance.getAllProcedureGroup()).where((e)=>e.type == "meeting").toList();

    for(var i in listProcedureGroup!){
      listTitleChoose.add(i.title);
      listIdChoose.add(i.id);
    }
    for(var i in meetingItems!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
      contentCon.add(HtmlEditorController());
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

    index = meetingItems!.indexOf(data);

    isEdit = false;
    emit(state+1);
  }

  openEdit(){
    isEdit = !isEdit;
    emit(state+1);
  }

  updateGroup(String value){
    var temp = listTitleChoose.indexOf(value);
    listGroupTitle[index] = value;
    listGroupId[index] = listIdChoose[temp];
    emit(state+1);
  }
  addItem(ProcedureItemModel newItem)async{
    meetingItems!.add(newItem);
    procedureNow = newItem;
    titleConList.add(TextEditingController(text: newItem.title));
    desConList.add(TextEditingController(text: newItem.des));
    contentCon.add(HtmlEditorController());
    listGroupId.add(0);
    listGroupTitle.add('KHÔNG CÓ GROUP');
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
    listGroupId.removeAt(index);
    listGroupTitle.removeAt(index);
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