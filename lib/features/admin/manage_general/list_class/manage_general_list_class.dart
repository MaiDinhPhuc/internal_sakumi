import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_new_class.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'alert_confirm_change_class_status.dart';

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
              .map((e) => IntrinsicHeight(
                    child: Row(
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 18,
                                        child: InkWell(
                                          onTap: (cubit.listTeacher == null ||
                                                  cubit.listStudent == null)
                                              ? () {}
                                              : () {
                                                  cubit.selectedClass(
                                                      e.classId, context);
                                                },
                                          borderRadius: BorderRadius.circular(
                                              Resizable.size(context, 5)),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Resizable.padding(
                                                      context, 10),
                                                  horizontal: Resizable.padding(
                                                      context, 15)),
                                              child: Text(
                                                e.classCode.toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Resizable.font(
                                                        context, 17)),
                                              )),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: PopupMenuButton(
                                          padding: EdgeInsets.zero,
                                            itemBuilder: (context) => [
                                                  ...cubit.listAllClassStatusMenu.map(
                                                      (ee) => PopupMenuItem(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          child: BlocProvider(
                                                              create: (c) =>
                                                                  CheckBoxFilterCubit(
                                                                      ee == e.classStatus),
                                                              child: BlocBuilder<
                                                                      CheckBoxFilterCubit,
                                                                      bool>(
                                                                  builder: (cc,
                                                                      state) {
                                                                return InkWell(
                                                                  onTap: (){
                                                                    Navigator.pop(context);
                                                                    if(ee != e.classStatus){
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => ConfirmChangeClassStatus(e, ee, cubit));
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                      height: Resizable.size(
                                                                          context, 33),
                                                                      decoration: BoxDecoration(
                                                                          color: state? primaryColor: Colors.white
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: Resizable.padding(
                                                                            context, 10)),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(ee, style: TextStyle(fontSize: Resizable.font(
                                                                                context, 15),color:state? Colors.white : Colors.black)),
                                                                            if(state)
                                                                              const Icon(Icons.check, color: Colors.white,)
                                                                          ],
                                                                        ),
                                                                      )
                                                                  ),
                                                                );
                                                              }))))
                                                ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(Resizable.size(
                                                    context, 10)),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Resizable.padding(
                                                      context, 5)),
                                              child:
                                                  const Icon(Icons.more_horiz),
                                            )))
                                  ],
                                )))
                      ],
                    ),
                  ))
              .toList(),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 10)),
              child: DottedBorderButton(
                  AppText.btnAddNewClass.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                alertNewClass(context);
              })),
          SizedBox(height: Resizable.size(context, 50))
        ],
      ),
    );
  }
}
