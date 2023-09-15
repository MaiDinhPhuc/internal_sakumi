import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/navigation/navigation.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'teacher/profile/app_bar_info_teacher_cubit.dart';

class HeaderTeacher extends StatelessWidget {
  final int index;
  final String classId, name;

  const HeaderTeacher(
      {Key? key,
      required this.index,
      required this.classId,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarInfoTeacherCubit, TeacherModel?>(
        builder: (c, s) {
          return Container(
            padding: EdgeInsets.only(
                bottom: Resizable.padding(context, 10),
                left: Resizable.padding(context, 100),
                right: Resizable.padding(context, 100),
                top: Resizable.padding(context, 10)),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: index == -1
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            index == -1
                                ? const CustomBackButton()
                                : Container(
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
                                              Image.asset(
                                                  'assets/images/ic_home.png',
                                                  scale: 60),
                                              SizedBox(
                                                  width: Resizable.padding(
                                                      context, 5)),
                                              Text(AppText.titleHome.text,
                                                  style: TextStyle(
                                                      color: greyColor.shade600,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16)),
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
                                              onTap: () async {
                                                SharedPreferences localData =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String name = localData
                                                    .getString(
                                                        PrefKeyConfigs.code)
                                                    .toString();
                                                debugPrint(
                                                    '================> test $name');
                                                if (context.mounted) {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      "${Routes.teacher}?name=$name");
                                                }
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
                                  ),
                            Expanded(child: Container()),
                            Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    ...(index == -1 ? [] : buttonList)
                                        .map((e) => Container(
                                              height: 30,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(e.button,
                                                            style: TextStyle(
                                                                color: greyColor
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Container(
                                                      color: index == e.id
                                                          ? primaryColor
                                                          : Colors.transparent,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 25,
                                                              bottom: 3,
                                                              left: 10,
                                                              right: 10),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .all(primaryColor
                                                                    .withAlpha(
                                                                        30)),
                                                        onTap: () async {
                                                          switch (e.id) {
                                                            case 0:
                                                              debugPrint(
                                                                  "========${e.button}======");
                                                              await Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      "${Routes.teacher}?name=$name/overview/class?id=$classId");
                                                              break;
                                                            case 1:
                                                              debugPrint(
                                                                  "========${e.button}======");
                                                              await Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      "${Routes.teacher}?name=$name/lesson/class?id=$classId");
                                                              break;
                                                            case 2:
                                                              debugPrint(
                                                                  "========${e.button}======");
                                                              await Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      "${Routes.teacher}?name=$name/test/class?id=$classId");
                                                              break;
                                                            case 3:
                                                              debugPrint(
                                                                  "========${e.button}======");
                                                              await Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      "${Routes.teacher}?name=$name/grading/class?id=$classId");
                                                              break;
                                                          }
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      2),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        .toList()
                                  ],
                                ))
                          ]),
                    )),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     Expanded(child:  s == null
                         ?  const Align(
                       alignment: Alignment.centerRight,
                         child: CircularProgressIndicator())
                         : AutoSizeText('${s.name} ${AppText.txtSensei.text}',
                         maxLines: 1,
                         textAlign: TextAlign.right,
                         style: TextStyle(
                             fontWeight: FontWeight.w800,
                             fontSize: Resizable.font(context, 40))),),
                      SizedBox(width: Resizable.padding(context, 10),),
                      s == null
                          ? CircleAvatar(
                              radius: Resizable.size(context, 15),
                              backgroundColor: greyColor.shade300,
                            )
                          : Container(
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black)],
                        ),
                        child: CircleAvatar(
                          radius: Resizable.size(context, 15),
                          backgroundColor: greyColor.shade300,
                          child: ImageNetwork(
                            key: Key(s.url),
                            image: s.url.isEmpty
                                ? AppConfigs.defaultImage
                                : s.url,
                            height: Resizable.size(context, 30),
                            borderRadius: BorderRadius.circular(1000),
                            width: Resizable.size(context, 30),
                            onLoading: Transform.scale(
                              scale: 0.25,
                              child: const CircularProgressIndicator(),
                            ),
                            duration: 0,
                            onTap: () {
                              var uri =
                              Uri.dataFromString(window.location.href)
                                  .toString();
                              var profileUri =
                                  '${Routes.teacher}?name=$name/profile';
                              if (uri.contains(profileUri)) {
                                Navigator.pushReplacementNamed(
                                    context, profileUri);
                              } else {
                                Navigator.pushNamed(context, profileUri);
                              }
                            },
                          ),
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

List<NavigationModel> buttonList = [
  NavigationModel(0, AppText.titleOverView.text),
  NavigationModel(1, AppText.titleLesson.text),
  NavigationModel(2, AppText.titleMultiChoice.text),
  NavigationModel(3, AppText.titleGrading.text)
];

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  load(context) async {
    var userRepo = UserRepository.fromContext(context);
    emit(await userRepo.getName());
  }
}
