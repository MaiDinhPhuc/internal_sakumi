import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

import 'advise_item.dart';
import 'manage_advise_cubit.dart';

class ListAdvise extends StatelessWidget {
  const ListAdvise({super.key, required this.cubit});
  final ManageAdviseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return cubit.getAdvise().isEmpty
        ? Center(
      child: Text(AppText.txtAdviseEmpty.text),
    )
        : Column(
      children: [
        ...cubit
            .getAdvise()
            .map((e) => AdviseItem(advise: e, cubit: cubit))
      ],
    );
  }
}
