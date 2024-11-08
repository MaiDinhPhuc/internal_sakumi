import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_meeting_dialog_cubit.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'check_item_dialog.dart';
import 'meeting_items_cubit.dart';

class MeetingItemList extends StatelessWidget {
  const MeetingItemList({super.key, required this.cubit});
  final MeetingItemsCubit cubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 10)),
              child: DottedBorderButton("+ add Item".toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                    ProcedureItemModel newItem = ProcedureItemModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: "New Item",
                        des: "",
                        content: "",
                        group: 0,
                        type: "meeting",
                        status: true, isProgress: false
                    );
                    cubit.addItem(newItem);
                  })),
          ...(cubit.meetingItems!)
              .map(
                  (e) =>  Card(
                  margin: EdgeInsets.only(
                      right: Resizable.padding(context, 10),
                      bottom: Resizable.padding(context, 10)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      side: BorderSide(
                          color: e != cubit.procedureNow
                              ? const Color(0xffE0E0E0)
                              : Colors.black,
                          width: Resizable.size(context, 1))),
                  elevation: e == cubit.procedureNow
                      ? Resizable.size(context, 2)
                      : 0,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      onTap: () {
                        cubit.chooseItem(e);
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                              Resizable.padding(context, 10),
                              horizontal:
                              Resizable.padding(context, 15)),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: Text(
                                    e.title.toUpperCase(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(
                                            context, 17)),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Resizable.size(
                                              context, 100)),
                                      onTap: () {
                                        cubit.removeItem(e.copyWith(status: false));
                                      },
                                      child: const Icon(Icons.delete, color: primaryColor)))
                            ],
                          ))))
          )
              ,
          SizedBox(height: Resizable.size(context, 50))
        ],
      ),
    );
  }
}

class MeetingItemListV2 extends StatelessWidget {
  const MeetingItemListV2({super.key, required this.cubit, required this.type, required this.isCustom});
  final ProcedureMeetingDialogCubit cubit;
  final String type;
  final bool isCustom;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if(isCustom)
          Padding(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 10)),
              child: DottedBorderButton("+ add Item".toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return CheckItemMeetingDialog(type: type, cubit: cubit, list: cubit.meetingItems!,);
                        });
                  })),
          ...(cubit.meetingItems!)
              .map(
                  (e) =>  Card(
                  margin: EdgeInsets.only(
                      right: Resizable.padding(context, 10),
                      bottom: Resizable.padding(context, 10)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      side: BorderSide(
                          color: e != cubit.procedureNow
                              ? const Color(0xffE0E0E0)
                              : Colors.black,
                          width: Resizable.size(context, 1))),
                  elevation: e == cubit.procedureNow
                      ? Resizable.size(context, 2)
                      : 0,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      onTap: () {
                        cubit.chooseItem(e);
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                              Resizable.padding(context, 10),
                              horizontal:
                              Resizable.padding(context, 15)),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: Text(
                                    e.title.toUpperCase(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(
                                            context, 17)),
                                  )),
                              if(isCustom)
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Resizable.size(
                                              context, 100)),
                                      onTap: () {
                                        cubit.removeItem(e);
                                      },
                                      child: const Icon(Icons.delete, color: primaryColor)))
                            ],
                          ))))
          ),
          SizedBox(height: Resizable.size(context, 50))
        ],
      ),
    );
  }
}
