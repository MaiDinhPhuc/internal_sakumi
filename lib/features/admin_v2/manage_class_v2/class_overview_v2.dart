import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'class_detail_cubit.dart';

class ClassOverViewV2 extends StatelessWidget {
  const ClassOverViewV2({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    var detailController = BlocProvider.of<ClassDetailCubit>(context);
    return ClassItemRowLayout(
        widgetClassCode: AutoSizeText(classModel.classCode.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 20))),
        widgetCourse: BlocBuilder<ClassDetailCubit, int>(builder: (c,s){
          return Text(detailController.title ??"",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 16)));
        }),
        widgetLessons: Container(),
        widgetAttendance: CircleProgress(
          title: '0%',
          lineWidth: Resizable.size(context, 3),
          percent: 0,
          radius: Resizable.size(context, 15),
          fontSize: Resizable.font(context, 14),
        ),
        widgetSubmit: CircleProgress(
          title: '0%',
          lineWidth: Resizable.size(context, 3),
          percent: 0,
          radius: Resizable.size(context, 15),
          fontSize: Resizable.font(context, 14),
        ),
        widgetEvaluate: Container(
          width: Resizable.size(context, 20),
          height: Resizable.size(context, 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
          child: Text('A',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: Resizable.font(context, 30))),
        ),
        widgetStatus: Container());
  }
}
