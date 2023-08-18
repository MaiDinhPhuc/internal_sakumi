import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/navigation/navigation.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderTeacher extends StatelessWidget {
  final NameCubit cubit;
  final int index;
  final String classId, name;
  HeaderTeacher(
      {Key? key,
      required this.index,
      required this.classId,
      required this.name})
      : cubit = NameCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: cubit..load(context),
        builder: (c, s) => Container(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  left: Resizable.padding(context, 100),
                  right: Resizable.padding(context, 100),
                  top: Resizable.padding(context, 10)),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Card(
                  //   shape: const CircleBorder(),
                  //   elevation: Resizable.size(context, 2),
                  //   child: InkWell(
                  //     borderRadius: BorderRadius.circular(10000),
                  //     //child: Image.asset('assets/images/img_sakumi.png', scale: 5),
                  //     //   child: Padding(
                  //     //     padding: EdgeInsets.all(Resizable.padding(context, 7)),
                  //     //     child: Image.asset('assets/images/img_logo.png', scale: 40)
                  //     //   ),
                  //     child: Padding(
                  //       padding: EdgeInsets.all(Resizable.padding(context, 7)),
                  //       child: const Icon(Icons.home),
                  //     ),
                  //     onTap: ()async{
                  //       SharedPreferences localData = await SharedPreferences.getInstance();
                  //       String name = localData.getString(PrefKeyConfigs.code).toString();
                  //       debugPrint('================> test $name');
                  //       if(context.mounted) {
                  //         Navigator.pushReplacementNamed(
                  //           context, "teacher?name=${name.trim()}");
                  //       }
                  //     },
                  //   ),
                  // ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: const CircleBorder(),
                            elevation: Resizable.size(context, 2),
                            margin: EdgeInsets.only(right: Resizable.padding(context, 30)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10000),
                              //child: Image.asset('assets/images/img_sakumi.png', scale: 5),
                              //   child: Padding(
                              //     padding: EdgeInsets.all(Resizable.padding(context, 7)),
                              //     child: Image.asset('assets/images/img_logo.png', scale: 40)
                              //   ),
                              child: Padding(
                                padding: EdgeInsets.all(Resizable.padding(context, 7)),
                                child: const Icon(Icons.home),
                              ),
                              onTap: ()async{
                                SharedPreferences localData = await SharedPreferences.getInstance();
                                String name = localData.getString(PrefKeyConfigs.code).toString();
                                debugPrint('================> test $name');
                                if(context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, "teacher?name=${name.trim()}");
                                }
                              },
                            ),
                          ),
                          ...buttonList
                              .map((e) => Container(
                            height: 30,
                            margin:
                            const EdgeInsets.symmetric(horizontal: 3),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.button.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: index == e.id
                                        ? primaryColor
                                        : Colors.transparent,
                                    margin: const EdgeInsets.only(
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
                                      BorderRadius.circular(100),
                                      overlayColor:
                                      MaterialStateProperty.all(
                                          primaryColor.withAlpha(30)),
                                      onTap: () async {
                                        switch (e.id) {
                                          case 0:
                                            debugPrint(
                                                "========${e.button}======");
                                            await Navigator.pushNamed(
                                                context,
                                                "${Routes.teacher}?name=$name/overview/class?id=$classId");
                                            break;
                                          case 1:
                                            debugPrint(
                                                "========${e.button}======");
                                            await Navigator.pushNamed(
                                                context,
                                                "${Routes.teacher}?name=$name/lesson/class?id=$classId");
                                            break;
                                          case 2:
                                            debugPrint(
                                                "========${e.button}======");
                                            await Navigator.pushNamed(
                                                context,
                                                "${Routes.teacher}?name=$name/test/class?id=$classId");
                                            break;
                                          case 3:
                                            debugPrint(
                                                "========${e.button}======");
                                            await Navigator.pushNamed(
                                                context,
                                                "${Routes.teacher}?name=$name/grading/class?id=$classId");
                                            break;
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
                          ))
                              .toList()
                        ]),
                  )),
                  Row(
                    children: [
                      s == null
                          ? const CircularProgressIndicator()
                          : Text('$s ${AppText.txtSensei.text}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 40))),
                      SizedBox(width: Resizable.padding(context, 10)),
                      CircleAvatar(
                        radius: Resizable.size(context, 15),
                        backgroundColor: greyColor.shade300,
                      ),
                    ],
                  )
                ],
              ),
            ));
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
