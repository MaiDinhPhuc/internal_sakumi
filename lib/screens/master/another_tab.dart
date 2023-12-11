import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class AnotherTab extends StatelessWidget {
  const AnotherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtAnother.text,
          ], s: 1),
          const Expanded(child: Center(
            child: Text("another tab"),
          ))
        ],
      ),
    );
  }
}
