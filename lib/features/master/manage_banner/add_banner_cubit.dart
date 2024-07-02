import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/model/banner_model.dart';
import 'package:internal_sakumi/model/group_tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../model/tag_model.dart';
import '../../../utils/enum.dart';
import 'dart:typed_data';

class AddBannerCubit extends Cubit<int> {
  AddBannerCubit() : super(0);
  Uint8List? imgData;
  bool validateImg = true;
  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  SubmitStatus status = SubmitStatus.none;

  setValidateImg(bool value) {
    validateImg = value;
    emitState();
  }

  setImage(Uint8List? value) {
    imgData = value;
    emitState();
  }

  setSubmitStatus(SubmitStatus value) {
    status = value;
    emitState();
  }

  Future<void>  addBanner(BannerModel banner) async {

    bool value = await FireBaseProvider.instance.addBanner(banner);
    if (value) {
      setSubmitStatus(SubmitStatus.success);
    } else {
      setSubmitStatus(SubmitStatus.error);
    }
  }
}