import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/student_statistic_chart.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/student_statistic_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/total_student_view.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'header_student_statistic.dart';

class StudentStatisticView extends StatelessWidget {
  const StudentStatisticView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentStatisticCubit, int>(
        bloc: filterController.studentStatisticCubit..loadData(filterController),
        builder: (c, s) {
          return Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TotalStudentView(filterController: filterController)),
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
                            child: HeaderStudentStatistic(
                                filterController: filterController)),
                        Expanded(
                            flex: 5,
                            child: StudentStatisticChart(
                                studentStatisticCubit:
                                filterController.studentStatisticCubit))
                      ],
                    ),
                  ))
            ],
          );
        });
  }
}
