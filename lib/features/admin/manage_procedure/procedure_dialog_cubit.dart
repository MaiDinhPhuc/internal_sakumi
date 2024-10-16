import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ProcedureDialogCubit extends Cubit<int> {
  ProcedureDialogCubit() : super(0);

  List<ProcedureItemModel> listChooseItem = [];

  List<ProcedureItemModel>? listAllItem;

  init(ProcedureModel? procedure) async {
    if (procedure != null) {
      var listId = procedure.items;
      listChooseItem =
          await FireBaseProvider.instance.getProcedureItemByIDs(listId);
    }
    emit(state + 1);
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
    emit(state + 1);
  }

  removeItem(ProcedureItemModel removeItem) {
    listChooseItem.removeWhere((e) => e.id == removeItem.id);
    emit(state + 1);
  }
}
