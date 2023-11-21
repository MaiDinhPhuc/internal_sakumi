import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'item_search.dart';

class ItemSearchList extends StatelessWidget {
  const ItemSearchList(
      {super.key,
      required this.searchCubit,
      required this.type,
      required this.text});
  final SearchCubit searchCubit;
  final String type, text;
  @override
  Widget build(BuildContext context) {
    return text == "" ? Container() : Container(
      constraints: BoxConstraints(
        maxHeight: Resizable.padding(context, 300), // max height
      ),
      margin: EdgeInsets.only(left: Resizable.padding(context, 110), top:Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if(searchCubit.type == AppText.txtStudent.text && text != "")
              ...searchCubit.studentsNow.map((e) => ItemSearch(type: type,studentModel: e)),
            if(searchCubit.type == AppText.txtTeacher.text && text != "")
              ...searchCubit.teachersNow.map((e) => ItemSearch(type: type,teacherModel: e)),
            if(searchCubit.type == AppText.txtClass.text && text != "")
              ...searchCubit.classesNow.map((e) => ItemSearch(type: type,classModel: e,)),
          ],
        ),
      ),
    );
  }
}
