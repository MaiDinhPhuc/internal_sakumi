import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/search/drop_down_search.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/features/admin/search/search_field.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SearchGeneralScreen extends StatelessWidget {
  SearchGeneralScreen({Key? key})
      : searchTextController = TextEditingController(),
        super(key: key);
  final TextEditingController searchTextController;
  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 0),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 150)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 40)),
                  child: Text(AppText.titleSearchGeneral.text.toUpperCase(),
                      style: TextStyle(
                        fontSize: Resizable.font(context, 30),
                        fontWeight: FontWeight.w800,
                      )),
                ),
                BlocBuilder<SearchCubit, int>(
                    bloc: dataController.searchCubit,
                    builder: (c, s) {
                      return Column(
                        children: [
                          SearchField(
                            AppText.txtSearch.text,
                            txt: searchTextController,
                            suffixIcon: IconButton(
                                tooltip: AppText.txtSearch.text,
                                onPressed: () {
                                  dataController.searchCubit
                                      .search(searchTextController.text);
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                )),
                            widget: SizedBox(
                              width: Resizable.font(context, 200),
                              child: DropDownSearch(
                                  items: [
                                    AppText.txtClass.text,
                                    AppText.txtStudent.text,
                                    AppText.txtTeacher.text
                                  ],
                                  onChanged: (value) {
                                    dataController.searchCubit
                                        .changeType(value);
                                    searchTextController.text = "";
                                  },
                                  value: dataController.searchCubit.type),
                            ),
                            onChanged: (String value) {
                              dataController.searchCubit.search(value);
                            },
                          ),
                          ItemSearchList(
                            searchCubit: dataController.searchCubit,
                            type: dataController.searchCubit.type,
                            text: searchTextController.text,
                          )
                        ],
                      );
                    })
              ],
            ),
          ))
        ],
      ),
    );
  }
}
