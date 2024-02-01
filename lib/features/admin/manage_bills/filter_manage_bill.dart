import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'date_filter.dart';
import 'filter_bill_status.dart';
import 'filter_bill_type.dart';
import 'manage_bill_cubit.dart';

class FilterManageBill extends StatelessWidget {
  const FilterManageBill({super.key, required this.cubit, required this.filterController});
  final ManageBillCubit cubit;
  final BillFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
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
                child: DateFilter(cubit: cubit, isStartDay: true, filterController: filterController)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),
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
                padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
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
                child: DateFilter(cubit: cubit, isStartDay: false,filterController: filterController)),
            if(cubit.startDay != null && cubit.endDay != null)
              SubmitButton(onPressed: (){
                cubit.clearDate();
                cubit.loadData(filterController);
              }, title: "clear")
          ],
        ),
        BlocListener<BillFilterCubit, int>(
            listener: (context, _) {
              cubit.loadData(filterController);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.size(context, 5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilterBillTypeView(filterController: filterController, cubit: cubit),
                  FilterBillStatusView(filterController: filterController, cubit: cubit)
                ],
              ),
            )),
      ],
    );
  }
}
