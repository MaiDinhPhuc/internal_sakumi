import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class UpdateCubit extends Cubit<int>{
  UpdateCubit():super(0);

  updateResponsibility(TeacherClassModel newValue){
    FirebaseFirestore.instance
        .collection('teacher_class')
        .doc('teacher_${newValue.userId}_class_${newValue.classId}')
        .update({
      'responsibility': newValue.responsibility
    });
  }

  updateClassInfo(ClassModel model){
    FireBaseProvider.instance.updateClassInfo(model);
  }
}