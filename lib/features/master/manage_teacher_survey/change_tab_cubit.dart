import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeTabManageTeacherSurveyCubit extends Cubit<bool>{
  ChangeTabManageTeacherSurveyCubit(): super(true);

  change(){
    emit(!state);
  }

}