import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleTabCubit extends Cubit<int>{
  ScheduleTabCubit(this.role):super(0){
    loadData();
  }

  final String role;
  TeacherModel? teacher;
  int? teacherId;
  bool isEdit = false;

  List<String> listDay = [
    "Thứ HAI",
    "Thứ BA",
    "Thứ TƯ",
    "Thứ NĂM",
    "Thứ SÁU",
    "Thứ BẢY",
    "CHỦ NHẬT"
  ];

  loadData()async{
    if(role == "admin"){
      teacherId = int.parse(TextUtils.getName());
    }else{
      SharedPreferences localData = await SharedPreferences.getInstance();
      int userId = localData.getInt(PrefKeyConfigs.userId)!;
      teacherId = userId;
    }
    await DataProvider.teacherById(teacherId!, loadTeacherInfo);
    emit(state+1);
  }

  changeEdit(){
    isEdit = true;
    emit(state+1);
  }

  loadTeacherInfo(Object teacher) {
    this.teacher = teacher as TeacherModel;
  }
}
