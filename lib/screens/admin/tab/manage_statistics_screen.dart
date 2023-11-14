import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';

class ManageStatisticsScreen extends StatelessWidget {
  const ManageStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 3),
          Expanded(child: Center(
            child: Text(AppText.titleStatistics.text),
          ))
        ],
      ),
    );
  }
}
