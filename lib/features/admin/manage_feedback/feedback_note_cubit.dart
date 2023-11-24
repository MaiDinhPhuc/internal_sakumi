import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

import 'feedback_cubit.dart';

class NoteFeedBackCubit extends Cubit<int>{
  NoteFeedBackCubit(): super(0);

  List<dynamic> listNote = [];

  List<TextEditingController> listController = [];

  bool canAdd = true;

  loadNote(FeedBackModel feedBack){
    listNote.addAll(feedBack.note);
    for(var i in feedBack.note){
      listController.add(TextEditingController(text: i));
    }
    emit(state+1);
  }

  sendNote(FeedBackModel feedBack, FeedBackCubit noteCubit)async{
    listNote.remove(listNote.last);
    listNote.add(listController.last.text);
    await FireStoreDb.instance.updateFeedBackNote(feedBack.classId,feedBack.date, listNote);
    noteCubit.changeNote(feedBack,listNote);
    canAdd = true;
    emit(state+1);
  }

  addNewNote(){
    listController.add(TextEditingController(text: ""));
    listNote.add("");
    canAdd = false;
    emit(state+1);
  }

}