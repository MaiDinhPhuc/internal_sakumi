import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/model/answer_model.dart';

class ImagePickerCubit extends Cubit<List<dynamic>> {
  ImagePickerCubit() : super([]);

  init(List<dynamic> list){
    emit(list);
  }

  pickImage(AnswerModel answerModel,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit) async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      answerModel.listImagePicker.add(f);
      if(cubit.answers.every((element) => element.score != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        if(cubit.answers.every((element) => element.newScore != -1)){
          checkActiveCubit.changeActive(true);
        }else{
          checkActiveCubit.changeActive(false);
        }
      }
    }
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  pickImageV2(AnswerModel answerModel,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit) async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      answerModel.listImagePicker.add(f);
      if(cubit.answers.every((element) => element.score != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        if(cubit.answers.every((element) => element.newScore != -1)){
          checkActiveCubit.changeActive(true);
        }else{
          checkActiveCubit.changeActive(false);
        }
      }
    }
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  removeImage(AnswerModel answerModel, value,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit){
    answerModel.listImagePicker.remove(value);
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  removeImageV2(AnswerModel answerModel, value,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit){
    answerModel.listImagePicker.remove(value);
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = answerModel.listImagePicker;
    emit([...newList]);
  }

  pickImageForAll(CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit)async{
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      for(var i in cubit.answers){
        i.listImagePicker.add(f);
      }
      if(cubit.answers.every((element) => element.score != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        if(cubit.answers.every((element) => element.newScore != -1)){
          checkActiveCubit.changeActive(true);
        }else{
          checkActiveCubit.changeActive(false);
        }
      }
    }
    var newList = cubit.answers.first.listImagePicker;
    emit([...newList]);
  }

  pickImageForAllV2(CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit)async{
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      var f = image;
      for(var i in cubit.answers){
        i.listImagePicker.add(f);
      }
      if(cubit.answers.every((element) => element.score != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        if(cubit.answers.every((element) => element.newScore != -1)){
          checkActiveCubit.changeActive(true);
        }else{
          checkActiveCubit.changeActive(false);
        }
      }
    }
    var newList = cubit.answers.first.listImagePicker;
    emit([...newList]);
  }

  removeImageForAll(List<AnswerModel> list, value,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit){
    for(var i in list){
      i.listImagePicker.remove(value);
    }
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = list.first.listImagePicker;
    emit([...newList]);
  }

  removeImageForAllV2(List<AnswerModel> list, value,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit){
    for(var i in list){
      i.listImagePicker.remove(value);
    }
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = list.first.listImagePicker;
    emit([...newList]);
  }
}
