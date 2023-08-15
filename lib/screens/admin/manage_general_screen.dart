import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/manage_general_list_class.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_list_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/user_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

class ManageGeneralScreen extends StatelessWidget {
  const ManageGeneralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ManageGeneralCubit()..loadAllClass(context),
        child: Scaffold(
            body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
          child: Column(
            children: [
              SizedBox(height: Resizable.size(context, 50)),
              Expanded(
                  child: BlocBuilder<ManageGeneralCubit, int>(builder: (c, s) {
                var cubit = BlocProvider.of<ManageGeneralCubit>(c);
                return s == -1
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Resizable.padding(context, 20)),
                                child: cubit.listAllClass == null
                                    ? Transform.scale(
                                        scale: 0.75,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : ManageGeneralListClass(cubit),
                              )),
                          Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: TitleWidget(AppText
                                              .titleListTeacher.text
                                              .toUpperCase()),
                                        )),
                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: TitleWidget(AppText
                                              .titleListStudent.text
                                              .toUpperCase()),
                                        )),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 10)),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffEEEEEE),
                                          borderRadius: BorderRadius.circular(
                                              Resizable.padding(context, 5))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: cubit.listTeacher == null
                                                  ? Transform.scale(
                                                      scale: 0.75,
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        ...(cubit.listTeacher!)
                                                            .map((e) => UserItem(
                                                                '${e.name} ${AppText.txtSensei.text}',
                                                                e.phone))
                                                            .toList(),
                                                        SizedBox(
                                                            height: Resizable
                                                                .padding(
                                                                    context,
                                                                    5)),
                                                        Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: DottedBorderButton(
                                                                AppText
                                                                    .btnAddTeacher
                                                                    .text
                                                                    .toUpperCase(),
                                                                isManageGeneral:
                                                                    true,
                                                                onPressed: () {

                                                            })),
                                                      ],
                                                    )),
                                          SizedBox(
                                              width: Resizable.padding(
                                                  context, 10)),
                                          Expanded(
                                              child: cubit.listStudent == null
                                                  ? Transform.scale(
                                                      scale: 0.75,
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    )
                                                  : ManageGeneralListStudent(cubit)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      );
              }))
            ],
          ),
        )));
  }
}
