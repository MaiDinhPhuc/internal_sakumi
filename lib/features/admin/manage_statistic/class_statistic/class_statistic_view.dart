import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/class_statistic/total_class_view.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'chart_class_statistic.dart';
import 'class_statistic_cubit.dart';
import 'header_class_statistic.dart';

class ClassStatisticView extends StatelessWidget {
  const ClassStatisticView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassStatisticCubit, int>(
        bloc: filterController.classStatisticCubit,
        builder: (c, s) {
          return Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TotalClassView(filterController: filterController)),
              Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: const Color(0xffE0E0E0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: HeaderClassStatistic(
                                filterController: filterController)),
                        Expanded(
                            flex: 5,
                            child: ClassStatisticChart(
                                classStatisticCubit:
                                    filterController.classStatisticCubit))
                      ],
                    ),
                  ))
            ],
          );
        });
  }
}
