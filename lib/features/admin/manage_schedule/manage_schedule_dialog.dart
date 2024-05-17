import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/schedule_dialog_button.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import '../../../services/custom_firebase_firestore.dart';
import '../search/item_search.dart';
import 'item_schedule.dart';
import 'manage_schedule_cubit.dart';
import 'manage_schedule_dialog_cubit.dart';

class ManageScheduleDialog extends StatelessWidget {
  ManageScheduleDialog({super.key, required this.cubit})
      : manageCubit = ManageScheduleDialogCubit(cubit);
  final ManageScheduleCubit cubit;
  final ManageScheduleDialogCubit manageCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageScheduleDialogCubit, int>(
        bloc: manageCubit,
        builder: (c, s) {
          if (manageCubit.loading) {
            return const WaitingAlert();
          }
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: LayoutBuilder(builder: (context, constraints) => Form(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 10)),
                          child: Text(
                            AppText.txtManageSchedule.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        ),
                        DropDownSearchField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 25),
                                  color: Colors.black),
                              onChanged: (String value) {
                                manageCubit.searchClass(value);
                              },
                              controller: manageCubit.classController,
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

                            if (manageCubit.classController.text.isEmpty) {
                              return Container();
                            }
                            if (data["class_code"]
                                .toString()
                                .toLowerCase()
                                .contains(manageCubit.classSearchValue.toLowerCase()) &&
                                data["is_sub_class"] == false) {
                              return ItemSearchV2(
                                type: AppText.txtClass.text,
                                isLast: false,
                                classStatus: data["class_status"],
                                code: data["class_code"] ?? "",
                                classType: data["class_type"] ?? 0,
                                id: data["class_id"],
                                onTap: () async {
                                  manageCubit.classController.text = "${data["class_code"] ?? ""}";
                                  manageCubit.chooseClass(
                                      "${data["class_code"] ?? ""}", data["class_id"]);
                                  await manageCubit.loadSchedule();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Expanded(
                                  flex: 2,
                                  child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: Resizable.size(context, 10)),
                                    ...manageCubit.listSchedule!.map((e) => ItemSchedule(
                                      type: e.type,
                                      sensei: "Cẩm hà",
                                      info: "Thứ 2, 4, 6",
                                      onTap: () {
                                        manageCubit.selectSchedule(e);
                                      },
                                      isChoose: manageCubit.selectedSchedule == null ? false : manageCubit.selectedSchedule == e,
                                    ))
                                  ],
                                ),
                              )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SizedBox(height: Resizable.size(context, 10)),
                                    ScheduleDialogButton(
                                      title: AppText.txtEdit.text.toUpperCase(),
                                      onTap: () {}, icon: manageCubit.selectedSchedule != null? 'assets/images/edit_schedule_enable.png' : 'assets/images/edit_schedule_disable.png', enable: manageCubit.selectedSchedule != null,
                                    ),
                                    ScheduleDialogButton(
                                      title: AppText.txtAddCyclicSchedule.text.toUpperCase(),
                                      onTap: () {}, icon: 'assets/images/cyclic_schedule.png', enable: true,
                                    ),
                                    ScheduleDialogButton(
                                      title: AppText.txtAddSingleSchedule.text.toUpperCase(),
                                      onTap: () {}, icon: 'assets/images/single_schedule.png', enable: true,
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ))));
        });
  }
}
