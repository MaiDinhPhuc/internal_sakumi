import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ManageSurveyTab extends StatelessWidget {
  const ManageSurveyTab( {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 3, classId: TextUtils.getName(), role: "admin"),
          Expanded(
              child: Center(
                child: Text("Khảo sát"),
              ))
        ],
      ),
    );
  }
}
