import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';

class ManageFeedBacksScreen extends StatelessWidget {
  const ManageFeedBacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 4),
          Expanded(child: Center(
            child: Text(AppText.titleManageFeedBack.text),
          ))
        ],
      ),
    );
  }
}
