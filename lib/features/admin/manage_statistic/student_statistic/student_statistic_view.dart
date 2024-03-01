import 'package:flutter/Material.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';

class StudentStatisticView extends StatelessWidget {
  const StudentStatisticView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("hoc sinh"));
  }
}
