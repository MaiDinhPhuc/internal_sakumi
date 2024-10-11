
import 'package:flutter_bloc/flutter_bloc.dart';


class DropdownCubit extends Cubit<int> {
  DropdownCubit() : super(0);

  updateOne(){
    emit(state+1);
  }

  update() {
    emit(state + 1);
  }
}
