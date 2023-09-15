import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_general_cubit.dart';

class FilterClassStatusMenu extends StatelessWidget {
  const FilterClassStatusMenu({super.key, required this.cubit});
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight, width: Resizable.size(context, 120),
        child: PopupMenuButton(
            onCanceled: () {
              cubit.filterClass();
            },
            itemBuilder: (context) => [
              ...cubit.listClassStatusMenu.map((e) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: BlocProvider(create: (c)=>CheckBoxFilterCubit(cubit.listStateClassStatus[cubit.listClassStatusMenu.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(e),
                      value: state,
                      onChanged: (newValue) {
                        cubit.listStateClassStatus[cubit.listClassStatusMenu.indexOf(e)] = newValue!;
                        if(cubit.listStateClassStatus.every((element) => element == false)){
                          cubit.listStateClassStatus[cubit.listClassStatusMenu.indexOf(e)] = !newValue;
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
                      child: Text(AppText.titleStatus.text,
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
