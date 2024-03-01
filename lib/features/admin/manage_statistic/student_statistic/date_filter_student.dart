import 'package:flutter/Material.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilterStudent extends StatelessWidget {
  const DateFilterStudent({super.key, required this.isStartDay, required this.filterController});
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
                          filterController.studentStatisticCubit.updateStartDay(v.value);
                        } else {
                          filterController.studentStatisticCubit.updateEndDay(v.value);
                        }
                        filterController.studentStatisticCubit.checkLoad(filterController);
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
                ? filterController.studentStatisticCubit.startDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(
                filterController.studentStatisticCubit.startDay!.year,
                filterController.studentStatisticCubit.startDay!.month,
                filterController.studentStatisticCubit.startDay!.day))
                : filterController.studentStatisticCubit.endDay == null
                ? "dd/MM/yyyy"
                : DateFormat('dd/MM/yyyy').format(DateTime(filterController.studentStatisticCubit.endDay!.year,
                filterController.studentStatisticCubit.endDay!.month, filterController.studentStatisticCubit.endDay!.day)),
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