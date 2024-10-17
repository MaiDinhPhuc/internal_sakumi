import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_meeting_dialog.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class ExpandProcedureClass extends StatelessWidget {
  const ExpandProcedureClass(
      {super.key,
      required this.cubit,
      required this.itemCubit,
      required this.role});
  final ProcedureClassCubit cubit;
  final ProcedureClassItemCubit itemCubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: Resizable.padding(context, 5),
                    left: Resizable.padding(context, 5)),
                child: Text(AppText.txtDescription.text,
                    style: TextStyle(
                        color: greyColor.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 18)))),
            NoteWidget(
                itemCubit.procedure == null ? "" : itemCubit.procedure!.des),
            if (itemCubit.procedureClass.type == 'meeting')
              Padding(
                  padding:
                      EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biên bản",
                          style: TextStyle(
                              color: greyColor.shade600,
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 18))),
                      if (!itemCubit.isSendReport && role == "admin")
                        SizedBox(
                          height: Resizable.size(context, 15),
                          child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            splashRadius: Resizable.size(context, 15),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors
                                    .black, // Set the desired border color here
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Resizable.size(context, 5)),
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  itemCubit.changeIsRp(true);
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10)),
                                child: Center(
                                    child: Text(AppText.txtEdit.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 20)))),
                              )
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        )
                    ],
                  )),
            if (itemCubit.procedureClass.type == 'meeting')
              itemCubit.isSendReport ? InputField(
                controller: itemCubit.textEditingController,
                isExpand: true,
                onChange: (value){
                  itemCubit.setReport(value);
                },
              ) : NoteWidget(itemCubit.textEditingController.text),

            if (itemCubit.procedureClass.type == 'meeting' && itemCubit.isSendReport && role == "admin")
              AddNewLessonButton(() {
                itemCubit.updateProcedureClass();
                itemCubit.changeIsRp(false);
              }, true)
          ],
        ),
        Container(
          height: Resizable.size(context, 1),
          margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          color: greyColor.shade300,
        ),
        if (itemCubit.listItem != null)
          Padding(
              padding: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      itemCubit.procedureClass.type == 'meeting'
                          ? "Meeting items"
                          : "Checklist items",
                      style: TextStyle(
                          color: greyColor.shade600,
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 18))),
                  if (itemCubit.procedureClass.type == 'meeting')
                    SizedBox(
                      height: Resizable.size(context, 15),
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        splashRadius: Resizable.size(context, 15),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors
                                .black, // Set the desired border color here
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 5)),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ProcedureMeetingDialog(
                                        procedureClassModel:
                                            itemCubit.procedureClass,
                                        type: "meeting",
                                        procedureClassCubit: cubit,
                                        itemCubit: itemCubit);
                                  });
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 10)),
                            child: Center(
                                child: Text(AppText.textDetail.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            Resizable.font(context, 20)))),
                          )
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    )
                ],
              )),
        if (itemCubit.listItem != null)
          ...itemCubit.listItem!.map((e) => Container(
                margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                padding: EdgeInsets.all(Resizable.padding(context, 5)),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: Resizable.size(context, 1),
                        color: greyColor.shade100),
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5))),
                child: Row(
                  children: [
                    if (e.type == 'checklist')
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () {
                                if (role == 'admin') {
                                  itemCubit.setValueProgress(
                                      e,
                                      itemCubit.checkPercent(e) == 100
                                          ? 0
                                          : 100);
                                }
                              },
                              child: Icon(itemCubit.checkPercent(e) == 0 ||
                                      !itemCubit.checkBool(e)
                                  ? Icons.check_box_outline_blank_rounded
                                  : Icons.check_box))),
                    Expanded(
                        flex: e.isProgress ? 15 : 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 19))),
                            Text(e.des)
                          ],
                        )),
                    if (e.isProgress && e.type == 'checklist')
                      Expanded(
                          flex: 5,
                          child: Slider(
                            value: itemCubit.checkPercent(e),
                            min: 0.0,
                            max: 100.0,
                            divisions: 100,
                            label: itemCubit.checkPercent(e).toString(),
                            onChanged: (value) {
                              if (role == 'admin') {
                                itemCubit.setValueProgress(e, value);
                              }
                            },
                          ))
                  ],
                ),
              )),
        if (itemCubit.isConfirm && role == 'admin')
          AddNewLessonButton(() {
            itemCubit.updateProcedureClass();
          }, true)
      ],
    );
  }
}
