
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'date_filter_class.dart';
import 'detail_class_statistic_dialog.dart';

class HeaderClassStatistic extends StatelessWidget {
  const HeaderClassStatistic({super.key, required this.filterController});
  final StatisticFilterCubit filterController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 15)),
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
                    child: DateFilterClass(
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
                    child: DateFilterClass(
                        isStartDay: false,
                        filterController:
                        filterController)),
                if (filterController
                    .classStatisticCubit.isChooseDate)
                  SubmitButton(
                      onPressed: () {
                        filterController.classStatisticCubit
                            .clearDate();
                        filterController.classStatisticCubit
                            .loadData(filterController);
                      },
                      title: "clear")
              ],
            ),
            SizedBox(width: Resizable.size(context, 80),height: Resizable.size(context, 60),child: DetailButton(
                onPressed: () {
                  if(filterController.classStatisticCubit.loading == false){
                    showDialog(context: context, builder: (context) => DetailClassStatisticDialog(filterController: filterController));
                  }
                },
                title: AppText.textDetail.text))
          ],
        ));
  }
}