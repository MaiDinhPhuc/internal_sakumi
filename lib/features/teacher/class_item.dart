import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/chart_cubit.dart';
import 'package:internal_sakumi/features/teacher/chart_view.dart';
import 'package:internal_sakumi/features/teacher/class_overview.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ClassItem extends StatelessWidget {
  final double value1, value2;
  final String courseName;
  final ClassModel classModel;
  const ClassItem(
      {required this.value1,
      required this.value2,
      required this.classModel,
      required this.courseName,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownCubit(),
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      constraints: BoxConstraints(
                          maxHeight: Resizable.size(context, 40)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20),
                          vertical: Resizable.padding(context, 8)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: Resizable.size(context, 1.5),
                              color: greyColor.shade100),
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 5))),
                      child: ClassOverView(value1: value1, value2: value2, classModel: classModel, courseName: courseName)),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=${classModel.classId}");
                      },
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(right: Resizable.size(context, 70)),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () =>
                            BlocProvider.of<DropdownCubit>(c).update(),
                        splashRadius: Resizable.size(context, 15),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        )),
                  )
                ],
              ),
              secondChild: Stack(
                //alignment: Alignment.center,
                children: [
                  Container(
                    // constraints:
                    //     BoxConstraints(maxHeight: Resizable.size(context, 40)),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20),
                        vertical: Resizable.padding(context, 8)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(context, 1.5),
                            color: greyColor.shade100),
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                    child: Column(
                      children: [
                        ClassOverView(value1: value1, value2: value2, classModel: classModel, courseName: courseName),
                        ChartView(classModel.classId)
                      ],
                    ),
                  ),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=${classModel.classId}");
                      },
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        right: Resizable.padding(context, 70),
                        top: Resizable.padding(context, 6)),
                    // padding: EdgeInsets.symmetric(
                    //     vertical: Resizable.padding(context, 5)),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () =>
                            BlocProvider.of<DropdownCubit>(c).update(),
                        splashRadius: Resizable.size(context, 15),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        )),
                  )
                ],
              ),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
