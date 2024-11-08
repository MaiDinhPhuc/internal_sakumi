import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_group_cubit.dart';
import 'package:internal_sakumi/model/procedure_group_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ProcedureGroupList extends StatelessWidget {
  const ProcedureGroupList({super.key, required this.cubit});
  final GroupProcedureCubit cubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 10)),
              child: DottedBorderButton("+ add Group".toUpperCase(),
                  isManageGeneral: true, onPressed: () {
                    selectionDialog(context, "Checklist Group", "Meeting Group", () {
                      Navigator.pop(context);
                      ProcedureGroupModel newItem = ProcedureGroupModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: "New Checklist Group",
                        des: "",
                        type: "checklist",
                        status: true,
                      );
                      cubit.addItem(newItem);
                    }, () {
                      Navigator.pop(context);
                      ProcedureGroupModel newItem = ProcedureGroupModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: "New Meeting Group",
                        des: "",
                        type: "meeting",
                        status: true,
                      );
                      cubit.addItem(newItem);
                    });

                  })),
          ...(cubit.procedureGroupList!)
              .map(
                  (e) =>  Card(
                  margin: EdgeInsets.only(
                      right: Resizable.padding(context, 10),
                      bottom: Resizable.padding(context, 10)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      side: BorderSide(
                          color: e != cubit.groupNow
                              ? const Color(0xffE0E0E0)
                              : Colors.black,
                          width: Resizable.size(context, 1))),
                  elevation: e == cubit.groupNow
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