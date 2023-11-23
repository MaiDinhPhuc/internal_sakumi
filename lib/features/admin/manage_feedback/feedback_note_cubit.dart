import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/feedback_model.dart';

class NoteFeedBackCubit extends Cubit<int>{
  NoteFeedBackCubit(): super(0);

  List<dynamic> listNote = [];

  List<String> list = [];


  loadNote(FeedBackModel feedBack){
    listNote.addAll(feedBack.note);
    emit(state+1);
  }

  addNewNote(){
    listNote.add("hihi");
    listNote.add("haha");
    print(listNote);
    emit(state+1);
  }

}