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
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/teacher_profile/app_bar_info_teacher_cubit.dart';
import 'home_teacher_button.dart';
import 'teacher_appbar_item.dart';

class HeaderTeacher extends StatelessWidget {
  final int index;
  final String classId, role;

  const HeaderTeacher(
      {Key? key,
      required this.index,
      required this.classId,
      required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarInfoTeacherCubit, TeacherModel?>(builder: (c, s) {
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
                        (index == -1 || role == "admin") && role != "teacher"
                            ? const CustomBackHomeButton()
                            : const TeacherHomeButton(),
                        Expanded(child: Container()),
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                ...(index == -1
                                        ? []
                                        : role == "teacher"
                                            ? buttonTeacherList
                                            : buttonAdminList)
                                    .map((e) => AppBarTeacherItem(
                                          title: e.button,
                                          role: role,
                                          color: index == e.id
                                              ? primaryColor
                                              : Colors.transparent,
                                          id: e.id,
                                          classId: classId,
                                        ))
                                    .toList()
                              ],
                            ))
                      ]),
                )),
            if (role == "teacher")
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: s == null
                          ? const Align(
                              alignment: Alignment.centerRight,
                              child: CircularProgressIndicator())
                          : AutoSizeText('${s.name} ${AppText.txtSensei.text}',
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 36))),
                    ),
                    SizedBox(
                      width: Resizable.padding(context, 10),
                    ),
                    s == null
                        ? CircleAvatar(
                            radius: Resizable.size(context, 15),
                            backgroundColor: greyColor.shade300,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(blurRadius: 5, color: Colors.black)
                              ],
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
                                  var profileUri = '${Routes.teacher}/profile';
                                  if (classId != "empty") {
                                    Navigator.pushNamed(context, profileUri);
                                  }
                                },
                              ),
                            )),
                  ],
                ),
              )
          ],
        ),
      );
    });
  }
}

List<NavigationModel> buttonTeacherList = [
  NavigationModel(0, AppText.titleOverView.text),
  NavigationModel(1, AppText.titleLesson.text),
  NavigationModel(2, AppText.titleMultiChoice.text),
  NavigationModel(3, AppText.titleGrading.text)
];
List<NavigationModel> buttonAdminList = [
  NavigationModel(0, AppText.titleOverView.text),
  NavigationModel(1, AppText.titleLesson.text),
  NavigationModel(2, AppText.titleMultiChoice.text),
  NavigationModel(3, AppText.txtSurvey.text),
];

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  load(context) async {
    emit(await getName());
  }
}

Future<String?> getName() async {
  SharedPreferences localData = await SharedPreferences.getInstance();
  return localData.getString(PrefKeyConfigs.name);
}
