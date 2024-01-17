import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_dialog.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_services.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/model/answer_model.dart';

class VoiceRecordCubit extends Cubit<List<dynamic>>{
  VoiceRecordCubit() : super([]);

  init(List<dynamic> list){
    emit(list);
  }

  record(BuildContext context ,AnswerModel answerModel,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit) async {
    RecordService.instance.start();
    showDialog(
        context: context,
        builder: (context) =>  RecordDialog(stop: () async {
          Navigator.of(context).pop();
          var link = await RecordService.instance.stop();
          await RecordService.instance.dispose();
          debugPrint("=======>link; $link");
          if (link != "") {
            answerModel.listRecordUrl.add(link);
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
          var newList = answerModel.listRecordUrl;
          emit([...newList]);
        }));
  }

  recordV2(BuildContext context ,AnswerModel answerModel,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit) async {
    RecordService.instance.start();
    showDialog(
        context: context,
        builder: (context) =>  RecordDialog(stop: () async {
          Navigator.of(context).pop();
          var link = await RecordService.instance.stop();
          await RecordService.instance.dispose();
          debugPrint("=======>link; $link");
          if (link != "") {
            answerModel.listRecordUrl.add(link);
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
          var newList = answerModel.listRecordUrl;
          emit([...newList]);
        }));
  }

  removeRecord(AnswerModel answerModel,String value,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit){
    answerModel.listRecordUrl.remove(value);
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = answerModel.listRecordUrl;
    emit([...newList]);
  }

  removeRecordV2(AnswerModel answerModel,String value,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit){
    answerModel.listRecordUrl.remove(value);
    if(cubit.answers.every((element) => element.score != -1)){
      checkActiveCubit.changeActive(true);
    }else{
      if(cubit.answers.every((element) => element.newScore != -1)){
        checkActiveCubit.changeActive(true);
      }else{
        checkActiveCubit.changeActive(false);
      }
    }
    var newList = answerModel.listRecordUrl;
    emit([...newList]);
  }

  recordForAll(BuildContext context ,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit){
    for(var i in cubit.answers){
      i.listRecordUrl = [];
    }
    RecordService.instance.start();
    showDialog(
        context: context,
        builder: (context) =>  RecordDialog(stop: () async {
          Navigator.of(context).pop();
          var link = await RecordService.instance.stop();
          await RecordService.instance.dispose();
          if (link != "") {
            for(var i in cubit.answers){
              i.listRecordUrl.add(link);
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
          var newList = cubit.answers.first.listRecordUrl;
          emit([...newList]);
        }));

  }

  recordForAllV2(BuildContext context ,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit){
    for(var i in cubit.answers){
      i.listRecordUrl = [];
    }
    RecordService.instance.start();
    showDialog(
        context: context,
        builder: (context) =>  RecordDialog(stop: () async {
          Navigator.of(context).pop();
          var link = await RecordService.instance.stop();
          await RecordService.instance.dispose();
          if (link != "") {
            for(var i in cubit.answers){
              i.listRecordUrl.add(link);
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
          var newList = cubit.answers.first.listRecordUrl;
          emit([...newList]);
        }));

  }

  removeRecordForAll(List<AnswerModel> list,String value,CheckActiveCubit checkActiveCubit,DetailGradingCubit cubit){
    for(var i in list){
      i.listRecordUrl.remove(value);
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
    var newList = list.first.listRecordUrl;
    emit([...newList]);
  }

  removeRecordForAllV2(List<AnswerModel> list,String value,CheckActiveCubit checkActiveCubit,DetailGradingCubitV2 cubit){
    for(var i in list){
      i.listRecordUrl.remove(value);
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
    var newList = list.first.listRecordUrl;
    emit([...newList]);
  }

}