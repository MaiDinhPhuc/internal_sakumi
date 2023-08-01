import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/class_appbar.dart';

import '../../../utils/text_utils.dart';

class ClassOverViewTab extends StatelessWidget {
  const ClassOverViewTab(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
            index: 0,
            classId: TextUtils.getName(position: 2),
            name: name,
          ),
          Text("OverView")
        ],
      ),
    );
  }
}
