import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/header_teacher.dart';

import '../../utils/text_utils.dart';

class ClassTestScreen extends StatelessWidget {
  const ClassTestScreen(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
            index: 2,
            classId: TextUtils.getName(position: 2),
            name: name,
          ),
          Text("test")
        ],
      ),
    );
  }
}
