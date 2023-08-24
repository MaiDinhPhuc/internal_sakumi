import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/model/answer_model.dart';

class ImagePickerCubit extends Cubit<List<Uint8List>> {
  ImagePickerCubit() : super([]);

  init(List<Uint8List> list){
    emit(list);
  }

  pickImage(AnswerModel answerModel) async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      answerModel.listImagePicker.add(f);
    }
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  removeImage(AnswerModel answerModel, value){
    answerModel.listImagePicker.remove(value);
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  pickImageForAll(List<AnswerModel> list)async{
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      for(var i in list){
        i.listImagePicker.add(f);
      }
    }
    var newList = list.first.listImagePicker;
    emit([...newList]);
  }

  removeImageForAll(List<AnswerModel> list, value){
    for(var i in list){
      i.listImagePicker.remove(value);
    }
    var newList = list.first.listImagePicker;
    emit([...newList]);
  }
}
