import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_bill_statistic_cubit.dart';

class FilterBillCurrencyDetail extends StatelessWidget {
  const FilterBillCurrencyDetail({super.key, required this.detailCubit, });
  final DetailBillStatisticCubit detailCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
        alignment: Alignment.centerRight, width: Resizable.size(context, 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton(
                onCanceled: (){
                  detailCubit.update();
                },
                itemBuilder: (context) => [
                  ...detailCubit.listCurrency.map((e) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: BlocProvider(create: (c)=>CheckBoxFilterCubit(detailCubit.currency[detailCubit.listCurrency.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(e),
                          value: state,
                          onChanged: (newValue) {
                            detailCubit.currency[detailCubit.listCurrency.indexOf(e)] = newValue!;
                            if(detailCubit.currency.every((element) => element == false)){
                              detailCubit.currency[detailCubit.listCurrency.indexOf(e)] = !newValue;
                            }else{
                              BlocProvider.of<CheckBoxFilterCubit>(cc).update();
                            }
                          },
                        );
                      }))
                  ))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Resizable.size(context, 10)),
                    )
                ),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: Resizable.size(context, 2),
                            color: greyColor.shade100)
                      ],
                      border: Border.all(
                          color: greyColor.shade100),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: Center(
                          child: Text(AppText.txtCurrency.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 18),
                                  fontWeight: FontWeight.w500))
                      )),
                      const Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}