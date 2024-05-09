import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/class_tag_list_view.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/list_manage_tags_cubit.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/student_tag_list_view.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/teacher_tag_list_view.dart';
import 'package:internal_sakumi/model/manage_tag_model.dart';

import '../../../../configs/color_configs.dart';
import '../../../../utils/resizable.dart';

class TagFilterPart2 extends StatelessWidget {
  const TagFilterPart2({super.key});

  @override
  Widget build(BuildContext context) {
    final tagFilterCubit = context.watch<TagFilterCubit>();
    var list = [
      AppText.txtTeacher.text,
      AppText.txtStudent.text,
      AppText.txtClass.text
    ];
    return BlocProvider(
      create: (context) => ListManageTagsCubit()..load(),
      child: BlocBuilder<ListManageTagsCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final cubit = context.read<ListManageTagsCubit>();
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                SizedBox(
                    height: Resizable.size(context, 50),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                              decoration: BoxDecoration(
                                color: greyAccent,
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 1000)),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 10),
                                horizontal: Resizable.padding(context, 15),
                              ).copyWith(right: 0),
                              child: TabBar(
                                  isScrollable: false,
                                  physics: const ClampingScrollPhysics(),
                                  indicatorPadding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 0),
                                  indicator: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 100)),
                                  ),
                                  unselectedLabelColor: darkPrimaryColor,
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    return states
                                            .contains(MaterialState.focused)
                                        ? null
                                        : Colors.transparent;
                                  }),
                                  labelColor: Colors.black,
                                  unselectedLabelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: darkPrimaryColor,
                                      fontSize: Resizable.font(context, 20)),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)),
                                  tabs: list
                                      .map((e) => Tab(
                                            text: e[0].toUpperCase() +
                                                e.substring(1).toLowerCase(),
                                          ))
                                      .toList())),
                        ),
                        Expanded(flex: 2, child: Container())
                      ],
                    )),
                Divider(
                  color: grey2,
                  endIndent: Resizable.padding(context, 15),
                  indent: Resizable.padding(context, 15),
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    Builder(builder: (context) {
                      var list = cubit.listManageTags
                          .where((element) => element.type == 1)
                          .toList();
                      if (tagFilterCubit.listFilterTags.isNotEmpty) {
                        list.removeWhere(
                          (element) => !containsAny(
                              element.tags.map((e) => e as int).toList(),
                              tagFilterCubit.listFilterTags
                                  .map((e) => e.id)
                                  .toList()),
                        );
                      }

                      if (list.isEmpty) {
                        return emptyText(context);
                      }
                      return TeacherTagListView(list: list, listTags: cubit.listTags,);
                    }),
                    Builder(builder: (context) {
                      var list = cubit.listManageTags
                          .where((element) => element.type == 2)
                          .toList();
                      if (tagFilterCubit.listFilterTags.isNotEmpty) {
                        list.removeWhere(
                          (element) => !containsAny(
                              element.tags.map((e) => e as int).toList(),
                              tagFilterCubit.listFilterTags
                                  .map((e) => e.id)
                                  .toList()),
                        );
                      }
                      if (list.isEmpty) {
                        return emptyText(context);
                      }
                      return StudentTagListView(list: list , listTags: cubit.listTags,);
                    }),
                    Builder(builder: (context) {
                      var list = cubit.listManageTags
                          .where((element) => element.type == 3)
                          .toList();
                      if (tagFilterCubit.listFilterTags.isNotEmpty) {
                        list.removeWhere(
                          (element) => !containsAny(
                              element.tags.map((e) => e as int).toList(),
                              tagFilterCubit.listFilterTags
                                  .map((e) => e.id)
                                  .toList()),
                        );
                      }
                      if (list.isEmpty) {
                        return emptyText(context);
                      }
                      return ClassTagListView(list: list, listTags: cubit.listTags,);
                    }),
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget emptyText(BuildContext context) {
    return Center(
      child: Text('Danh sách trống',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 20))),
    );
  }

  bool containsAny(List<int> list, List<int> items) {
    for (var item in items) {
      if (list.contains(item)) {
        return true;
      }
    }
    return false;
  }
}
