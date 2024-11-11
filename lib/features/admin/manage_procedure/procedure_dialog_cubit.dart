import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ProcedureDialogCubit extends Cubit<int> {
  ProcedureDialogCubit() : super(0);

  List<ProcedureItemModel> listChooseItem = [];

  List<int> listGroupId = [];

  List<ProcedureItemModel>? listAllItem;

  List<ProcedureGroupModel>? listGroup;

  init(ProcedureModel? procedure, String type) async {
    listGroup = (await FireBaseProvider.instance.getAllProcedureGroup()).where((e)=>e.type == type).toList();
    if (procedure != null) {
      var listId = procedure.items;
      listChooseItem =
          await FireBaseProvider.instance.getProcedureItemByIDs(listId);
      for(var i in listChooseItem){
        if(listGroupId.contains(i.group) == false){
          listGroupId.add(i.group);
        }
      }
    }
    emit(state + 1);
  }

  getItemForGroup(int groupId){
    return listChooseItem.where((e)=>e.group == groupId).toList();
  }

  String getTitle(int id){
    if(id == 0 || listGroup == null) return "KHÔNG CÓ GROUP";

    var temp = listGroup!.where((e)=>e.id == id).firstOrNull;

    if(temp == null) return "KHÔNG CÓ GROUP";

    return temp.title;
  }

  bool check(ProcedureItemModel item) {
    for (var i in listChooseItem) {
      if (i.id == item.id) {
        return true;
      }
    }

    return false;
  }

  loadAllItem(String type, List<ProcedureItemModel> listIgnore) async {
    if (listIgnore.isEmpty) {
      listAllItem = await FireBaseProvider.instance.getAllProcedureItem(type);
    } else {
      var list = listIgnore.map((e)=> e.id).toList();
      listAllItem = (await FireBaseProvider.instance.getAllProcedureItem(type))
          .where((e) => list.contains(e.id) == false)
          .toList();
    }
    emit(state + 1);
  }

  addItem(ProcedureItemModel newProcedureItem) {
    listChooseItem.add(newProcedureItem);

    var list = listChooseItem.map((e)=>e.group).toSet().toList();

    listGroupId = [];

    for(var i in list){
      if(listGroupId.contains(i) == false){
        listGroupId.add(i);
      }
    }

    emit(state + 1);
  }

  removeItem(ProcedureItemModel removeItem) {
    listChooseItem.removeWhere((e) => e.id == removeItem.id);
    var list = listChooseItem.map((e)=>e.group).toSet().toList();

    listGroupId = [];

    for(var i in list){
      if(listGroupId.contains(i) == false){
        listGroupId.add(i);
      }
    }
    emit(state + 1);
  }
}
