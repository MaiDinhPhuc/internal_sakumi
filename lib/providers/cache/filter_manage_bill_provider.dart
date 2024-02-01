import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterBillStatus { refund, notRefund }
extension FilterBillStatusEx on FilterBillStatus {
  String get status {
    switch (this) {
      case FilterBillStatus.refund:
        return "refund";
      case FilterBillStatus.notRefund:
        return "notRefund";
    }
  }

  String get title {
    switch (this) {
      case FilterBillStatus.refund:
        return "Đã hoàn tiền";
      case FilterBillStatus.notRefund:
        return "Chưa hoàn tiền";
    }
  }
}

enum FilterBillType { saleFull, salePart,saleFillFull, upSaleFull, upSalePart,upSaleFillFull, renewFull, renewPart, renewFillFull}
extension FilterBillTypeEx on FilterBillType {
  String get status {
    switch (this) {
      case FilterBillType.saleFull:
        return "sale_full";
      case FilterBillType.salePart:
        return "sale_part";
      case FilterBillType.upSaleFull:
        return "upSale_full";
      case FilterBillType.upSalePart:
        return "upSale_part";
      case FilterBillType.renewFull:
        return "renew_full";
      case FilterBillType.renewPart:
        return "renew_part";
      case FilterBillType.saleFillFull:
        return "sale_fill_full";
      case FilterBillType.upSaleFillFull:
        return "upSale_fill_full";
      case FilterBillType.renewFillFull:
        return "renew_fill_full";
    }
  }

  String get title {
    switch (this) {
      case FilterBillType.saleFull:
        return "sale_full";
      case FilterBillType.salePart:
        return "sale_part";
      case FilterBillType.upSaleFull:
        return "upSale_full";
      case FilterBillType.upSalePart:
        return "upSale_part";
      case FilterBillType.renewFull:
        return "renew_full";
      case FilterBillType.renewPart:
        return "renew_part";
      case FilterBillType.saleFillFull:
        return "sale_fill_full";
      case FilterBillType.upSaleFillFull:
        return "upSale_fill_full";
      case FilterBillType.renewFillFull:
        return "renew_fill_full";
    }
  }
}

enum BillFilter { status, type}

class BillFilterCubit extends Cubit<int> {
  BillFilterCubit() : super(0) {
    _init();
  }

  static const Map<BillFilter, List> defaultFilter = {
    BillFilter.status: [
      FilterBillStatus.refund,
      FilterBillStatus.notRefund
    ],
    BillFilter.type:[
      FilterBillType.saleFull,
      FilterBillType.salePart
    ]
  };

  Map<BillFilter, List> _filter = {};

  Map<BillFilter, List> get filter => _filter;

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(convertFilterEncode());
    prefs.setString('filterBill', jsonString);
  }

  Map<String, dynamic> convertFilterEncode() {
    var listStatus = filter[BillFilter.status]!
        .map((e) => (e as FilterBillStatus).title)
        .toList();
    var listType = filter[BillFilter.type]!
        .map((e) => (e as FilterBillType).title)
        .toList();

    return {
      "status": listStatus,
      "type": listType
    };
  }

  Map<BillFilter, List> convertFilterDecode(dynamic json) {
    var listStatus = [];
    for (var i in json["status"]) {
      switch (i) {
        case "Đã hoàn tiền":
          listStatus.add(FilterBillStatus.refund);
          break;
        case "Chưa hoàn tiền":
          listStatus.add(FilterBillStatus.notRefund);
          break;
      }
    }

    var listType = [];
    for (var i in json["type"]) {
      switch (i) {
        case "sale_full":
          listType.add(FilterBillType.saleFull);
          break;
        case "sale_part":
          listType.add(FilterBillType.salePart);
          break;
        case "sale_fill_full":
          listType.add(FilterBillType.saleFillFull);
          break;
        case "upSale_full":
          listType.add(FilterBillType.upSaleFull);
          break;
        case "upSale_part":
          listType.add(FilterBillType.upSalePart);
          break;
        case "upSale_fill_full":
          listType.add(FilterBillType.upSaleFillFull);
          break;
        case "renew_full":
          listType.add(FilterBillType.renewFull);
          break;
        case "renew_part":
          listType.add(FilterBillType.renewPart);
          break;
        case "renew_fill_full":
          listType.add(FilterBillType.renewFillFull);
          break;
      }
    }
    return {
      BillFilter.status: listStatus,
      BillFilter.type: listType
    };
  }

  Future<Map<BillFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterBill');
    if (jsonString != null) {
      return convertFilterDecode(json.decode(jsonString));
    }
    return null;
  }

  _init() async {
    _filter = await _fromPref() ??
        defaultFilter.keys.fold({}, (pre, key) {
          pre[key] = defaultFilter[key]!;
          return pre;
        });
    emit(state + 1);
  }

  update(BillFilter billFilter, List selectedList) async {
    bool areListsEqual =
    const ListEquality().equals(_filter[billFilter], selectedList);
    if (!areListsEqual) {
      _filter[billFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}