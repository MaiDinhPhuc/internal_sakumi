import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/teacher/tab/list_lesson_tab.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class PersistentTabs extends StatelessWidget {
  const PersistentTabs(
      {required this.screenWidgets, this.currentTabIndex = 0, Key? key})
      : super(key: key);
  final int currentTabIndex;
  final List<Widget> screenWidgets;

  List<Widget> _buildOffstageWidgets() {
    return screenWidgets
        .map(
          (w) => Offstage(
            offstage: currentTabIndex != screenWidgets.indexOf(w),
            child: Navigator(
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (_) => w);
              },
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(),
    );
  }
}

// DEMO
class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  //late int currentTabIndex;
  @override
  // void initState() {
  //   super.initState();
  //   currentTabIndex = 2;
  // }
  //
  // void setCurrentIndex(int val) {
  //   setState(() {
  //     currentTabIndex = val;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TabCubit(),
        child: BlocBuilder<TabCubit, int>(
          builder: (c, s) => DefaultTabController(
            initialIndex: s,
            length: 2,
            child: Scaffold(
              body: Column(
                children: [
                  Card(
                      shadowColor: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: Row(
                        children: [
                          ...List.generate(
                              2,
                              (index) => Container(
                                    margin: EdgeInsets.only(
                                        right: Resizable.padding(context, 20)),
                                    child: InkWell(
                                      onTap: () => BlocProvider.of<TabCubit>(c)
                                          .changeTab(index),
                                      child: Text('Tab $index'),
                                    ),
                                  )).toList()
                        ],
                      )),
                  Expanded(
                      child: PersistentTabs(
                    currentTabIndex: s,
                    screenWidgets: [
                      Column(
                        children: [
                          Text('ahihi'),
                          //TextButton(onPressed: () => Navigator.pushNamed(context, Routes.master), child: Text('Press'))
                        ],
                      ),
                      //Text('ahahah')

                      //ClassOverViewTab('name'),
                      //ListLessonTab('name', '0'),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
