import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/feedback_model.dart';

class NoteFeedBackCubit extends Cubit<int>{
  NoteFeedBackCubit(): super(0);
  List<dynamic> listNote = [];


  loadNote(FeedBackModel feedBack){
    var listNote = feedBack.note.map((e) => true).toList();

    listNote.addAll(listNote);
    emit(state+1);
  }

  addNewNote(){
    listNote.add("");
    emit(state+1);
  }

}