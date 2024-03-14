import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'choose_date_dialog.dart';
import 'manage_bill_cubit.dart';

class DateFilter extends StatelessWidget {
  const DateFilter(
      {super.key,
      required this.cubit,
      required this.isStartDay,
      required this.filterController});
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
            builder: (context) => ChooseDateDialog(
                  type: 1,
                  dateChooseCubit: cubit.dateChooseCubit,
                  onSubmit: () async {
                    if(cubit.dateChooseCubit.startDate != null && cubit.dateChooseCubit.endDate != null){
                      cubit.setDate(cubit.dateChooseCubit.startDate!, cubit.dateChooseCubit.endDate!);
                      cubit.checkLoad(filterController);
                    }
                    Navigator.of(context).pop();
                  },
                  onChooseCustom: () {
                    cubit.dateChooseCubit.chooseCustom();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                              child: SizedBox(
                                height: Resizable.size(context, 250),
                                width: Resizable.size(context, 250),
                                child: SfDateRangePicker(
                                  cancelText: AppText.textCancel.text,
                                  onCancel: (){
                                    Navigator.pop(context);
                                  },
                                  onSubmit: (v) {
                                    String str = v.toString();
                                    int startIndex = str.indexOf("(");
                                    int endIndex = str.indexOf(")");
                                    String substring = str.substring(startIndex + 1, endIndex);
                                    List<String> sub = substring.split(",");
                                    String startDate = sub[0].split("startDate: ")[1];
                                    String endDate = sub[1].split('endDate: ')[1];
                                    if(endDate != "null"){
                                      cubit.dateChooseCubit.setDateTime(startDate, endDate);
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
                ? DateFormat('dd/MM/yyyy').format(DateTime(cubit.startDay!.year,
                    cubit.startDay!.month, cubit.startDay!.day))
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
