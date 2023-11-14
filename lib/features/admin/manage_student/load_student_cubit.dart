import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class LoadListStudentCubit extends Cubit<int> {
  LoadListStudentCubit() : super(0);

  List<StudentModel> listData = [];

  int? totalCount;
  int? lastId;


  loadFirst() async {
    List<StudentModel> list = await FireBaseProvider.instance.get10StudentFirst();
    totalCount = (await FireStoreDb.instance.getCount("students")).count;
    listData.addAll(list);
    lastId = list.last.userId;
    emit(state+1);
  }

  loadMore() async{
    List<StudentModel> list = await FireBaseProvider.instance.get10Student(lastId!);
    listData.addAll(list);
    lastId = list.last.userId;
    emit(state+1);
  }

  update(int index, StudentModel student)async{
    listData[index] = student;
    emit(state+1);
  }
}