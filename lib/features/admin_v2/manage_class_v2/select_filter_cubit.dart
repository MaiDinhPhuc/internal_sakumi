import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_teacher_provider.dart';

class SelectFilterCubit extends Cubit<int> {
  SelectFilterCubit() : super(0);

  List<bool> listSelect = [];
  List<FilterClassType> listType = [FilterClassType.group, FilterClassType.one];
  List<FilterClassStatus> listStatusAdmin = [
    FilterClassStatus.preparing,
    FilterClassStatus.studying,
    FilterClassStatus.completed,
    FilterClassStatus.cancel
  ];
  List<FilterClassCourse> listCourse = [
    FilterClassCourse.general,
    FilterClassCourse.kaiwa,
    FilterClassCourse.jlpt,
    FilterClassCourse.kid
  ];
  List<FilterClassLevel> listLevel = [
    FilterClassLevel.n5,
    FilterClassLevel.n4,
    FilterClassLevel.n3,
    FilterClassLevel.n2,
    FilterClassLevel.n1
  ];
  List<FilterTeacherClassStatus> listStatusTeacher = [
    FilterTeacherClassStatus.preparing,
    FilterTeacherClassStatus.studying,
    FilterTeacherClassStatus.completed
  ];

  List<FilterBillStatus> listBillStatus = [
    FilterBillStatus.check,
    FilterBillStatus.notCheck
  ];
  List<FilterBillType> listBillType = [
    FilterBillType.sale1Term,
    FilterBillType.saleFull,
    FilterBillType.saleDeposit1,
    FilterBillType.saleDepositFull,
    FilterBillType.saleBSHP1,
    FilterBillType.saleBSHPFull,
    FilterBillType.combo,
    FilterBillType.saleDeposit1And1,
    FilterBillType.upSaleFull,
    FilterBillType.upSale1Term,
    FilterBillType.upSaleTo1And1,
    FilterBillType.upSaleDeposit1,
    FilterBillType.upSaleDepositFull,
    FilterBillType.upSaleBSHP1,
    FilterBillType.upSaleBSHPFull,
    FilterBillType.renew1Term,
    FilterBillType.renew2Term,
    FilterBillType.renewDeposit1,
    FilterBillType.renewDeposit2,
    FilterBillType.renewBSHP1,
    FilterBillType.renewBSHP2
  ];

  loadBillType(List<dynamic> list) {
    for (var i in listBillType) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  loadBillStatus(List<dynamic> list) {
    for (var i in listBillStatus) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  List<FilterBillStatus> convertBillStatus() {
    List<FilterBillStatus> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterBillStatus.check);
    }
    if (listSelect[1] == true) {
      filter.add(FilterBillStatus.notCheck);
    }
    return filter;
  }

  List<FilterBillType> convertBillType() {
    List<FilterBillType> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterBillType.sale1Term);
    }
    if (listSelect[1] == true) {
      filter.add(FilterBillType.saleFull);
    }
    if (listSelect[2] == true) {
      filter.add(FilterBillType.saleDeposit1);
    }
    if (listSelect[3] == true) {
      filter.add(FilterBillType.saleDepositFull);
    }
    if (listSelect[4] == true) {
      filter.add(FilterBillType.saleBSHP1);
    }
    if (listSelect[5] == true) {
      filter.add(FilterBillType.saleBSHPFull);
    }
    if (listSelect[6] == true) {
      filter.add(FilterBillType.combo);
    }
    if (listSelect[7] == true) {
      filter.add(FilterBillType.saleDeposit1And1);
    }
    if (listSelect[8] == true) {
      filter.add(FilterBillType.upSaleFull);
    }
    if (listSelect[9] == true) {
      filter.add(FilterBillType.upSale1Term);
    }
    if (listSelect[10] == true) {
      filter.add(FilterBillType.upSaleTo1And1);
    }
    if (listSelect[11] == true) {
      filter.add(FilterBillType.upSaleDeposit1);
    }
    if (listSelect[12] == true) {
      filter.add(FilterBillType.upSaleDepositFull);
    }
    if (listSelect[13] == true) {
      filter.add(FilterBillType.upSaleBSHP1);
    }
    if (listSelect[14] == true) {
      filter.add(FilterBillType.upSaleBSHPFull);
    }
    if (listSelect[15] == true) {
      filter.add(FilterBillType.renew1Term);
    }
    if (listSelect[16] == true) {
      filter.add(FilterBillType.renew2Term);
    }
    if (listSelect[17] == true) {
      filter.add(FilterBillType.renewDeposit1);
    }
    if (listSelect[18] == true) {
      filter.add(FilterBillType.renewDeposit2);
    }
    if (listSelect[19] == true) {
      filter.add(FilterBillType.renewBSHP1);
    }
    if (listSelect[20] == true) {
      filter.add(FilterBillType.renewBSHP2);
    }

    return filter;
  }

  loadLevel(List<dynamic> list) {
    for (var i in listLevel) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  loadCourse(List<dynamic> list) {
    for (var i in listCourse) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  loadType(List<dynamic> list) {
    for (var i in listType) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  List<FilterClassType> convertType() {
    List<FilterClassType> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterClassType.group);
    }
    if (listSelect[1] == true) {
      filter.add(FilterClassType.one);
    }
    return filter;
  }

  List<FilterClassLevel> convertLevel() {
    List<FilterClassLevel> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterClassLevel.n5);
    }
    if (listSelect[1] == true) {
      filter.add(FilterClassLevel.n4);
    }
    if (listSelect[2] == true) {
      filter.add(FilterClassLevel.n3);
    }
    if (listSelect[3] == true) {
      filter.add(FilterClassLevel.n2);
    }
    if (listSelect[4] == true) {
      filter.add(FilterClassLevel.n1);
    }
    return filter;
  }

  List<FilterClassCourse> convertCourse() {
    List<FilterClassCourse> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterClassCourse.general);
    }
    if (listSelect[1] == true) {
      filter.add(FilterClassCourse.kaiwa);
    }
    if (listSelect[2] == true) {
      filter.add(FilterClassCourse.jlpt);
    }
    if (listSelect[3] == true) {
      filter.add(FilterClassCourse.kid);
    }
    return filter;
  }

  loadStatusAdmin(List<dynamic> list) {
    for (var i in listStatusAdmin) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  loadStatusTeacher(List<dynamic> list) {
    for (var i in listStatusTeacher) {
      if (list.contains(i)) {
        listSelect.add(true);
      } else {
        listSelect.add(false);
      }
    }
    emit(state + 1);
  }

  List<FilterClassStatus> convertStatusAdmin() {
    List<FilterClassStatus> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterClassStatus.preparing);
    }
    if (listSelect[1] == true) {
      filter.add(FilterClassStatus.studying);
    }
    if (listSelect[2] == true) {
      filter.add(FilterClassStatus.completed);
    }
    if (listSelect[3] == true) {
      filter.add(FilterClassStatus.cancel);
    }
    return filter;
  }

  List<FilterTeacherClassStatus> convertStatusTeacher() {
    List<FilterTeacherClassStatus> filter = [];
    if (listSelect[0] == true) {
      filter.add(FilterTeacherClassStatus.preparing);
    }
    if (listSelect[1] == true) {
      filter.add(FilterTeacherClassStatus.studying);
    }
    if (listSelect[2] == true) {
      filter.add(FilterTeacherClassStatus.completed);
    }
    return filter;
  }
}
