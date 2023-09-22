import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/prefKey_configs.dart';

class AppBarInfoTeacherCubit extends Cubit<TeacherModel?> {
  AppBarInfoTeacherCubit() : super(null);

  load(context) async {
    emit(null);
    SharedPreferences localData = await SharedPreferences.getInstance();
    var profileTeacher = await FireBaseProvider.instance
        .getTeacherByTeacherCode(localData.getString(PrefKeyConfigs.code).toString());
    emit(profileTeacher);
  }

  update(TeacherModel model) {
    emit(model);
  }
}