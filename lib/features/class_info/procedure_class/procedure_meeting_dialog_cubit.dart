import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ProcedureMeetingDialogCubit extends Cubit<int>{
  ProcedureMeetingDialogCubit(this.cubit, this.itemCubit):super(0);

  List<ProcedureItemModel>? meetingItems;

  ProcedureItemModel? procedureNow;

  ProcedureClassModel? procedureClass;

  final ProcedureClassCubit cubit;

  final ProcedureClassItemCubit itemCubit;

  List<TextEditingController> titleConList = [];
  List<TextEditingController> desConList = [];
  List<HtmlEditorController> contentCon = [];

  int index = 0;

  init(ProcedureClassModel procedureClass)async{

    this.procedureClass = procedureClass;

    var listItemId = procedureClass.info.map((e)=>e['item_id']).toList();
    meetingItems = await FireBaseProvider.instance.getProcedureItemByIDs(listItemId);

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
    emit(state+1);
  }

  addItem(List<ProcedureItemModel> list)async{
    meetingItems!.addAll(list);
    for(var i in meetingItems!){
      titleConList.add(TextEditingController(text: i.title));
      desConList.add(TextEditingController(text: i.des));
      contentCon.add(HtmlEditorController());
    }
    List<Map> info = [];

    for(var i in meetingItems!){
      info.add({
        'item_id': i.id,
        'progress': 0,
        'check': false,
      });
    }
    await FireBaseProvider.instance.addNewProcedureClass(procedureClass!.copyWith(info: info));
    cubit.updateProcedure(procedureClass!.copyWith(info: info));
    itemCubit.updateListItem(meetingItems!);
    emit(state+1);
  }

  removeItem(ProcedureItemModel data)async{
    var index = meetingItems!.indexWhere((e)=>e.id == data.id);
    titleConList.removeAt(index);
    desConList.removeAt(index);
    contentCon.removeAt(index);
    meetingItems!.removeAt(index);

    List<Map> info = [];

    for(var i in procedureClass!.info){
      if(i['item_id'] != data.id){
        info.add({
          'item_id': i['item_id'],
          'progress': i['progress'],
          'check': i['check'],
        });
      }
    }

    await FireBaseProvider.instance.addNewProcedureClass(procedureClass!.copyWith(info: info));

    cubit.updateProcedure(procedureClass!.copyWith(info: info));
    itemCubit.updateListItem(meetingItems!);

    procedureNow = null;
    emit(state+1);
  }

}