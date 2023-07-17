import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/chart_cubit.dart';
import 'package:internal_sakumi/features/teacher/chart_view.dart';
import 'package:internal_sakumi/features/teacher/class_overview.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/card_item.dart';

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
              firstChild: CardItem(
                  widget: ClassOverView(
                      value1: value1,
                      value2: value2,
                      classModel: classModel,
                      courseName: courseName),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=${classModel.classId}");
                  },
                  onPressed: () => BlocProvider.of<DropdownCubit>(c).update()),
              secondChild: CardItem(
                  widget: Column(
                    children: [
                      ClassOverView(
                          value1: value1,
                          value2: value2,
                          classModel: classModel,
                          courseName: courseName),
                      ChartView(classModel.classId)
                    ],
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=${classModel.classId}");
                  },
                  onPressed: () => BlocProvider.of<DropdownCubit>(c).update()),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
