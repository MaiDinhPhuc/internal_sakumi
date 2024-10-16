import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CollapseProcedureClass extends StatelessWidget {
  const CollapseProcedureClass(
      {super.key, required this.itemCubit, required this.type});
  final ProcedureClassItemCubit itemCubit;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: type == "checklist" ? 10 : 30,
            child: Padding(
                padding: EdgeInsets.only(left: Resizable.padding(context, 5)),
                child: Text(
                    itemCubit.procedure == null
                        ? ""
                        : itemCubit.procedure!.title,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20))))),
        if (type == "checklist")
          Expanded(
              flex: 20,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: Resizable.padding(context, 10)),
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            animation: true,
                            lineHeight: Resizable.size(context, 6),
                            animationDuration: 2000,
                            percent: itemCubit.getPercentTotal(),
                            center: const SizedBox(),
                            barRadius: const Radius.circular(10000),
                            backgroundColor: greyColor.shade100,
                            progressColor: primaryColor,
                          ))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    child: Text(
                        '${(itemCubit.getPercentTotal() * 100).toStringAsFixed(0)} %',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 16))),
                  ),
                ],
              )),
        Expanded(flex: 1, child: Container())
      ],
    );
  }
}
