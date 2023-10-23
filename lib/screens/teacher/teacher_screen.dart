import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../utils/text_utils.dart';
import 'detail_grading_screen.dart';

class TeacherScreen extends StatelessWidget {

  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    debugPrint("=============> TeacherScreen build ");

    return BlocBuilder<AppBarInfoTeacherCubit, TeacherModel?>(
      bloc: context.read<AppBarInfoTeacherCubit>()..load(),
      builder: (context, s) {
        return Scaffold(
            body: Column(
          children: [
            Container(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Resizable.padding(context, 70),
                        right: Resizable.padding(context, 70),
                        top: Resizable.padding(context, 20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5, color: Colors.black)
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: Resizable.size(context, 25),
                                  backgroundColor: greyColor.shade300,
                                  child: s == null
                                      ? Container()
                                      : ImageNetwork(
                                          key: Key(s.url),
                                          image: s.url.isEmpty
                                              ? AppConfigs.defaultImage
                                              : s.url,
                                          height: Resizable.size(context, 50),
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          width: Resizable.size(context, 50),
                                          onLoading: Transform.scale(
                                            scale: 0.25,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                          duration: 100,
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                '${Routes.teacher}/profile');
                                          },
                                        ),
                                )),
                            SizedBox(width: Resizable.size(context, 10)),
                            s == null
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppText.txtHello.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 24)),
                                      ),
                                      Text(
                                          '${s.name} ${AppText.txtSensei.text}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                                  Resizable.font(context, 40)))
                                    ],
                                  )
                          ],
                        )
                      ],
                    ),
                  ),
                  BlocProvider(
                    create: (context) => TeacherCubit()..loadFirst(),
                    //TeacherCubit()..init(context),
                    child: BlocBuilder<TeacherCubit, int>(builder: (c, __) {
                      var cubit = BlocProvider.of<TeacherCubit>(c);
                      return cubit.data == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 150)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      alignment: Alignment.centerRight,
                                      width: Resizable.size(context, 120),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: PopupMenuButton(
                                              onCanceled: () async {
                                                await cubit.filter();
                                              },
                                              itemBuilder: (context) => [
                                                    ...listFilter.map((e) =>
                                                        PopupMenuItem(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: BlocProvider(
                                                                create: (c) => CheckBoxFilterCubit(e ==
                                                                        AppText
                                                                            .optInProgress
                                                                            .text
                                                                    ? cubit.listFilter[0]
                                                                    : cubit.listFilter[1]),
                                                                child: BlocBuilder<CheckBoxFilterCubit, bool>(builder: (cc, state) {
                                                                  return CheckboxListTile(
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .leading,
                                                                    title:
                                                                        Text(e),
                                                                    value:
                                                                        state,
                                                                    onChanged:
                                                                        (newValue) {
                                                                      cubit.listFilter[
                                                                              listFilter.indexOf(e)] =
                                                                          newValue!;
                                                                      if (cubit
                                                                          .listFilter
                                                                          .every((element) =>
                                                                              element ==
                                                                              false)) {
                                                                        cubit.listFilter[listFilter.indexOf(e)] =
                                                                            !newValue;
                                                                      } else {
                                                                        BlocProvider.of<CheckBoxFilterCubit>(cc)
                                                                            .update();
                                                                      }
                                                                    },
                                                                  );
                                                                }))))
                                                  ],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Resizable.size(
                                                          context, 10)),
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius:
                                                              Resizable.size(
                                                                  context, 2),
                                                          color: greyColor
                                                              .shade100)
                                                    ],
                                                    border: Border.all(
                                                        color:
                                                            greyColor.shade100),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                        child: Center(
                                                            child: Text(
                                                                AppText
                                                                    .txtFilter
                                                                    .text,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Resizable.font(
                                                                            context,
                                                                            18),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)))),
                                                    const Icon(Icons
                                                        .keyboard_arrow_down)
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )),
                                  ClassItemRowLayout(
                                    widgetClassCode: Text(
                                        AppText.txtClassCode.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetCourse: Text(AppText.txtCourse.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetLessons: Text(
                                        AppText.txtNumberOfLessons.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetAttendance: Text(
                                        AppText.txtRateOfAttendance.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetSubmit: Text(
                                        AppText.txtRateOfSubmitHomework.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetEvaluate: Text(
                                        AppText.txtEvaluate.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                    widgetStatus: Text(
                                        AppText.titleStatus.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            color: greyColor.shade600)),
                                  ),
                                  SizedBox(height: Resizable.size(context, 10)),
                                  (cubit.listClassIds!.isNotEmpty)
                                      ? Column(children: [
                                          ...cubit.listClassIds!
                                              .map((e) => ClassItem(
                                                  cubit.listClassIds!
                                                      .indexOf(e),
                                                  e))
                                              .toList(),
                                          SizedBox(
                                              height:
                                                  Resizable.size(context, 50))
                                        ])
                                      : Center(
                                          child: Text(AppText.txtNoClass.text),
                                        )
                                ],
                              ),
                            );
                    }),
                  )
                ],
              ),
            )),
          ],
        ));
      },
    );
  }
}

List<String> listFilter = [
  AppText.optInProgress.text,
  AppText.optComplete.text
];
