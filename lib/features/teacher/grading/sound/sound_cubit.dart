
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundCubit extends Cubit<double> {
  SoundCubit() : super(-2);

  String activeFilePath = '';
  String activeFileType = '';
  double currentPosition = 0;
  double duration = Duration.zero.inMilliseconds.toDouble();

  change(double newPosition) {
    emit(newPosition);
  }

  changeActive(String type, String sound) {
    activeFileType = type;
    activeFilePath = sound;
  }

  loading() {
    emit(0);
  }

  pause() {
    emit(-1);
  }

  reStart() {
    emit(-2);
    activeFilePath = "";
    activeFileType = "";
  }
}