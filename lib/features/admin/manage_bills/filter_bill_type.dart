import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/detail_bill_statistic_cubit.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/select_filter_cubit.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_bill_cubit.dart';

class FilterBillTypeView extends StatelessWidget {
  FilterBillTypeView({super.key, required this.filterController, required this.cubit}): selectCubit = SelectFilterCubit();
  final SelectFilterCubit selectCubit;
  final BillFilterCubit filterController;
  final ManageBillCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectFilterCubit, int>(
        bloc: selectCubit..loadBillType(filterController.filter[BillFilter.type] == null ? [FilterBillType.sale1Term, FilterBillType.saleFull, FilterBillType.saleDeposit1, FilterBillType.saleDepositFull] :filterController.filter[BillFilter.type]!),
        builder: (c,s){
          return  Container(
              margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
              alignment: Alignment.centerRight, width: Resizable.size(context, 120),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Material(
                  color: Colors.transparent,
                  child: PopupMenuButton(
                      onCanceled: (){
                        filterController.update(BillFilter.type, selectCubit.convertBillType());
                      },
                      itemBuilder: (context) => [
                        ...selectCubit.listBillType.map((e) => PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: BlocProvider(create: (c)=>CheckBoxFilterCubit(selectCubit.listSelect[selectCubit.listBillType.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                              return CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(e.title),
                                value: state,
                                onChanged: (newValue) {
                                  selectCubit.listSelect[selectCubit.listBillType.indexOf(e)] = newValue!;
                                  if(selectCubit.listSelect.every((element) => element == false)){
                                    selectCubit.listSelect[selectCubit.listBillType.indexOf(e)] = !newValue;
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
                                child: Text(AppText.txtBillType.text,
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
        });
  }
}

class FilterBillTypeDetail extends StatelessWidget {
  const FilterBillTypeDetail({super.key, required this.detailCubit, });
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
                  ...detailCubit.listType.map((e) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: BlocProvider(create: (c)=>CheckBoxFilterCubit(detailCubit.types[detailCubit.listType.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(e),
                          value: state,
                          onChanged: (newValue) {
                            detailCubit.types[detailCubit.listType.indexOf(e)] = newValue!;
                            if(detailCubit.types.every((element) => element == false)){
                              detailCubit.types[detailCubit.listType.indexOf(e)] = !newValue;
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
                          child: Text(AppText.txtBillType.text,
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