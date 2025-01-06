import 'dart:math';
import 'dart:ui';
import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/model/voucher_app_model.dart';
import 'package:internal_sakumi/model/voucher_course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

class VoucherCubit extends Cubit<int> {
  VoucherCubit() : super(0) {
    quantityVoucherCourse();
  }

  String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  //date expired
  DateTime get expiredVoucherCourseDate => DateTimeCubit.startDay;
  DateTime get expiredVoucherAppDate => DateTimeCubitV2.day;

  String createDate = DateFormat('dd/MM/yyyy').format(DateTime.now());


  bool isVoucherCourse = true;

  String qrCode = '';
  int numVoucher = 0;
  bool isDownload = false;

  TextEditingController conUser = TextEditingController();
  TextEditingController conCode = TextEditingController();
  TextEditingController conNote = TextEditingController();

  //info voucher course
  String priceVoucherCourse = '50.000';

  String courseVoucher = AppText.txtAllCourse.text;

  List<VoucherCourseModel> listSearchVoucherCourse = [];

  VoucherCourseModel? voucherCourseModel;

  String status = AppText.txtNew.text;

  String noteValue = '';

  bool isFullCourse = false;

  //info voucher app
  String numMonths = "2";
  String numDevices = "3";
  int dateExpired = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      DateTime.now().day).millisecondsSinceEpoch;

  List<VoucherAppModel> listSearchVoucherApp = [];

  VoucherAppModel? voucherAppModel;


  //Change tab
  String tab = AppText.txtCourse.text;
  changeTab(String newTab)async{
    if(newTab != tab){
      tab = newTab;
      if(newTab == AppText.txtCourse.text){
        await quantityVoucherCourse();
      }
      if(newTab == AppText.txtApp.text){
        await quantityVoucherApp();
      }
      emit(state+1);
    }
  }

  //select type search
  String searchType = AppText.txtRecipientCode.text;
  selectSearchType(String type) {
    searchType = type;
    emit(state + 1);
  }

  //check expired
  isExpired(String date) {
    var list = date.split('/');
    var temp = list.reversed.join('-');
    return DateTime.parse(temp).isBefore(DateTime.now());
  }

  //manage voucher course
  buildUIVoucherCourse() {
    isVoucherCourse = false;
    emit(state + 1);
  }

  selectPrice(String price) {
    priceVoucherCourse = price;
    emit(state + 1);
  }

  selectCourse(String course) {
    courseVoucher = course;
    emit(state + 1);
  }

  selectStatus(String sts) {
    status = sts;
    emit(state + 1);
  }

  updateNote(String v) {
    noteValue = v;
    emit(state + 1);
  }

  selectFullCourse() {
    isFullCourse = !isFullCourse;
    emit(state + 1);
  }

  randomQRVoucherCourse() async {
    String randomString = String.fromCharCodes(Iterable.generate(
        5, (_) => characters.codeUnitAt(Random().nextInt(characters.length))));

    // String num = numVoucher
    //     .toString()
    //     .padLeft(6, '0');
    numVoucher = DateTime.now().millisecondsSinceEpoch;

    return 'VC$randomString$numVoucher';
  }

  quantityVoucherCourse() async {
    qrCode = await randomQRVoucherCourse();

    bool check = await FireBaseProvider.instance.checkExistVoucherCourse(qrCode);

    if (check) {
      qrCode = '';
      quantityVoucherCourse();
    } else {
      emit(state + 1);
    }
  }

  createNewVoucherCourse(BuildContext context, VoucherCourseModel model) async {
    waitingDialog(context);

    await FireBaseProvider.instance.addNewVoucherCourse(model);

    if (context.mounted) {
      Navigator.pop(context);

      notificationDialog(
          context,
          AppText.txtCreateNewVoucherSuccessfully.text
              .replaceAll('@', model.voucherCode));

      isDownload = true;
    }

    emit(state + 1);
  }

  downloadVoucherCourse(RenderRepaintBoundary boundary, BuildContext context) async {
    var image = await boundary.toImage(pixelRatio: 5);
    if (kIsWeb) {
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final base64 = base64Encode(pngBytes);
      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$base64')
        ..download = "$qrCode.png"
        ..target = 'blank';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    }

    if (context.mounted) {
      waitingDialog(context);
      await quantityVoucherCourse();
      if (context.mounted) {
        Navigator.pop(context);
        isDownload = false;
      }
    }

    emit(state + 1);
  }

  searchVoucherCourse(String text) async {
    if (text.isEmpty) {
      listSearchVoucherCourse = [];
    } else {
      debugPrint('===========> searchVoucher $text');
      listSearchVoucherCourse = await FireBaseProvider.instance.searchVoucherCourse(
          text,
          searchType == AppText.txtRecipientCode.text
              ? 'recipient_code'
              : 'voucher_code');
    }
    emit(state + 1);
  }

  showInfoVoucherCourse(String code) async {
    voucherCourseModel =
        await FireBaseProvider.instance.getVoucherCourseByVoucherCode(code);
    noteValue = voucherCourseModel!.noted;
  }

  showInfoVoucherApp(String code) async {
    voucherAppModel =
    await FireBaseProvider.instance.getVoucherAppByVoucherCode(code);
    noteValue = voucherAppModel!.noted;
  }

  updateVoucherCourse(String usedUserCode, String noted, String voucherCode,
      String date) async {
    await FireBaseProvider.instance
        .updateVoucherCourse(usedUserCode, noted, voucherCode, date);
  }

  isActiveVoucherCourse() {
    if (voucherCourseModel!.usedDate.isEmpty) {
      if(isExpired(voucherCourseModel!.expiredDate)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  //manage voucher app
  randomQRVoucherApp() async {

    final random = Random();
    final startIndexCharacter = random.nextInt(characters.length - 1);
    String randomString = characters.substring(startIndexCharacter, startIndexCharacter + 2);

    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    final startIndexTime = random.nextInt(dateTime.length - 1);
    numVoucher = int.parse(dateTime.substring(startIndexTime, startIndexTime + 4));

    return '$randomString$numVoucher';
  }

  quantityVoucherApp() async {
    qrCode = await randomQRVoucherApp();

    bool check = await FireBaseProvider.instance.checkExistVoucherApp(qrCode);

    if (check) {
      qrCode = '';
      quantityVoucherApp();
    } else {
      emit(state + 1);
    }
  }

  selectMonths(String month) {
    if(month == "Trọn đời"){
      numMonths = "1000";
    }else{
      numMonths = month;
    }

    emit(state + 1);
  }

  selectDevices(String device) {
    numDevices = device;
    emit(state + 1);
  }

  update(int newDate){
    dateExpired = newDate;
    emit(state+1);
  }

  createNewVoucherApp(BuildContext context, VoucherAppModel model) async {
    waitingDialog(context);

    await FireBaseProvider.instance.addNewVoucherApp(model);

    if (context.mounted) {
      Navigator.pop(context);

      notificationDialog(
          context,
          AppText.txtCreateNewVoucherSuccessfully.text
              .replaceAll('@', model.voucherCode));

      isDownload = true;
    }

    emit(state + 1);
  }

  searchVoucherApp(String text) async {
    if (text.isEmpty) {
      listSearchVoucherApp = [];
    } else {
      debugPrint('===========> searchVoucher $text');
      listSearchVoucherApp = await FireBaseProvider.instance.searchVoucherApp(
          text,
          searchType == AppText.txtRecipientCode.text
              ? 'recipient_code'
              : 'voucher_code');
    }
    emit(state + 1);
  }

  String parseDate(int dateFromMilli) {

    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateFromMilli);

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    String formattedDate = dateFormat.format(date);

    return formattedDate;
  }

  isActiveVoucherApp() {
    if (voucherAppModel!.usedData.isEmpty) {
      if(isExpired(parseDate(voucherAppModel!.expiredDate))) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  String convertUsedCode(){
    if(voucherAppModel!.usedData.isEmpty) return "";

    String list = "";

    for(var e in voucherAppModel!.usedData){
      if(voucherAppModel!.usedData.indexOf(e) == 0){
        list = e[''];
      }else{
        list = "$list, ${e['user']}";
      }

    }

    return list;
  }

  updateVoucherApp( String noted, String voucherCode) async {
    await FireBaseProvider.instance
        .updateVoucherApp( noted, voucherCode);
  }
}
