import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<List<Uint8List>>{
  ImagePickerCubit(List<Uint8List> list): super(list);
}