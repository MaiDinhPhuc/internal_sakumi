import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/item_search.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_item_v2.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_taught_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import '../../../services/custom_firebase_firestore.dart';
import '../../../widget/submit_button.dart';
import 'change_date_view.dart';
import 'manage_schedule_cubit.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key, required this.cubit});

  final ManageScheduleCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageScheduleCubit,int>(
        bloc: cubit,
        builder: (c,s){
          return SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)),
                            child: Text(AppText.txtTeacher.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 18),
                                    color: const Color(0xff757575))))),
                    SizedBox(width: Resizable.padding(context, 10)),
                    Expanded(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)),
                            child: Text(AppText.txtClass.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 18),
                                    color: const Color(0xff757575))))),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                            EdgeInsets.only(left: Resizable.padding(context, 10)),
                            child: Container()))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: DropDownSearchField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 25),
                                  color: Colors.black),
                              onChanged: (String value) {
                                if(value == ""){
                                  cubit.teacherController.text = "";
                                  cubit.teacherId = null;
                                }
                                cubit.searchTeacher(value);
                              },
                              controller: cubit.teacherController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: AppText.txtSearchTeacher.text,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Resizable.font(context, 20),
                                    color: darkPrimaryColor),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 20),
                                ),
                                constraints: BoxConstraints(
                                    maxHeight: Resizable.size(context, 40)),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: grey2),
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                    tooltip: AppText.txtSearchTeacher.text,
                                    onPressed: null,
                                    splashColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    )),
                              )),
                          suggestionsCallback: (pattern) async {
                            return (await CustomFirebaseFireStore.database
                                .collection("teacher")
                                .get())
                                .docs;
                          },
                          itemBuilder: (context, suggestion) {
                            var data = suggestion.data();

                            if (cubit.teacherController.text.isEmpty) {
                              return Container();
                            }

                            if (data["name"]
                                .toString()
                                .toLowerCase()
                                .contains(cubit.teacherSearchValue.toLowerCase()) ||
                                data["teacher_code"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(cubit.teacherSearchValue.toLowerCase()) ||
                                data["email"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(cubit.teacherSearchValue.toLowerCase())) {
                              return ItemSearchV2(
                                type: AppText.txtTeacher.text,
                                isLast: false,
                                url: data["url"] ?? "",
                                name: data["name"] ?? "",
                                code: data["teacher_code"] ?? "",
                                id: data["user_id"],
                                email: data["email"],
                                onTap: () {
                                  cubit.teacherController.text =
                                  "${data["name"] ?? ""} - ${data["teacher_code"] ?? ""}";
                                  cubit.chooseTeacher(
                                      "${data["name"] ?? ""} - ${data["teacher_code"] ?? ""}",
                                      data["user_id"]);
                                },
                              );
                            }
                            return Container();
                          },
                          onSuggestionSelected: (suggestion) {},
                          displayAllSuggestionWhenTap: true,
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          hideOnLoading: true,
                          hideOnEmpty: true,
                        )),
                    SizedBox(width: Resizable.padding(context, 10)),
                    Expanded(
                      flex: 3,
                      child: DropDownSearchField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 25),
                                color: Colors.black),
                            onChanged: (String value) {
                              if(value == ""){
                                cubit.classController.text = "";
                                cubit.classId = null;
                              }
                              cubit.searchClass(value);
                            },
                            controller: cubit.classController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: AppText.txtSearchClass.text,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 20),
                                  color: darkPrimaryColor),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 20),
                              ),
                              constraints: BoxConstraints(
                                  maxHeight: Resizable.size(context, 40)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: grey2),
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: IconButton(
                                  tooltip: AppText.txtSearchClass.text,
                                  onPressed: null,
                                  splashColor: Colors.transparent,
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  )),
                            )),
                        suggestionsCallback: (pattern) async {
                          return (await CustomFirebaseFireStore.database
                              .collection("class")
                              .get())
                              .docs;
                        },
                        itemBuilder: (context, suggestion) {
                          var data = suggestion.data();

                          if (cubit.classController.text.isEmpty) {
                            return Container();
                          }
                          if (data["class_code"]
                              .toString()
                              .toLowerCase()
                              .contains(cubit.classSearchValue.toLowerCase()) &&
                              data["is_sub_class"] == false) {
                            return ItemSearchV2(
                              type: AppText.txtClass.text,
                              isLast: false,
                              classStatus: data["class_status"],
                              code: data["class_code"] ?? "",
                              classType: data["class_type"] ?? 0,
                              id: data["class_id"],
                              onTap: () {
                                cubit.classController.text = "${data["class_code"] ?? ""}";
                                cubit.chooseClass(
                                    "${data["class_code"] ?? ""}", data["class_id"]);
                              },
                            );
                          }
                          return Container();
                        },
                        onSuggestionSelected: (suggestion) {},
                        displayAllSuggestionWhenTap: true,
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        hideOnLoading: true,
                        hideOnEmpty: true,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                            EdgeInsets.only(left: Resizable.padding(context, 10)),
                            child: SubmitButton(
                                onPressed: () async {
                                  if(cubit.teacherId == null && cubit.classId == null){
                                    return;
                                  }else{
                                    waitingDialog(context);
                                    await cubit.getSchedule();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                title: "Tìm")))
                  ],
                ),
                SizedBox(height: Resizable.size(context, 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.txtSchedule.text.toUpperCase(),
                        style: TextStyle(
                            color: greyColor.shade600,
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 20))),
                    ChangeDateView(cubit: cubit),
                    cubit.isLoadingSchedule
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                      children: [
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.all(Resizable.padding(context, 10)),
                              height: Resizable.size(context, 600),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: Resizable.size(context, 1),
                                      color: greyColor.shade300),
                                  borderRadius:
                                  BorderRadius.circular(Resizable.size(context, 5))),
                              child: Column(
                                children: [
                                  ...cubit.listDay.map((e) => Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                e,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(context, 15),
                                                    color: greyColor.shade600),
                                              ),
                                              Text(
                                                cubit.getDate(cubit.listDay.indexOf(e)),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(context, 15),
                                                    color: greyColor.shade600),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: Resizable.padding(context, 10)),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                ...cubit
                                                    .getResult(cubit.listDay.indexOf(e))
                                                    .map((ee) => Padding(
                                                    padding: EdgeInsets.all(
                                                        Resizable.padding(
                                                            context, 3)),
                                                    child: ScheduleTaughtItemV2(
                                                        cubit: cubit,
                                                        lessonResultModel: ee))),
                                                ...cubit
                                                    .getScheduleItem(
                                                    cubit.listDay.indexOf(e))
                                                    .map((ee) => ee.type == "cyclic"? Padding(padding: EdgeInsets.all(
                                                    Resizable.padding(
                                                        context, 3)),child: CyclicScheduleItem(
                                                  cubit: cubit, scheduleModel: ee,index: cubit.listDay.indexOf(e))): Padding(padding: EdgeInsets.all(
                                                    Resizable.padding(
                                                        context, 3)),child: SingleScheduleItem(
                                                  cubit: cubit, scheduleModel: ee,index: cubit.listDay.indexOf(e))))
                                              ],
                                            ),
                                          )
                                        ],
                                      )))
                                ],
                              ),
                            ))
                      ],
                    )
                  ],
                )
              ],
            )),
          );
        });
  }
}
