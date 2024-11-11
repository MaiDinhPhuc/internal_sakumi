import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/procedure_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_procedure_class.dart';
import 'expand_procedure_class.dart';

class ProcedureClassItem extends StatelessWidget {
  const ProcedureClassItem(
      {super.key,
      required this.cubit,
      required this.procedureClassModel,
      required this.role, required this.type});
  final ProcedureClassCubit cubit;
  final ProcedureClassModel procedureClassModel;
  final String role;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(procedureClassModel.id.toString()),
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DropdownCubit()),
            BlocProvider(
                create: (context) =>
                    ProcedureClassItemCubit(procedureClassModel)..init())
          ],
          child: BlocBuilder<DropdownCubit, int>(
            builder: (c, state) {
              return BlocBuilder<ProcedureClassItemCubit, int>(
                  builder: (cc, ss) {
                var itemCubit = BlocProvider.of<ProcedureClassItemCubit>(cc);
                return Stack(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 15),
                            vertical: Resizable.padding(context, 8)),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Resizable.size(context, 1),
                                color: state % 2 == 0
                                    ? greyColor.shade100
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5))),
                        child: AnimatedCrossFade(
                            firstChild: CollapseProcedureClass(
                              itemCubit: itemCubit,
                              type: type,
                            ),
                            secondChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CollapseProcedureClass(
                                  itemCubit: itemCubit,
                                  type: type,
                                ),
                                ExpandProcedureClass(
                                  cubit: cubit,
                                  itemCubit: itemCubit,
                                  role: role,
                                )
                              ],
                            ),
                            crossFadeState: state % 2 == 1
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 100))),
                    Container(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 10),
                          top: Resizable.padding(context, 2)),
                      child: Row(
                        children: [
                          Expanded(flex: 10, child: Container()),
                          Expanded(flex: 20, child: Container()),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<DropdownCubit>(c).update();
                                  },
                                  splashRadius: Resizable.size(context, 15),
                                  icon: Icon(
                                    state % 2 == 0
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                  )))
                        ],
                      ),
                    )
                  ],
                );
              });
            },
          )),
    );
  }
}
