import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_cubit_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/confirm_change_class_status_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StatusClassItemV2 extends StatelessWidget {
  const StatusClassItemV2(
      {super.key,
      required this.color,
      required this.icon,
      required this.classModel,
      required this.classCubit});
  final Color color;
  final String icon;
  final ClassModel classModel;
  final ClassCubit classCubit;

  @override
  Widget build(BuildContext context) {
    return classCubit.role! == "admin"? BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (c, s) {
          var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
          return PopupMenuButton(
              itemBuilder: (context) => [
                    ...classCubit.listClassStatusMenuAdmin2.map((e) =>
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
                                                ConfirmChangeClassStatusV2(
                                                    e, classModel, popupCubit,
                                                    classCubit: classCubit));
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
    ): Tooltip(
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
  }
}
