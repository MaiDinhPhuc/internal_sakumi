import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/tool/google_sign_in.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AdminAppBar(index: 5),
          Expanded(child: SignInDemo())
        ],
      ),
    );
  }
}