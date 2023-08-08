import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/screens/teacher/class_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CustomAppbar extends StatelessWidget {
  final List<String> buttonList;
  final List<Widget> widgets;
  const CustomAppbar({required this.buttonList, required this.widgets, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TabCubit(), child: BlocBuilder<TabCubit, int>(
      builder: (c, s) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                bottom: Resizable.padding(context, 10),
                left: Resizable.padding(context, 100),
                right: Resizable.padding(context, 100),
                top: Resizable.padding(context, 10)),

            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(0, Resizable.size(context, 1)), color: Colors.grey, blurRadius: Resizable.size(context, 0))
            ]),
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttonList
                    .map((e) => Container(
                  height: Resizable.size(context, 25),
                  margin:
                  EdgeInsets.symmetric(horizontal: Resizable.padding(context, 3)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 10)),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e,
                                style: TextStyle(
                                    color: s == buttonList.indexOf(e) ? Colors.black : const Color(0xff757575),
                                    fontWeight: FontWeight.w900,
                                    fontSize: Resizable.font(context, 16))),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: s == buttonList.indexOf(e)
                              ? primaryColor
                              : Colors.transparent,
                          margin: EdgeInsets.only(
                              left: Resizable.padding(context, 10),
                              right: Resizable.padding(context, 10),
                              top: Resizable.padding(context, 19),
                              bottom: Resizable.padding(context, 5)
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                            BorderRadius.circular(100),
                            overlayColor:
                            MaterialStateProperty.all(
                                primaryColor.withAlpha(30)),
                            onTap: (){
                              BlocProvider.of<TabCubit>(c).changeTab(buttonList.indexOf(e));
                            },
                            child: Container(
                              margin:
                              EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 2)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
                    .toList()),
          ),
          Expanded(child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 0),
              child: widgets[s]
          )),
        ],
      )
    ));
  }
}

class TabCubit extends Cubit<int> {
  TabCubit() : super(0);

  changeTab(int tab) {
    emit(tab);
  }
}