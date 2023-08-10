import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin/user_item.dart';
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
              Expanded(child: BlocBuilder<ManageGeneralCubit, int>(builder: (c, s) {
                var cubit = BlocProvider.of<ManageGeneralCubit>(c);
                return s == -1
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: Resizable.padding(context, 20)),
                          child: cubit.listAllClass == null
                              ? Transform.scale(
                            scale: 0.75,
                            child:
                            const CircularProgressIndicator(),
                          )
                              : SingleChildScrollView(
                            child: Column(
                              children: [
                                TitleWidget(AppText.titleListClass.text.toUpperCase()),
                                ...(cubit.listAllClass!)
                                    .map((e) => IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Container(
                                        color: e.classId == cubit.selector ? primaryColor : Colors.transparent,
                                        width: Resizable.size(context, 4),
                                        margin: EdgeInsets.only(right: Resizable.padding(context, 5),
                                            bottom: Resizable.padding(
                                                context, 10)),
                                      ),
                                      Expanded(child: Card(
                                          margin: EdgeInsets.only(right: Resizable.padding(context, 10),
                                              bottom: Resizable.padding(
                                                  context, 10)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  Resizable.size(
                                                      context, 5)),
                                              side: BorderSide(
                                                  color: cubit.selector != e.classId
                                                      ? const Color(
                                                      0xffE0E0E0)
                                                      : Colors
                                                      .black,
                                                  width: Resizable.size(
                                                      context, 1))),
                                          elevation: cubit.selector == e.classId ? Resizable.size(context, 2) : 0,
                                          child: InkWell(
                                            onTap: (){
                                              cubit.listTeacher = null;
                                              cubit.selectedClass(e.classId, c);
                                            },
                                            borderRadius:
                                            BorderRadius.circular(
                                                Resizable.size(
                                                    context,
                                                    5)),
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: Resizable
                                                        .padding(
                                                        context,
                                                        10),
                                                    horizontal: Resizable
                                                        .padding(
                                                        context,
                                                        15)),
                                                child: Text(
                                                  e.classCode
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .w700,
                                                      fontSize:
                                                      Resizable.font(
                                                          context,
                                                          17)),
                                                )),
                                          )))
                                    ],
                                  ),
                                ))
                                    .toList(),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
                                    child: DottedBorderButton(AppText.btnAddNewClass.text.toUpperCase(), isManageGeneral: true, onPressed: ()async{})
                                ),
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.green,
                          child: SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Container(
                                      //alignment: Alignment.center,
                                      child: TitleWidget(AppText.titleListTeacher.text.toUpperCase()),
                                    )),
                                    Expanded(child: Container(//alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
                                      child: TitleWidget(AppText.titleListStudent.text.toUpperCase()),
                                    )),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffEEEEEE),
                                      borderRadius: BorderRadius.circular(Resizable.padding(context, 5))
                                  ),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: cubit.listTeacher == null ? Transform.scale(
                                        scale: 0.75,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ): cubit.listTeacher!.isEmpty ? TitleWidget(AppText.txtNoTeacher.text): Column(
                                        children: [
                                          ...(cubit.listTeacher!)
                                              .map((e) => UserItem('${e.name} ${AppText.txtSensei.text}', e.phone))
                                              .toList(),
                                          SizedBox(height: Resizable.padding(context, 5)),
                                          Material(
                                              color: Colors.transparent,
                                              child: DottedBorderButton(AppText.btnAddTeacher.text.toUpperCase(), isManageGeneral: true, onPressed: ()async{})
                                          ),
                                        ],
                                      )),
                                      SizedBox(width: Resizable.padding(context, 10)),
                                      Expanded(child: cubit.listStudent == null ? Transform.scale(
                                        scale: 0.75,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ): cubit.listStudent!.isEmpty ? TitleWidget(AppText.txtNoStudent.text): Column(
                                        children: [
                                          ...(cubit.listStudent!)
                                              .map((e) => UserItem(e.name, e.phone))
                                              .toList(),
                                          SizedBox(height: Resizable.padding(context, 5)),
                                          Material(
                                              color: Colors.transparent,
                                              child: DottedBorderButton(AppText.titleAddStudent.text.toUpperCase(), isManageGeneral: true, onPressed: ()async{})
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            ),
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
