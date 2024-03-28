import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ListTeacherCubit extends Cubit<int> {
  ListTeacherCubit() : super(0) {
    loadData();
  }

  List<TeacherModel>? listTeacher;

  bool canGetMore = true;

  List<String> listStatus = [
    'Training',
    'Thực chiến',
    'Thử việc',
    'Chính thức',
    'Tạm nghỉ',
    'Nghỉ'
  ];

  List<bool> status = [true, true, true, true, true, true];

  loadData() async {
    List<String> list = [];
    for (int i = 0; i < status.length; i++) {
      if (status[i]) {
        list.add(listStatus[i]);
      }
    }
    listTeacher = await FireBaseProvider.instance.getTeacherWithStatusFilter(list);
    if(listTeacher!.length < 10){
      canGetMore = false;
    }
    emit(state + 1);
  }

  getMore() async {
    List<String> list = [];
    for (int i = 0; i < status.length; i++) {
      if (status[i]) {
        list.add(listStatus[i]);
      }
    }
    var listNew = await FireBaseProvider.instance.getMoreTeacherWithStatusFilter(list, listTeacher!.last.userId);

    listTeacher!.addAll(listNew);

    if(listNew.length < 10){
      canGetMore = false;
    }

    emit(state+1);
  }
}
