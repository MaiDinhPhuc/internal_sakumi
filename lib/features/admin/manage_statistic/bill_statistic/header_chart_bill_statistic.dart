import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'date_filter_bill.dart';
import 'detail_bill_statistic_dialog.dart';

class HeaderBillStatistic extends StatelessWidget {
  const HeaderBillStatistic({super.key, required this.filterController});
  final StatisticFilterCubit filterController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        Resizable.padding(context, 10)),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          strokeAlign:
                          BorderSide.strokeAlignOutside,
                          color: Color(0xFFE0E0E0),
                        ),
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                    ),
                    width: Resizable.size(context, 110),
                    child: DateFilterBill(
                        isStartDay: true,
                        filterController:
                        filterController)),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                      Resizable.padding(context, 5)),
                  width: 15,
                  height: 3,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        Resizable.padding(context, 10)),
                    margin: EdgeInsets.only(
                        right:
                        Resizable.padding(context, 10)),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          strokeAlign:
                          BorderSide.strokeAlignOutside,
                          color: Color(0xFFE0E0E0),
                        ),
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                    ),
                    width: Resizable.size(context, 110),
                    child: DateFilterBill(
                        isStartDay: false,
                        filterController:
                        filterController)),
                if (filterController
                    .billStatisticCubit.isChooseDate)
                  SubmitButton(
                      onPressed: () {
                        filterController.billStatisticCubit
                            .clearDate();
                        filterController.billStatisticCubit
                            .loadData(filterController);
                      },
                      title: "clear")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(right: Resizable.padding(context, 10), top: Resizable.padding(context, 5)),child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Tiền Việt(VNĐ):  ${filterController.billStatisticCubit.getSumVND()}",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 18),
                            color: primaryColor)),
                    SizedBox(height:  Resizable.padding(context, 2)),
                    Text("Yên Nhật(¥):  ${filterController.billStatisticCubit.getSumYen()}",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 18),
                            color: primaryColor))
                  ],
                )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                    width: Resizable.size(context, 80),height: Resizable.size(context, 60),child: DetailButton(
                    onPressed: () {
                      if(filterController.billStatisticCubit.loading == false){
                        showDialog(context: context, builder: (context) => DetailBillStatisticDialog(listBill: filterController.billStatisticCubit.listBill));
                      }
                    },
                    title: AppText.textDetail.text))
              ],
            )
          ],
        ));
  }
}
