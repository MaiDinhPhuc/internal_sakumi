import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateChooseCubit extends Cubit<int>{

  DateChooseCubit():super(0);

  DateTime? startDate;
  DateTime? endDate;
  DateTime now = DateTime.now();

  int? choose;

  List<int> listTime = [1,3,6,9,12];

  clear(){
    startDate = null;
    endDate = null;
    choose = null;
    emit(state+1);
  }

  chooseDate(int month){
    choose = month;
    startDate = DateTime(now.year, now.month - month, 21);
    endDate = DateTime(now.year, now.month, 20);
    emit(state+1);
  }

  chooseDateV2(int month){
    choose = month;
    startDate = DateTime(now.year, now.month - (month - 1), 1);
    endDate = DateTime(now.year, now.month + 1, 1);
    emit(state+1);
  }

  String getDate(){
    if(startDate == null && endDate == null) return 'dd/MM/YYYY - dd/MM/YYYY';

    String start = DateFormat('dd/MM/yyyy').format(DateTime(startDate!.year,
        startDate!.month, startDate!.day));

    String end = DateFormat('dd/MM/yyyy').format(DateTime(endDate!.year,
        endDate!.month, endDate!.day));

    return "$start - $end";
  }

  setDateTime(String startDate, String endDate){
    this.startDate = DateTime.parse(startDate);
    this.endDate = DateTime.parse(endDate);
    emit(state+1);
  }

  chooseCustom(){
    choose = 0;
    startDate = null;
    endDate = null;
    emit(state+1);
  }
}