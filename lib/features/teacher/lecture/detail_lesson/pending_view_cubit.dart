import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';

class PendingViewCubit extends Cubit<int>{
  PendingViewCubit():super(0);

  bool check1 = false;
  bool check2 = true;
  bool check3 = true;
  String? teacherNote;
  String? supportNote;
  load(ClassModel2 classModel){
    teacherNote = classModel.lessonResults!.last.noteForTeacher;
    if(teacherNote == ""){
      check2 = true;
    }
    supportNote = classModel.lessonResults!.last.supportNoteForTeacher;
    if(supportNote == ""){
      check3 = true;
    }
    emit(state+1);
  }

  updateCheck1(){
    check1 = !check1;
    emit(state+1);
  }
  updateCheck2(){
    check2 = !check2;
    emit(state+1);
  }
  updateCheck3(){
    check3 = !check3;
    emit(state+1);
  }

}