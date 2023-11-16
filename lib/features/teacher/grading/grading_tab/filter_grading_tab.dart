import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../detail_grading_view.dart';
import '../drop_down_grading_widget.dart';
import 'grading_cubit.dart';

class FilterGradingTab extends StatelessWidget {
  const FilterGradingTab({super.key, required this.cubit});
  final GradingCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(
        context, 80), vertical: Resizable.padding(
        context, 10)),child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            flex:25,
            child: Container()),
        Expanded(
            flex:4,
            child: BlocProvider(
              create: (context) => DropdownGradingCubit(AppText.titleHomework.text),
              child: BlocBuilder<DropdownGradingCubit, String>(
                builder: (cc, state) {
                  return DropDownGrading(
                      items: [
                        AppText.titleHomework.text,
                        AppText.txtTest.text,
                      ],
                      onChanged: (item) {
                        if(item == AppText.titleHomework.text){
                          cubit.isBTVN = true;
                        }else if(item == AppText.txtTest.text){
                          cubit.isBTVN = false;
                        }
                        BlocProvider.of<DropdownGradingCubit>(cc)
                            .change(item!);
                        cubit.update();
                      },
                      value: state);
                },
              ),
            )),
        Expanded(
            flex:1,
            child: Container()),
        Expanded(
            flex:4,
            child: BlocProvider(
              create: (context) => DropdownGradingCubit(AppText.textNotMarked.text),
              child: BlocBuilder<DropdownGradingCubit, String>(
                builder: (ccc, ss) {
                  return DropDownGrading(
                      items: [
                        AppText.textNotMarked.text,
                        AppText.textMarked.text,
                      ],
                      onChanged: (item) {
                        if(item == AppText.textNotMarked.text){
                          cubit.isNotGrading = true;
                        }else if(item == AppText.textMarked.text){
                          cubit.isNotGrading = false;
                        }

                        BlocProvider.of<DropdownGradingCubit>(ccc)
                            .change(item!);
                        cubit.update();
                      },
                      value: ss);
                },
              ),
            ))
      ],
    ));
  }
}
