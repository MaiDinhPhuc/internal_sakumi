import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/header_teacher.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ClassGradingScreen extends StatelessWidget {
  const ClassGradingScreen(this.name,{super.key});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 3, classId: TextUtils.getName(position: 2), name: name),
          Text("grading")
        ],
      ),
    );
  }
}
