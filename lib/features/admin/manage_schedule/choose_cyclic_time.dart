import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/choose_date_dialog.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'add_cyclic_schedule_cubit.dart';
import 'choose_time_dialog.dart';

class ChooseCyclicTime extends StatelessWidget {
  const ChooseCyclicTime({super.key, required this.addCubit});
  final AddCyclicScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Resizable.size(context, 275),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade300),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(Resizable.size(context, 10)),
            height: Resizable.size(context, 250),
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: greyColor.shade300),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Column(
              children: [
                ...addCubit.listDay.map((e) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                          "$e  ${addCubit.listCheckTime[addCubit.listDay.indexOf(e)]}",
                          style:
                              TextStyle(fontSize: Resizable.font(context, 20))),
                      value: addCubit.listCheckDay[addCubit.listDay.indexOf(e)],
                      onChanged: (newValue) {
                        var index = addCubit.listDay.indexOf(e);
                        addCubit.loadTime(index);
                        showDialog(
                            context: context,
                            builder: (_) => ChooseTimeDialog(
                                addCubit: addCubit, index: index));
                      },
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(Resizable.size(context, 10)),
            height: Resizable.size(context, 250),
            width: Resizable.size(context, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngày bắt đầu:",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                    SizedBox(height: Resizable.padding(context, 5)),
                    InkWell(
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
                                      cancelText: AppText.textCancel.text,
                                      onCancel: (){
                                        Navigator.pop(context);
                                      },
                                      onSubmit: (v) {
                                        var value = v as DateTime;
                                        addCubit.chooseStartDate(value);
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
                            hintText: addCubit.startDate == null
                                ? "dd/MM/yyyy"
                                : DateFormat('dd/MM/yyyy').format(DateTime(
                                addCubit.startDate!.year,
                                addCubit.startDate!.month,
                                addCubit.startDate!.day)),
                            isDense: true,
                            fillColor: Colors.white,
                            hoverColor: Colors.transparent,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: Resizable.padding(context, 5)),
                    Text(
                      "Ngày kết thúc:",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                    SizedBox(height: Resizable.padding(context, 5)),
                    InkWell(
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
                                      cancelText: AppText.textCancel.text,
                                      onCancel: (){
                                        Navigator.pop(context);
                                      },
                                      onSubmit: (v) {
                                        var value = v as DateTime;
                                        addCubit.chooseEndDate(value);
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
                            hintText: addCubit.endDate == null
                                ? "dd/MM/yyyy"
                                : DateFormat('dd/MM/yyyy').format(DateTime(
                                addCubit.endDate!.year,
                                addCubit.endDate!.month,
                                addCubit.endDate!.day)),
                            isDense: true,
                            fillColor: Colors.white,
                            hoverColor: Colors.transparent,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
