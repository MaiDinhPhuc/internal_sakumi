import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/dashboard_view.dart';
import 'package:internal_sakumi/features/list_class_view.dart';
import 'package:internal_sakumi/features/list_student_view.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppText.titleAdmin.text),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.profile),
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: Resizable.size(context, 20)),
              TabBar(
                splashBorderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5)),
                isScrollable: false,
                indicator: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Resizable.padding(context, 5)),
                  color: primaryColor,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 150)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    child: Text(AppText.titleManageStudent.text),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    child: Text(AppText.titleManageClass.text),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    child: Text(AppText.titleDashboard.text),
                  )
                ],
              ),
              Expanded(
                  child: TabBarView(children: [
                ListStudentView(),
                ListClassView(),
                const DashboardView()
              ]))
            ],
          ),
          // body: SafeArea(
          //     child: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       TextButton(
          //           onPressed: () {
          //             Navigator.pushNamed(context, Routes.adding,
          //                 arguments: {'title': AppText.titleManageStudent.text});
          //           },
          //           child: Text(AppText.titleManageStudent.text)),
          //       TextButton(
          //           onPressed: () {
          //             Navigator.pushNamed(context, Routes.classes,
          //                 arguments: {'title': AppText.titleManageClass.text});
          //           },
          //           child: Text(AppText.titleManageClass.text)),
          //     ],
          //   ),
          // ))
        ));
  }
}
