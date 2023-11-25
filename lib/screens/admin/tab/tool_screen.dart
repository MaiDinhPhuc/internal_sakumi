import 'package:flutter/Material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/tool/google_sign_in.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 5),
          Expanded(child: SignInDemo())
        ],
      ),
    );
  }
}