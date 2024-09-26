import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InputDate extends StatelessWidget {
  final String title;
  final bool isStartDate;
  final String? errorText;
  late bool isVoucherCourse;
  final Function? onPressed;
  InputDate(
      {required this.title,
      this.isStartDate = true,
      this.errorText,
      this.isVoucherCourse = false, this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          BlocProvider(
              create: (context) => DateTimeCubit()
                ..selectedDate(isStartDate
                    ? DateTimeCubit.startDay
                    : DateTimeCubit.endDay),
              child: BlocBuilder<DateTimeCubit, DateTime>(
                builder: (c, date) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 0)),
                    child: InkWell(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: (DateTimeCubit.endDay == DateTime.now() &&
                              !isStartDate)
                          ? () {}
                          : () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                        child: SizedBox(
                                      height: Resizable.size(context, 250),
                                      width: Resizable.size(context, 250),
                                      child: SfDateRangePicker(
                                        headerHeight:
                                            Resizable.size(context, 50),
                                        headerStyle: DateRangePickerHeaderStyle(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    Resizable.font(context, 24),
                                                color: Colors.black)),
                                        showNavigationArrow: true,
                                        onSelectionChanged: (v) {
                                          isStartDate
                                              ? DateTimeCubit.startDay = v.value
                                              : DateTimeCubit.endDay = v.value;
                                          BlocProvider.of<DateTimeCubit>(c)
                                              .selectedDate(v.value);
                                          if(onPressed != null){onPressed!();}
                                          Navigator.pop(context);
                                        },
                                        //showActionButtons: true,
                                        // onCancel: () => Navigator.pop(context),
                                        // onSubmit: (value) {
                                        //   if (value is DateTime) {
                                        //     BlocProvider.of<DateTimeCubit>(c).selectedDate(value);
                                        //   }
                                        // },
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                      ),
                                    ));
                                  });
                            },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 5)),
                        child: IgnorePointer(
                          child: TextFormField(
                            validator: (value) {
                              if (DateTimeCubit.startDay
                                      .compareTo(DateTimeCubit.endDay) >=
                                  0) {
                                return errorText;
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: DateFormat('dd/MM/yyyy').format(
                                  DateTime(
                                      date.year,
                                      date.month + (isVoucherCourse ? 3 : 0),
                                      date.day)),
                              isDense: true,
                              fillColor: Colors.white,
                              hoverColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xffE0E0E0),
                                    width: Resizable.size(context, 0.5)),
                                borderRadius: BorderRadius.circular(
                                    Resizable.padding(context, 5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xffE0E0E0),
                                    width: Resizable.size(context, 0.5)),
                                borderRadius: BorderRadius.circular(
                                    Resizable.padding(context, 5)),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Resizable.padding(context, 5)),
                                  borderSide: BorderSide(
                                      color: const Color(0xffE0E0E0),
                                      width: Resizable.size(context, 0.5))),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}

class InputDateVoucherApp extends StatelessWidget {
  final String title;
  final VoucherCubit cubit;
  const InputDateVoucherApp(
      {required this.title,required this.cubit,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          BlocProvider(
              create: (context) => DateTimeCubitV2()
                ..selectedDate(DateTime(
                    DateTime.now().year,
                    DateTime.now().month + 1,
                    DateTime.now().day)),
              child: BlocBuilder<DateTimeCubitV2, DateTime>(
                builder: (c, date) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 0)),
                    child: InkWell(
                      overlayColor:
                      WidgetStateProperty.all(Colors.transparent),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                  child: SizedBox(
                                    height: Resizable.size(context, 250),
                                    width: Resizable.size(context, 250),
                                    child: SfDateRangePicker(
                                      headerHeight:
                                      Resizable.size(context, 50),
                                      headerStyle: DateRangePickerHeaderStyle(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                              Resizable.font(context, 24),
                                              color: Colors.black)),
                                      showNavigationArrow: true,
                                      onSelectionChanged: (v) {
                                        DateTimeCubitV2.day = v.value;
                                        BlocProvider.of<DateTimeCubitV2>(c)
                                            .selectedDate(v.value);
                                        cubit.update(DateTime(
                                            v.value.year,
                                            v.value.month,
                                            v.value.day).millisecondsSinceEpoch);
                                        Navigator.pop(context);
                                      },
                                      selectionMode:
                                      DateRangePickerSelectionMode.single,
                                    ),
                                  ));
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 5)),
                        child: IgnorePointer(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: DateFormat('dd/MM/yyyy').format(
                                  DateTime(
                                      date.year,
                                      date.month ,
                                      date.day)),
                              isDense: true,
                              fillColor: Colors.white,
                              hoverColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xffE0E0E0),
                                    width: Resizable.size(context, 0.5)),
                                borderRadius: BorderRadius.circular(
                                    Resizable.padding(context, 5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xffE0E0E0),
                                    width: Resizable.size(context, 0.5)),
                                borderRadius: BorderRadius.circular(
                                    Resizable.padding(context, 5)),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Resizable.padding(context, 5)),
                                  borderSide: BorderSide(
                                      color: const Color(0xffE0E0E0),
                                      width: Resizable.size(context, 0.5))),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}

class DateTimeCubit extends Cubit<DateTime> {
  DateTimeCubit() : super(DateTime.now());

  static DateTime startDay = DateTime.now();
  static DateTime endDay = DateTime.now();

  selectedDate(DateTime date) {
    emit(date);
  }
}


class DateTimeCubitV2 extends Cubit<DateTime> {
  DateTimeCubitV2() : super(DateTime.now());

  static DateTime day = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      DateTime.now().day);

  selectedDate(DateTime date) {
    day = date;
    emit(date);
  }
}
