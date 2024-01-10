
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'class_overview_cubit_v2.dart';
import 'confirm_change_student_class_status_v2.dart';

class IconToolTipV2 extends StatelessWidget {
  const IconToolTipV2(
      {super.key,
        required this.role,
        required this.cubit,
        required this.stdClass});
  final String role;
  final ClassOverViewCubitV2 cubit;
  final StudentClassModel stdClass;
  @override
  Widget build(BuildContext context) {
    return role == "admin"
        ? BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (c, s) {
          var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
          return PopupMenuButton(
            itemBuilder: (context) => [
              ...cubit.listStudentStatusMenu.map((e) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: BlocProvider(
                      create: (context) =>
                          CheckBoxFilterCubit(stdClass.status == e),
                      child: BlocBuilder<CheckBoxFilterCubit, bool>(
                          builder: (c, state) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (stdClass.status != e) {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ConfirmChangeStudentClassStatusV2(
                                            e,
                                            stdClass,
                                            cubit.students!.firstWhere((e) =>
                                            e.userId == stdClass.userId),
                                            popupCubit, cubit: cubit,
                                          ));
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
                                        horizontal:
                                        Resizable.padding(context, 10)),
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
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.black,
                        width: Resizable.size(context, 1)),
                    borderRadius: BorderRadius.circular(
                        Resizable.padding(context, 5))),
                richMessage: WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: vietnameseSubText(stdClass.status),
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
                    padding:
                    EdgeInsets.all(Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        color: stdClass.color,
                        borderRadius:
                        BlocProvider.of<DropdownCubit>(context)
                            .state %
                            2 ==
                            0
                            ? BorderRadius.horizontal(
                            left: Radius.circular(
                                Resizable.padding(context, 5)))
                            : BorderRadius.only(
                            topLeft: Radius.circular(
                                Resizable.padding(context, 5)))),
                    child: Image.asset(
                        'assets/images/ic_${stdClass.icon}.png'),
                  ),
                )),
          );
        },
      ),
    )
        : Tooltip(
        padding: EdgeInsets.all(Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
                color: Colors.black, width: Resizable.size(context, 1)),
            borderRadius:
            BorderRadius.circular(Resizable.padding(context, 5))),
        richMessage: WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: vietnameseSubText(stdClass.status),
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
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            decoration: BoxDecoration(
                color: stdClass.color,
                borderRadius:
                BlocProvider.of<DropdownCubit>(context).state % 2 == 0
                    ? BorderRadius.horizontal(
                    left: Radius.circular(
                        Resizable.padding(context, 5)))
                    : BorderRadius.only(
                    topLeft: Radius.circular(
                        Resizable.padding(context, 5)))),
            child: Image.asset('assets/images/ic_${stdClass.icon}.png'),
          ),
        ));
  }
}