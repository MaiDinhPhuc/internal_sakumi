import 'package:flutter/Material.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'manage_bill_cubit.dart';

class DateFilter extends StatelessWidget {
  const DateFilter({super.key, required this.cubit, required this.isStartDay, required this.filterController});
  final ManageBillCubit cubit;
  final bool isStartDay;
  final BillFilterCubit filterController;
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
                        cubit.checkLoad(filterController);
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
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}


