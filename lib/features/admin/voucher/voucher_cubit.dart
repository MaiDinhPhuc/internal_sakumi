import 'dart:math';
import 'dart:ui';
import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/model/voucher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

class VoucherCubit extends Cubit<int> {
  VoucherCubit() : super(0);

  TextEditingController conCode = TextEditingController();
  TextEditingController conUser = TextEditingController();
  TextEditingController conNote = TextEditingController();

  String priceVoucher = '50.000';
  String courseVoucher = AppText.txtAllCourse.text;
  bool isVoucher = true;
  bool isDownload = false;
  String qrCode = '';

  DateTime get expiredDate => DateTimeCubit.startDay;

  String createDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

  int numVoucher = 0;

  buildUI() {
    isVoucher = false;
    emit(state + 1);
  }

  selectPrice(String price) {
    priceVoucher = price;
    emit(state + 1);
  }

  selectCourse(String course) {
    courseVoucher = course;
    emit(state + 1);
  }

  randomQR() async {
    String randomString = String.fromCharCodes(Iterable.generate(
        10, (_) => characters.codeUnitAt(Random().nextInt(characters.length))));

    numVoucher = await FireBaseProvider.instance.getQuantityVoucher() + 1;

    String num = numVoucher
        .toString()
        .padLeft(6, '0');

    return 'VC$randomString$num';
  }

  quantityVoucher() async {
    qrCode = await randomQR();

    bool check = await FireBaseProvider.instance.checkExistVoucher(qrCode);

    if (check) {
      qrCode = '';
      quantityVoucher();
    } else {
      emit(state + 1);
    }
  }

  createNewVoucher(BuildContext context, VoucherModel model) async {
    waitingDialog(context);

    await FireBaseProvider.instance.addNewVoucher(model);

    if (context.mounted) {
      Navigator.pop(context);

      notificationDialog(
          context,
          AppText.txtCreateNewVoucherSuccessfully.text
              .replaceAll('@', model.voucherCode));

      isDownload = true;
    }

    emit(state+1);
  }

  downloadVoucher(RenderRepaintBoundary boundary, BuildContext context)async{
    var image = await boundary.toImage(pixelRatio: 5);
    if(kIsWeb) {
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final base64 = base64Encode(pngBytes);
      final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..download = "$qrCode.png"
        ..target = 'blank';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    }

    if(context.mounted){
      waitingDialog(context);
      await quantityVoucher();
      if(context.mounted) {
        Navigator.pop(context);
        isDownload = false;
      }
    }

    emit(state+1);
  }
}
