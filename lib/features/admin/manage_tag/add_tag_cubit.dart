import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../model/tag_model.dart';
import '../../../utils/enum.dart';

class AddTagCubit extends Cubit<int> {
  AddTagCubit() : super(0);

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  int currentColor = 0;
  bool isDelete = false;
  SubmitStatus status = SubmitStatus.none;
  List<Color> colors = [
    const Color(0xffF44336),
    const Color(0xffFB8C00),
    const Color(0xff66BB6A),
    const Color(0xffFFE21A),
    const Color(0xff26C6DA),
    const Color(0xffAB47BC),
    const Color(0xffBFC3CC),
  ];

  setCurrentColor(int value) {
    currentColor = value;
    emitState();
  }
  setDelete(bool value) {
    isDelete = value;
    emitState();
  }
  setSubmitStatus(SubmitStatus value) {
    status = value;
    emitState();
  }

  addNewColor(Color color) {
    colors.add(color);
    setCurrentColor(colors.length - 1);
  }


  load(TagModel? tag) {
    if(tag != null) {
      currentColor = colors.indexOf(Color(tag.background));
      if(currentColor == -1) {
        addNewColor(Color(tag.background));
      }
      else {
        emitState();
      }
    }
  }
  Future<void> addTag(TagModel tag) async {
    setSubmitStatus(SubmitStatus.loading);
    bool value = await FireBaseProvider.instance.addTag(tag);
    if (value) {
      setSubmitStatus(SubmitStatus.success);
    } else {
      setSubmitStatus(SubmitStatus.error);
    }
  }

  Future<void> update(TagModel tag) async {
    setSubmitStatus(SubmitStatus.loading);
    bool value = await FireBaseProvider.instance.addTag(tag);
    if (value) {
      setSubmitStatus(SubmitStatus.success);
    } else {
      setSubmitStatus(SubmitStatus.error);
    }
  }

  Future<void> delete(TagModel tagModel) async {
    setSubmitStatus(SubmitStatus.loading);
    setDelete(true);
    bool value = await FireBaseProvider.instance.deleteTag(tagModel.id);
    if (value) {
      setSubmitStatus(SubmitStatus.success);
    } else {
      setSubmitStatus(SubmitStatus.error);
    }
  }
}
