import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_confirm_change_class_status.dart';

class StatusClassItemAdmin extends StatelessWidget {
  const StatusClassItemAdmin(
      {super.key,
      required this.color,
      required this.icon,
      required this.dataCubit,
      required this.classModel});
  final Color color;
  final String icon;
  final DataCubit dataCubit;
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (c, s) {
          var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
          return PopupMenuButton(
              itemBuilder: (context) => [
                    ...dataCubit.listClassStatusMenuAdmin2.map((e) =>
                        PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: BlocProvider(
                                create: (context) => CheckBoxFilterCubit(
                                    classModel.classStatus == e),
                                child: BlocBuilder<CheckBoxFilterCubit, bool>(
                                    builder: (c, state) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (classModel.classStatus != e) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ConfirmChangeClassStatus(
                                                    e,
                                                    classModel,
                                                    popupCubit,
                                                    dataCubit));
                                      }
                                    },
                                    child: Container(
                                        height: Resizable.size(context, 33),
                                        decoration: BoxDecoration(
                                            color: state
                                                ? primaryColor
                                                : Colors.white),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(vietnameseSubText(e),
                                                  style: TextStyle(
                                                      fontSize: Resizable.font(
                                                          context, 15),
                                                      color: state
                                                          ? Colors.white
                                                          : Colors.black)),
                                              if (state)
                                                const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                            ],
                                          ),
                                        )),
                                  );
                                }))))
                  ],
              child: Tooltip(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                          color: Colors.black,
                          width: Resizable.size(context, 1)),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  richMessage: WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: vietnameseSubText(classModel.classStatus),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      height: Resizable.size(context, 20),
                      width: Resizable.size(context, 20),
                      padding: EdgeInsets.all(Resizable.padding(context, 10)),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BlocProvider.of<DropdownCubit>(context).state %
                                          2 ==
                                      0
                                  ? BorderRadius.horizontal(
                                      left: Radius.circular(
                                          Resizable.padding(context, 5)))
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(
                                          Resizable.padding(context, 5)))),
                      child: Image.asset('assets/images/ic_$icon.png'),
                    ),
                  )));
        },
      ),
    );
  }
}

class StatusClassItemAdminV2 extends StatelessWidget {
  const StatusClassItemAdminV2(
      {super.key,
        required this.color,
        required this.icon,
        required this.classModel});
  final Color color;
  final String icon;
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (c, s) {
          var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
          return Tooltip(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                      color: Colors.black,
                      width: Resizable.size(context, 1)),
                  borderRadius:
                  BorderRadius.circular(Resizable.size(context, 5))),
              richMessage: WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: vietnameseSubText(classModel.classStatus),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  height: Resizable.size(context, 20),
                  width: Resizable.size(context, 20),
                  padding: EdgeInsets.all(Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                      BlocProvider.of<DropdownCubit>(context).state %
                          2 ==
                          0
                          ? BorderRadius.horizontal(
                          left: Radius.circular(
                              Resizable.padding(context, 5)))
                          : BorderRadius.only(
                          topLeft: Radius.circular(
                              Resizable.padding(context, 5)))),
                  child: Image.asset('assets/images/ic_$icon.png'),
                ),
              ));
        },
      ),
    );
  }
}