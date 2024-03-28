import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/choose_date_dialog.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilterStudent extends StatelessWidget {
  const DateFilterStudent(
      {super.key, required this.isStartDay, required this.filterController});
  final bool isStartDay;
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) => ChooseDateDialog(
                  type: 2,
                  dateChooseCubit: filterController.studentStatisticCubit.dateChooseCubit,
                  onSubmit: () async {
                    if (filterController.studentStatisticCubit.dateChooseCubit.startDate != null &&
                        filterController.studentStatisticCubit.dateChooseCubit.endDate != null) {
                      filterController.studentStatisticCubit.setDate(filterController.studentStatisticCubit.dateChooseCubit.startDate!,
                          filterController.studentStatisticCubit.dateChooseCubit.endDate!);
                      filterController.studentStatisticCubit.checkLoad(filterController);
                    }
                    Navigator.of(context).pop();
                  },
                  onChooseCustom: () {
                    filterController.studentStatisticCubit.dateChooseCubit.chooseCustom();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                              child: SizedBox(
                            height: Resizable.size(context, 250),
                            width: Resizable.size(context, 250),
                            child: SfDateRangePicker(
                              cancelText: AppText.textCancel.text,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onSubmit: (v) {
                                var range = v as PickerDateRange;
                                if (range.endDate != null) {
                                  filterController.studentStatisticCubit.dateChooseCubit
                                      .setDateTime(range.startDate!, range.endDate!);
                                }
                                Navigator.pop(context);
                              },
                              showActionButtons: true,
                              headerHeight: Resizable.size(context, 50),
                              headerStyle: DateRangePickerHeaderStyle(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 24),
                                      color: Colors.black)),
                              showNavigationArrow: true,
                              selectionMode: DateRangePickerSelectionMode.range,
                            ),
                          ));
                        });
                  },
                ));
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
                ? DateFormat('dd/MM/yyyy').format(DateTime(
                    filterController.studentStatisticCubit.startDay!.year,
                    filterController.studentStatisticCubit.startDay!.month,
                    filterController.studentStatisticCubit.startDay!.day))
                : DateFormat('dd/MM/yyyy').format(DateTime(
                    filterController.studentStatisticCubit.endDay!.year,
                    filterController.studentStatisticCubit.endDay!.month,
                    filterController.studentStatisticCubit.endDay!.day)),
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
