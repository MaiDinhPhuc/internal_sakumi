import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_new_class.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';


class ManageGeneralListClass extends StatelessWidget {
  final ManageGeneralCubit cubit;
  const ManageGeneralListClass(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TitleWidget(AppText.titleListClass.text.toUpperCase()),
          ...(cubit.listClassNow!)
              .map(
                (e) => Row(
                  children: [
                    Container(
                      color: e.classId == cubit.selector
                          ? primaryColor
                          : Colors.transparent,
                      width: Resizable.size(context, 4),
                      margin: EdgeInsets.only(
                          right: Resizable.padding(context, 5),
                          bottom: Resizable.padding(context, 10)),
                    ),
                    Expanded(
                        child: Card(
                            margin: EdgeInsets.only(
                                right: Resizable.padding(context, 10),
                                bottom: Resizable.padding(context, 10)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 5)),
                                side: BorderSide(
                                    color: cubit.selector != e.classId
                                        ? const Color(0xffE0E0E0)
                                        : Colors.black,
                                    width: Resizable.size(context, 1))),
                            elevation: cubit.selector == e.classId
                                ? Resizable.size(context, 2)
                                : 0,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 5)),
                                onTap: (cubit.listTeacher == null ||
                                        cubit.listStudent == null)
                                    ? () {}
                                    : () {
                                        cubit.selectedClass(e.classId);
                                      },
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Resizable.padding(context, 10),
                                        horizontal:
                                            Resizable.padding(context, 15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.classCode.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Resizable.font(context, 17)),
                                        ),
                                        InkWell(
                                            borderRadius: BorderRadius.circular(
                                                Resizable.size(context, 100)),
                                            onTap: () {
                                              alertNewClass(context, true, e, cubit);
                                            },
                                            child: Image.asset(
                                                'assets/images/ic_edit.png',
                                                height:
                                                    Resizable.size(context, 20),
                                                width: Resizable.size(
                                                    context, 20)))
                                      ],
                                    )))))
                  ],
                ),
              )
              .toList(),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 10)),
              child: DottedBorderButton(
                  AppText.btnAddNewClass.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                alertNewClass(context, false, null, null);
              })),
          SizedBox(height: Resizable.size(context, 50))
        ],
      ),
    );
  }
}
