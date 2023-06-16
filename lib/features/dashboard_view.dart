import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppText.titleDashboard.text),
    );
  }
}
