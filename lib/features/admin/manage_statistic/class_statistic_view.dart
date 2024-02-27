import 'package:flutter/Material.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';

class ClassStatisticView extends StatelessWidget {
  const ClassStatisticView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("lop"),);
  }
}