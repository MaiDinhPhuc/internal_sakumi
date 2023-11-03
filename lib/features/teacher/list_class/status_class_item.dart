import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_confirm_change_class_status.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StatusClassItemAdmin extends StatelessWidget {
  const StatusClassItemAdmin({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoadListClassCubit>(context);
    return BlocProvider(
      create: (context) => MenuPopupCubit(),
      child: BlocBuilder<MenuPopupCubit, int>(
        builder: (c, s) {
          var popupCubit = BlocProvider.of<MenuPopupCubit>(c);
          return PopupMenuButton(
              itemBuilder: (context) => [
                    ...cubit.listClassStatusMenu.map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: BlocProvider(
                            create: (context) => CheckBoxFilterCubit(
                                cubit.listClassStatus![index] == e),
                            child: BlocBuilder<CheckBoxFilterCubit, bool>(
                                builder: (c, state) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (cubit.listClassStatus![index] != e) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ConfirmChangeClassStatus(
                                                e,
                                                cubit.listClassStatus![index],
                                                cubit.listClassCodes![index],
                                                cubit.listClassIds![index],
                                                cubit.listCourseIds![index],
                                                popupCubit,
                                                cubit,
                                                index));
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
                              text: vietnameseSubText(
                                  cubit.listClassStatus![index]),
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
                          color: cubit.getColor(cubit.listClassStatus![index]),
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
                      child: Image.asset(
                          'assets/images/ic_${cubit.getIcon(cubit.listClassStatus![index])}.png'),
                    ),
                  )));
        },
      ),
    );
  }
}
