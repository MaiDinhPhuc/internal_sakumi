import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';


class ManageTeacherTabCubit extends Cubit<int> {
  ManageTeacherTabCubit() :super(0);

  String tabType = 'class';

  final TeacherReportCubit reportCubit = TeacherReportCubit();

  changeTab(String value){
    tabType = value;
    emit(state+1);
  }

}