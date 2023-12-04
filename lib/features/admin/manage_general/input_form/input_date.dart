import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InputDate extends StatelessWidget {
  final String title;
  final bool isStartDate;
  final String? errorText;
  late bool isisVoucher;
  final Function? onPressed;
  InputDate(
      {required this.title,
      this.isStartDate = true,
      this.errorText,
      this.isisVoucher = false, this.onPressed,
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
                                      date.month + (isisVoucher ? 3 : 0),
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
