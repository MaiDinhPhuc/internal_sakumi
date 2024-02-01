import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_teacher_provider.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'class_cubit_v2.dart';

class FilterTypeAdminV2 extends StatelessWidget {
  FilterTypeAdminV2(this.cubit,{super.key, required this.classCubit}) : selectCubit = SelectFilterCubit();
  final AdminClassFilterCubit cubit;
  final SelectFilterCubit selectCubit;
  final ClassCubit classCubit;
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
                    classCubit.isLastPage = false;
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
  List<FilterClassStatus> listStatusAdmin = [FilterClassStatus.preparing,FilterClassStatus.studying,FilterClassStatus.completed,FilterClassStatus.cancel];
  List<FilterClassCourse> listCourse = [FilterClassCourse.general,FilterClassCourse.kaiwa,FilterClassCourse.jlpt,FilterClassCourse.kid];
  List<FilterClassLevel> listLevel = [FilterClassLevel.n5, FilterClassLevel.n4, FilterClassLevel.n3, FilterClassLevel.n2, FilterClassLevel.n1];
  List<FilterTeacherClassStatus> listStatusTeacher = [FilterTeacherClassStatus.preparing,FilterTeacherClassStatus.studying,FilterTeacherClassStatus.completed];

  List<FilterBillStatus> listBillStatus = [FilterBillStatus.refund, FilterBillStatus.notRefund];
  List<FilterBillType> listBillType = [FilterBillType.saleFull, FilterBillType.salePart,FilterBillType.saleFillFull, FilterBillType.upSaleFull, FilterBillType.upSalePart,FilterBillType.upSaleFillFull, FilterBillType.renewFull, FilterBillType.renewPart,  FilterBillType.renewFillFull];


  loadBillType(List<dynamic> list){
    for(var i in listBillType){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  loadBillStatus(List<dynamic> list){
    for(var i in listBillStatus){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  List<FilterBillStatus> convertBillStatus(){
    List<FilterBillStatus> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterBillStatus.refund);
    }
    if(listSelect[1] == true){
      filter.add(FilterBillStatus.notRefund);
    }
    return filter;
  }

  List<FilterBillType> convertBillType(){
    List<FilterBillType> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterBillType.saleFull);
    }
    if(listSelect[1] == true){
      filter.add(FilterBillType.salePart);
    }
    if(listSelect[2] == true){
      filter.add(FilterBillType.saleFillFull);
    }
    if(listSelect[3] == true){
      filter.add(FilterBillType.upSaleFull);
    }
    if(listSelect[4] == true){
      filter.add(FilterBillType.upSalePart);
    }
    if(listSelect[5] == true){
      filter.add(FilterBillType.upSaleFillFull);
    }
    if(listSelect[6] == true){
      filter.add(FilterBillType.renewFull);
    }
    if(listSelect[7] == true){
      filter.add(FilterBillType.renewPart);
    }
    if(listSelect[8] == true){
      filter.add(FilterBillType.renewFillFull);
    }
    return filter;
  }



  loadLevel(List<dynamic> list){
    for(var i in listLevel){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  loadCourse(List<dynamic> list){
    for(var i in listCourse){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

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

  List<FilterClassLevel> convertLevel(){
    List<FilterClassLevel> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterClassLevel.n5);
    }
    if(listSelect[1] == true){
      filter.add(FilterClassLevel.n4);
    }
    if(listSelect[2] == true){
      filter.add(FilterClassLevel.n3);
    }
    if(listSelect[3] == true){
      filter.add(FilterClassLevel.n2);
    }
    if(listSelect[4] == true){
      filter.add(FilterClassLevel.n1);
    }
    return filter;
  }

  List<FilterClassCourse> convertCourse(){
    List<FilterClassCourse> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterClassCourse.general);
    }
    if(listSelect[1] == true){
      filter.add(FilterClassCourse.kaiwa);
    }
    if(listSelect[2] == true){
      filter.add(FilterClassCourse.jlpt);
    }
    if(listSelect[3] == true){
      filter.add(FilterClassCourse.kid);
    }
    return filter;
  }

  loadStatusAdmin(List<dynamic> list){
    for(var i in listStatusAdmin){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  loadStatusTeacher(List<dynamic> list){
    for(var i in listStatusTeacher){
      if(list.contains(i)){
        listSelect.add(true);
      }else{
        listSelect.add(false);
      }
    }
    emit(state+1);
  }

  List<FilterClassStatus> convertStatusAdmin(){
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

  List<FilterTeacherClassStatus> convertStatusTeacher(){
    List<FilterTeacherClassStatus> filter = [];
    if(listSelect[0] == true){
      filter.add(FilterTeacherClassStatus.preparing);
    }
    if(listSelect[1] == true){
      filter.add(FilterTeacherClassStatus.studying);
    }
    if(listSelect[2] == true){
      filter.add(FilterTeacherClassStatus.completed);
    }
    return filter;
  }

}