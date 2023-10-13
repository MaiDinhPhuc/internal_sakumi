import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

import 'master/another_tab.dart';
import 'master/manage_course_tab.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomAppbar(buttonList: [
            AppText.txtManageCourse.text,
            AppText.txtAnother.text,
          ], widgets:const [
             ManageCourseTab(),
             AnotherTab()
          ]),
        ));
  }
}
