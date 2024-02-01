import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'manage_bill_cubit.dart';

class DateFilter extends StatelessWidget {
  const DateFilter({super.key, required this.cubit, required this.isStartDay});
  final ManageBillCubit cubit;
  final bool isStartDay;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () async {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                  child: SizedBox(
                    height: Resizable.size(context, 250),
                    width: Resizable.size(context, 250),
                    child: SfDateRangePicker(
                      headerHeight: Resizable.size(context, 50),
                      headerStyle: DateRangePickerHeaderStyle(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 24),
                              color: Colors.black)),
                      showNavigationArrow: true,
                      onSelectionChanged: (v) {
                        if (isStartDay) {
                          cubit.updateStartDay(v.value);
                        } else {
                          cubit.updateEndDay(v.value);
                        }
                        Navigator.pop(context);
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                  ));
            });
      },
      child: IgnorePointer(
        child: TextFormField(
          style: TextStyle(
              fontSize: Resizable.font(context, 18),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: const Icon(Icons.calendar_month_outlined),
            hintText: isStartDay
                ? cubit.startDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(
                cubit.startDay!.year,
                cubit.startDay!.month,
                cubit.startDay!.day))
                : cubit.endDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(cubit.endDay!.year,
                cubit.endDay!.month, cubit.endDay!.day)),
            isDense: true,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       color: const Color(0xffE0E0E0),
            //       width: Resizable.size(context, 0.5)),
            //   borderRadius:
            //   BorderRadius.circular(Resizable.padding(context, 50)),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       color: const Color(0xffE0E0E0),
            //       width: Resizable.size(context, 0.5)),
            //   borderRadius:
            //   BorderRadius.circular(Resizable.padding(context, 50)),
            // ),
            // border: OutlineInputBorder(
            //     borderRadius:
            //     BorderRadius.circular(Resizable.padding(context, 50)),
            //     borderSide: BorderSide(
            //         color: const Color(0xFFE0E0E0),
            //         width: Resizable.size(context, 0.5))),
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
