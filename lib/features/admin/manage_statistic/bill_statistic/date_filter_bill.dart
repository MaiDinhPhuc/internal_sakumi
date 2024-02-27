import 'package:flutter/Material.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilterBill extends StatelessWidget {
  const DateFilterBill({super.key, required this.isStartDay, required this.filterController});
  final bool isStartDay;
  final StatisticFilterCubit filterController;
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
                      onSelectionChanged: (v) async {
                        if (isStartDay) {
                          filterController.billStatisticCubit.updateStartDay(v.value);
                        } else {
                          filterController.billStatisticCubit.updateEndDay(v.value);
                        }
                        filterController.billStatisticCubit.checkLoad(filterController);
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
                ? filterController.billStatisticCubit.startDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(
                filterController.billStatisticCubit.startDay!.year,
                filterController.billStatisticCubit.startDay!.month,
                filterController.billStatisticCubit.startDay!.day))
                : filterController.billStatisticCubit.endDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(filterController.billStatisticCubit.endDay!.year,
                filterController.billStatisticCubit.endDay!.month, filterController.billStatisticCubit.endDay!.day)),
            isDense: true,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}