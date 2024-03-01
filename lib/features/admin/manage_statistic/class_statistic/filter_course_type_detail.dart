
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_class_statistic_cubit.dart';

class FilterCourseTypeDetail extends StatelessWidget {
  const FilterCourseTypeDetail(this.cubit, {super.key});
  final DetailClassStatisticCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
        EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
        alignment: Alignment.centerRight,
        width: Resizable.size(context, 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton(
                onCanceled: () {
                  cubit.update();
                },
                itemBuilder: (context) => [
                  ...cubit.listType.map((e) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: BlocProvider(
                          create: (c) => CheckBoxFilterCubit(
                              cubit.type[cubit.listType.indexOf(e)]),
                          child: BlocBuilder<CheckBoxFilterCubit, bool>(
                              builder: (cc, state) {
                                return CheckboxListTile(
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  title: Text(e),
                                  value: state,
                                  onChanged: (newValue) {
                                    cubit.type[cubit.listType.indexOf(e)] =
                                    newValue!;
                                    if (cubit.type
                                        .every((element) => element == false)) {
                                      cubit.type[cubit.listType.indexOf(e)] =
                                      !newValue;
                                    } else {
                                      BlocProvider.of<CheckBoxFilterCubit>(cc)
                                          .update();
                                    }
                                  },
                                );
                              }))))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Resizable.size(context, 10)),
                    )),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: Resizable.size(context, 2),
                            color: greyColor.shade100)
                      ],
                      border: Border.all(color: greyColor.shade100),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(AppText.txtCourse.text,
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 18),
                                      fontWeight: FontWeight.w500)))),
                      const Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                )),
          ),
        ));
  }
}