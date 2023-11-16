import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class FilterByLevel extends StatelessWidget {
  const FilterByLevel(this.cubit,{Key? key}) : super(key: key);
  final DataCubit cubit;
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
                  cubit.filterInAdmin();
                },
                itemBuilder: (context) => [
                  ...cubit.listLevelMenu.map((e) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: BlocProvider(create: (c)=>CheckBoxFilterCubit(cubit.levelFilter[cubit.listLevelMenu.indexOf(e)]),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (cc,state){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(e),
                          value: state,
                          onChanged: (newValue) {
                            cubit.levelFilter[cubit.listLevelMenu.indexOf(e)] = newValue!;
                            BlocProvider.of<CheckBoxFilterCubit>(cc).update();
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
                          child: Text(AppText.txtLevel.text,
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
