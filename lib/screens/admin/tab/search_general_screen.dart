import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/search/drop_down_search.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_view.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/features/admin/search/search_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../configs/color_configs.dart';
import '../../../features/admin/search/item_search.dart';
import '../../../services/custom_firebase_firestore.dart';

class SearchGeneralScreen extends StatelessWidget {
  SearchGeneralScreen({Key? key})
      : controller = TextEditingController(),
        super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var searchCubit = BlocProvider.of<SearchCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 0),
          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 150)
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 20)),
                          child: Text(AppText.titleSearchGeneral.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: Resizable.font(context, 30),
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        BlocBuilder<SearchCubit, int>(
                            bloc: searchCubit,
                            builder: (c, s) {
                              return Column(
                                children: [
                                  DropDownSearchField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                          autofocus: true,
                                          cursorColor: Colors.black,
                                          style: TextStyle(
                                              fontSize: Resizable.font(context, 25),
                                              color: Colors.black),
                                          onChanged: (String value) {
                                            searchCubit.updateSearchValue(value);
                                          },
                                          controller: controller,
                                          decoration: InputDecoration(
                                            fillColor:Colors.white,
                                            filled: true,
                                            hintText: AppText.txtSearch.text,
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: Resizable.font(context, 20),
                                                color: const Color(0xFF461220)
                                                    .withOpacity(0.5)),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Resizable.padding(context, 20),
                                            ),
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    Resizable.size(context, 40)),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            prefixIcon: IntrinsicHeight(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        Resizable.font(context, 200),
                                                    child: DropDownSearch(
                                                        items: [
                                                          AppText.txtClass.text,
                                                          AppText.txtStudent.text,
                                                          AppText.txtTeacher.text
                                                        ],

                                                        onChanged: (value) {
                                                          searchCubit
                                                              .changeType(value);
                                                          searchCubit
                                                              .updateSearchValue("");
                                                          controller.text = "";
                                                        },
                                                        value: searchCubit.type),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: Resizable.padding(
                                                            context, 10),
                                                        top: Resizable.padding(
                                                            context, 8),
                                                        bottom: Resizable.padding(
                                                            context, 8)),
                                                    width: Resizable.size(context, 1),
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                                tooltip: AppText.txtSearch.text,
                                                onPressed: null,
                                                splashColor: Colors.transparent,
                                                icon: const Icon(
                                                  Icons.search,
                                                  color: Colors.black,
                                                )),
                                          )),
                                      suggestionsCallback: (pattern) async {
                                        return (await CustomFirebaseFireStore.database
                                                .collection(searchCubit.typeQuery)
                                                .get())
                                            .docs;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        var data = suggestion.data();
                                        if (searchCubit.searchValue.isEmpty) {
                                          return Container();
                                        }
                                        if (searchCubit.type ==
                                            AppText.txtClass.text) {
                                          if (data["class_code"]
                                                  .toString()
                                                  .toUpperCase()
                                                  .contains(searchCubit.searchValue
                                                      .toUpperCase()) &&
                                              data["is_sub_class"] == false) {
                                            return ItemSearch(
                                              type: searchCubit.type,
                                              isLast: false,
                                              classStatus: data["class_status"],
                                              code: data["class_code"] ?? "",
                                              classType: data["class_type"] ?? 0,
                                              id: data["class_id"],
                                            );
                                          }
                                        }

                                        if (searchCubit.type ==
                                            AppText.txtStudent.text) {
                                          if (data["name"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase()) ||
                                              data["student_code"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase()) ||
                                              data["email"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase())) {
                                            return ItemSearch(
                                              type: searchCubit.type,
                                              isLast: false,
                                              url: data["url"] ?? "",
                                              name: data["name"] ?? "",
                                              code: data["student_code"] ?? "",
                                              id: data["user_id"],
                                              email: data["email"],
                                            );
                                          }
                                        }

                                        if (searchCubit.type ==
                                            AppText.txtTeacher.text) {
                                          if (data["name"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase()) ||
                                              data["teacher_code"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase()) ||
                                              data["email"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchCubit.searchValue
                                                      .toLowerCase())) {
                                            return ItemSearch(
                                              type: searchCubit.type,
                                              isLast: false,
                                              url: data["url"] ?? "",
                                              name: data["name"] ?? "",
                                              code: data["teacher_code"] ?? "",
                                              id: data["user_id"],
                                              email: data["email"],
                                            );
                                          }
                                        }

                                        return Container();
                                      },
                                      onSuggestionSelected: (suggestion) {},
                                      displayAllSuggestionWhenTap: true,

                                      suggestionsBoxDecoration:
                                          SuggestionsBoxDecoration(


                                            offsetX: Resizable.font(context, 200),
                                            constraints: BoxConstraints(
                                              maxWidth: constraints.maxWidth - Resizable.font(context, 200),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(color: Colors.black),
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                      ),
                                      hideOnLoading: true,
                                      hideOnEmpty: true,

                                  ),

                                ],
                              );
                            }),
                        SizedBox(height: Resizable.padding(context, 20),),
                        const Expanded(child: TagFilterView()),
                        SizedBox(height: Resizable.padding(context, 20),),
                      ],
                    );
                  }
                ),
              ))
        ],
      ),
    );
  }
}
