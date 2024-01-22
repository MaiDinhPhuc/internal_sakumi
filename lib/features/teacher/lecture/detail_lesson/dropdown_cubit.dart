
import 'package:flutter_bloc/flutter_bloc.dart';


class DropdownCubit extends Cubit<int> {
  DropdownCubit() : super(0);

  update() {
    emit(state + 1);
  }
}
