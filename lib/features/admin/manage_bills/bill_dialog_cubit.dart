import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';

class BillDialogCubit extends Cubit<int>{
  BillDialogCubit(this.billModel):super(0);

  final BillModel? billModel;
}