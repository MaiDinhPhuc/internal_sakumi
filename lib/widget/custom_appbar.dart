import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile/log_out_dialog.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/functions.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class MasterAppbar extends StatelessWidget {
  final int s;

  const MasterAppbar({Key? key, required this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonList = [
      AppText.txtManageCourse.text,
      AppText.txtStudentSurvey.text,
      AppText.txtTeacherSurvey.text,
      AppText.titleManageFeedBack.text,
      AppText.txtManageBanner.text,
      AppText.txtManageCourseSuggest.text,
    ];
    return Container(
      padding: EdgeInsets.only(
          bottom: Resizable.padding(context, 10),
          top: Resizable.padding(context, 10)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, Resizable.size(context, 1)),
            color: Colors.grey,
            blurRadius: Resizable.size(context, 0))
      ]),
      alignment: Alignment.center,
      child: Row(children: [
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 3)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 10)),
                                    child: Text(e,
                                        style: TextStyle(
                                            color: s == buttonList.indexOf(e)
                                                ? Colors.black
                                                : const Color(0xff757575),
                                            fontWeight: FontWeight.w900,
                                            fontSize:
                                                Resizable.font(context, 16))),
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
                                          bottom:
                                              Resizable.padding(context, 5)),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        overlayColor: WidgetStateProperty.all(
                                            primaryColor.withAlpha(30)),
                                        onTap: () async{
                                          switch (buttonList.indexOf(e)) {
                                            case 0:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageCourse',
                                                  context);
                                              break;
                                            case 1:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageStudentSurvey',
                                                  context);
                                              break;
                                            case 2:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageTeacherSurvey',
                                                  context);
                                              break;
                                            case 3:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageTeacherFeedBack',
                                                  context);
                                            case 4:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageBanner',
                                                  context);
                                            case 5:
                                              await Functions.goPage(
                                                  '${Routes.master}/manageCourseSuggest',
                                                  context);
                                              break;
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 2)),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ],
                ))),
        Container(
          height: 30,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: Resizable.padding(context, 10)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppText.txtLogout.text,
                        style: TextStyle(
                            color: greyColor.shade600,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    SizedBox(width: Resizable.padding(context, 5)),
                    Icon(
                      Icons.logout,
                      color: primaryColor.shade500,
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    overlayColor:
                        WidgetStateProperty.all(primaryColor.withAlpha(30)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => const LogOutDialog());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
