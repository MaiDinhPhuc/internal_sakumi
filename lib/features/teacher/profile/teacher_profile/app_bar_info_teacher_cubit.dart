import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../configs/prefKey_configs.dart';

class AppBarInfoTeacherCubit extends Cubit<TeacherModel?> {
  AppBarInfoTeacherCubit() : super(null);

  TeacherModel? teacherModel;

  load() async {
    // emit(null);

    // if(state != null) return;
    SharedPreferences localData = await SharedPreferences.getInstance();
    int userId = localData.getInt(PrefKeyConfigs.userId)!;

    if (state != null && state!.userId == userId) return;

    await DataProvider.teacherById(userId, loadTeacherInfo);

  }

  loadTeacherInfo(Object teacher){
    teacherModel = teacher as TeacherModel;
    emit(teacherModel);
  }

  update(TeacherModel model) {
    emit(model);
  }
}
