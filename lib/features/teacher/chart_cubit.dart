import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';

class DropdownCubit extends Cubit<int> {
  DropdownCubit() : super(0);

  update() {
    emit(state + 1);
  }
}

class ChartCubit extends Cubit<int> {
  final int classId;
  ChartCubit(this.classId) : super(0);

  List<StudentClassModel>? listStudentClass;
  init(context) {
    loadQuantity(context, classId);
  }

  loadQuantity(BuildContext context, int classId) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    listStudentClass = await adminRepository.getStudentClassByClassId(classId);
    emit(state + 1);
  }
}
