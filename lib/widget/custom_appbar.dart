import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/log_out_dialog.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CustomAppbar extends StatelessWidget {
  final List<String> buttonList;
  final int s;
  const CustomAppbar({required this.buttonList, Key? key, required this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          children: [
            Expanded(
                flex: 20,
                child: Padding(
                    padding: EdgeInsets.only(left: Resizable.padding(context, 120)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...buttonList
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
                                      if(buttonList.indexOf(e) == 0){
                                        Navigator.pushNamed(context,
                                            '${Routes.master}/manageCourse');
                                      }else{
                                        Navigator.pushNamed(context,
                                            '${Routes.master}/another');
                                      }
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
                            .toList(),
                      ],
                    )
                )),
            Expanded(
                flex: 3,
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 3),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppText.txtLogout.text,
                                style: TextStyle(
                                    color: greyColor.shade600,
                                    fontWeight:
                                    FontWeight.w700,
                                    fontSize: 16)),
                            SizedBox(
                                width: Resizable.padding(
                                    context, 5)),
                            Icon(Icons.logout , color: primaryColor.shade500,)
                          ],
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
                                primaryColor
                                    .withAlpha(30)),
                            onTap: ()  {
                              showDialog(
                                  context: context,
                                  builder: (context) => const LogOutDialog());
                            },
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(
                                  horizontal: 2),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    );
  }
}
