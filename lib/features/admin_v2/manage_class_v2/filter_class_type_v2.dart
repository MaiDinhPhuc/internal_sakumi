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
        bloc: selectCubit..loadType(cubit.filter[AdminFilter.type] == null ? [FilterClassType.group] :cubit.filter[AdminFilter.type]!),
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
                    cubit.update(AdminFilter.type, selectCubit.convertType());
                  },
                  itemBuilder: (context) => [
                    ...selectCubit.listType.map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: BlocProvider(create: (c)=>CheckBoxFilterCubit(selectCubit.listSelect[selectCubit.listType.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(e.title),
                            value: state,
                            onChanged: (newValue) {
                              selectCubit.listSelect[selectCubit.listType.indexOf(e)] = newValue!;
                              if(selectCubit.listSelect.every((element) => element == false)){
                                selectCubit.listSelect[selectCubit.listType.indexOf(e)] = !newValue;
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
  List<FilterClassType> listType = [FilterClassType.group, FilterClassType.one];
  List<FilterClassStatus> listStatus = [FilterClassStatus.preparing,FilterClassStatus.studying,FilterClassStatus.completed,FilterClassStatus.cancel];


  loadType(List<dynamic> list){
    for(var i in listType){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
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

  loadStatus(List<dynamic> list){
    for(var i in listStatus){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  List<FilterClassStatus> convertStatus(){
    List<FilterClassStatus> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterClassStatus.preparing);
    }
    if(listSelect[1] == true){
      filter.add(FilterClassStatus.studying);
    }
    if(listSelect[2] == true){
      filter.add(FilterClassStatus.completed);
    }
    if(listSelect[3] == true){
      filter.add(FilterClassStatus.cancel);
    }
    return filter;
  }

}