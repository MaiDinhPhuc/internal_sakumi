import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/select_filter_cubit.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_bill_cubit.dart';

class FilterBillCreatorView extends StatelessWidget {
  FilterBillCreatorView({super.key, required this.filterController, required this.cubit}): selectCubit = SelectFilterCubit();
  final SelectFilterCubit selectCubit;
  final BillFilterCubit filterController;
  final ManageBillCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectFilterCubit, int>(
        bloc: selectCubit..loadBillCreator(filterController.filter[BillFilter.creator] == null ? [FilterBillCreator.Vu, FilterBillCreator.Yen, FilterBillCreator.Phuong, FilterBillCreator.Thuy, FilterBillCreator.Tho] :filterController.filter[BillFilter.creator]!),
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
                        filterController.update(BillFilter.creator, selectCubit.convertBillCreator());
                      },
                      itemBuilder: (context) => [
                        ...selectCubit.listBillCreator.map((e) => PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: BlocProvider(create: (c)=>CheckBoxFilterCubit(selectCubit.listSelect[selectCubit.listBillCreator.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                              return CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(e.title),
                                value: state,
                                onChanged: (newValue) {
                                  selectCubit.listSelect[selectCubit.listBillCreator.indexOf(e)] = newValue!;
                                  if(selectCubit.listSelect.every((element) => element == false)){
                                    selectCubit.listSelect[selectCubit.listBillCreator.indexOf(e)] = !newValue;
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
                                child: Text(AppText.txtCreatorFilter.text,
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