import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilterReport extends StatelessWidget {
  const DateFilterReport({super.key, required this.cubit});
  final TeacherReportCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 10)),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Color(0xFFE0E0E0),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            width: Resizable.size(context, 110),
            child: InkWell(
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
                              onSubmit: (v) async {
                                String str = v.toString();
                                int startIndex = str.indexOf("(");
                                int endIndex = str.indexOf(")");
                                String substring = str.substring(startIndex + 1, endIndex);
                                List<String> sub = substring.split(",");
                                String startDate = sub[0].split("startDate: ")[1];
                                String endDate = sub[1].split('endDate: ')[1];
                                if(endDate != "null"){
                                  await cubit.setDateTime(startDate, endDate);
                                  Navigator.pop(context);
                                }
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
              child: IgnorePointer(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: Resizable.font(context, 18),
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(Icons.calendar_month_outlined),
                    hintText: DateFormat('dd/MM/yyyy').format(DateTime(
                        cubit.startDate!.year,
                        cubit.startDate!.month,
                        cubit.startDate!.day)),
                    isDense: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.transparent,
                  ),
                  maxLines: 1,
                ),
              ),
            )),
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),
          width: 15,
          height: 3,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 10)),
            margin: EdgeInsets.only(right: Resizable.padding(context, 10)),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Color(0xFFE0E0E0),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            width: Resizable.size(context, 110),
            child: InkWell(
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
                              onSubmit: (v) async {
                                String str = v.toString();
                                int startIndex = str.indexOf("(");
                                int endIndex = str.indexOf(")");
                                String substring = str.substring(startIndex + 1, endIndex);
                                List<String> sub = substring.split(",");
                                String startDate = sub[0].split("startDate: ")[1];
                                String endDate = sub[1].split('endDate: ')[1];
                                if(endDate != "null"){
                                  await cubit.setDateTime(startDate, endDate);
                                  Navigator.pop(context);
                                }
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
              child: IgnorePointer(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: Resizable.font(context, 18),
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(Icons.calendar_month_outlined),
                    hintText: DateFormat('dd/MM/yyyy').format(DateTime(
                        cubit.endDate!.year,
                        cubit.endDate!.month,
                        cubit.endDate!.day)),
                    isDense: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.transparent,
                  ),
                  maxLines: 1,
                ),
              ),
            )),
        if (cubit.changeDate)
          SubmitButton(
              onPressed: () {
                cubit.clearDate();
              },
              title: "clear")
      ],
    );
  }
}
