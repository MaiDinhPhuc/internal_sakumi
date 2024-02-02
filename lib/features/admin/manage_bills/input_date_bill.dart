import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'bill_dialog_cubit.dart';

class InputDateBill extends StatelessWidget {
  const InputDateBill(
      {super.key, required this.billDialogCubit, required this.isPayment});
  final BillDialogCubit billDialogCubit;
  final bool isPayment;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Resizable.padding(context, 30),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 10),
            vertical: Resizable.padding(context, 5)),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE0E0E0),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
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
                      headerHeight: Resizable.size(context, 50),
                      headerStyle: DateRangePickerHeaderStyle(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 24),
                              color: Colors.black)),
                      showNavigationArrow: true,
                      onSelectionChanged: (v) {
                        if (isPayment) {
                          billDialogCubit.updatePaymentDay(v.value);
                        } else {
                          billDialogCubit.updateRenewDay(v.value);
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
                hintText: isPayment
                    ? billDialogCubit.paymentDate == null
                        ? "dd/MM/yyyy"
                        : DateFormat('dd/MM/yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                billDialogCubit.paymentDate!))
                    : billDialogCubit.renewDate == null
                        ? "dd/MM/yyyy"
                        : DateFormat('dd/MM/yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                billDialogCubit.renewDate!)),
                isDense: true,
                fillColor: Colors.white,
                hoverColor: Colors.transparent,
              ),
              maxLines: 1,
            ),
          ),
        ));
  }
}
