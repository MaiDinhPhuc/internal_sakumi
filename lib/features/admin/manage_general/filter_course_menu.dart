import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_general_cubit.dart';

class FilterCourseMenu extends StatelessWidget {
  const FilterCourseMenu({super.key, required this.cubit});
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
        alignment: Alignment.centerRight, width: Resizable.size(context, 120),
        child: PopupMenuButton(
            onCanceled: (){
              cubit.filterClass();
            },
            itemBuilder: (context) => [
              ...cubit.listAllCourse!.map((e) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: BlocProvider(create: (c)=>CheckBoxFilterCubit(cubit.listStateCourse[cubit.listAllCourse!.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("${e.title} - ${e.termName}"),
                      value: state,
                      onChanged: (newValue) {
                        cubit.listStateCourse[cubit.listAllCourse!.indexOf(e)] = newValue!;
                        if(cubit.listStateCourse.every((element) => element == false)){
                          cubit.listStateCourse[cubit.listAllCourse!.indexOf(e)] = !newValue;
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
              ),
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
                      child: Text(AppText.txtCourse.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 18),
                              fontWeight: FontWeight.w500))
                  )),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            )
        )
    );
  }
}
