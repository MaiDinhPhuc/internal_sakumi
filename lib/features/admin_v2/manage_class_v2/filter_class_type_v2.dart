import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class FilterTypeAdminV2 extends StatelessWidget {
  FilterTypeAdminV2(this.cubit,{super.key}) : selectCubit = SelectFilterCubit();
  final AdminClassFilterCubit cubit;
  final SelectFilterCubit selectCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectFilterCubit, int>(
        bloc: selectCubit..loadType(cubit.filter[AdminFilter.type]!),
        builder: (c,s){
      return Container(
          margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
          alignment: Alignment.centerRight, width: Resizable.size(context, 120),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton(
                  onCanceled: (){
                    cubit.update(AdminFilter.type, selectCubit.convertType());
                  },
                  itemBuilder: (context) => [
                    ...selectCubit.list.map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: BlocProvider(create: (c)=>CheckBoxFilterCubit(selectCubit.listSelect[selectCubit.list.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(e.title),
                            value: state,
                            onChanged: (newValue) {
                              selectCubit.listSelect[selectCubit.list.indexOf(e)] = newValue!;
                              if(selectCubit.listSelect.every((element) => element == false)){
                                selectCubit.listSelect[selectCubit.list.indexOf(e)] = !newValue;
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
                            child: Text(AppText.txtClassType.text,
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

class SelectFilterCubit extends Cubit<int>{
  SelectFilterCubit():super(0);

  List<bool> listSelect = [];
  List<FilterClassType> list = [FilterClassType.group, FilterClassType.one];

  loadType(List<dynamic> listType){
    for(var i in listType){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    while(listSelect.length != 2){
      listSelect.add(false);
    }
  }

  List<FilterClassType> convertType(){
    List<FilterClassType> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterClassType.group);
    }
    if(listSelect[1] == true){
      filter.add(FilterClassType.one);
    }
    return filter;
  }

}