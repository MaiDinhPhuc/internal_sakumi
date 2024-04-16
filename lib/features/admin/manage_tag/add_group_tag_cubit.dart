import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/model/group_tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../model/tag_model.dart';
import '../../../utils/enum.dart';

class AddGroupTagCubit extends Cubit<int> {
  AddGroupTagCubit() : super(0);

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }
  
  SubmitStatus status = SubmitStatus.none;
  setSubmitStatus(SubmitStatus value) {
    status = value;
    emitState();
  }

  Future<void>  addGroupTag(GroupTagModel groupTag) async {
    setSubmitStatus(SubmitStatus.loading);
    bool value = await FireBaseProvider.instance.addGroupTag(groupTag);
    if (value) {
      setSubmitStatus(SubmitStatus.success);
    } else {
      setSubmitStatus(SubmitStatus.error);
    }
  }
}
