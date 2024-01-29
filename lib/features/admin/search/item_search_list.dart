import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'item_search.dart';

class ItemSearchList extends StatelessWidget {
  const ItemSearchList(
      {super.key, required this.searchCubit, required this.snapshots});
  final SearchCubit searchCubit;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshots;
  @override
  Widget build(BuildContext context) {
    return searchCubit.searchValue == ""
        ? Container()
        : Container(
            constraints: BoxConstraints(
              maxHeight: Resizable.padding(context, 250), // max height
            ),
            margin: EdgeInsets.only(
                left: Resizable.padding(context, 110),
                top: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (c, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                  if (searchCubit.searchValue.isEmpty) {
                    return Container();
                  }
                  if(searchCubit.type == AppText.txtClass.text){
                    if (data["class_code"].toString().toUpperCase()
                        .contains(searchCubit.searchValue.toUpperCase())) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        classStatus: data["class_status"],
                        code: data["class_code"] ?? "",
                        classType: data["class_type"] ?? 0, id: data["class_id"],
                      );
                    }
                  }

                  if(searchCubit.type == AppText.txtStudent.text){
                    if (data["name"].toString().toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase()) || data["student_code"].toString().toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase())) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        url: data["url"] ?? "",
                        name: data["name"] ?? "",
                        code: data["student_code"] ?? "", id: data["user_id"],
                      );
                    }
                  }

                  if(searchCubit.type == AppText.txtTeacher.text){
                    if (data["name"].toString().toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase()) || data["teacher_code"].toString().toLowerCase()
                        .contains(searchCubit.searchValue.toLowerCase())) {
                      return ItemSearch(
                        type: searchCubit.type,
                        isLast: index == (snapshots.data!.docs.length - 1),
                        url: data["url"] ?? "",
                        name: data["name"] ?? "",
                        code: data["teacher_code"] ?? "",id: data["user_id"],
                      );
                    }
                  }

                  return Container();
                }));
  }
}
