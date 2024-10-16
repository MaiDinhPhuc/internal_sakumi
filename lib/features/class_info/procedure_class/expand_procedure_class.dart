import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_item_cubit.dart';
import 'package:internal_sakumi/features/class_info/procedure_class/procedure_class_cubit.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class ExpandProcedureClass extends StatelessWidget {
  const ExpandProcedureClass(
      {super.key, required this.cubit, required this.itemCubit, required this.role});
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
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19)))),
            NoteWidget(
                itemCubit.procedure == null ? "" : itemCubit.procedure!.des),
          ],
        ),
        Container(
          height: Resizable.size(context, 1),
          margin:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
          color: greyColor.shade300,
        ),
        if (itemCubit.listItem != null)
          ...itemCubit.listItem!.map((e) =>Container(
              margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
              padding:  EdgeInsets.all( Resizable.padding(context, 5)),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color:  greyColor.shade100
                     ),
                  borderRadius:
                  BorderRadius.circular(Resizable.size(context, 5))),
            child: Row(
              children: [
                if(e.type == 'checklist')
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: (){
                          if(role == 'admin'){
                            itemCubit.setValueProgress(e,itemCubit.checkPercent(e) == 100 ? 0 : 100);
                          }

                        },
                        child: Icon(itemCubit.checkPercent(e) == 0 || !itemCubit.checkBool(e) ? Icons.check_box_outline_blank_rounded :Icons.check_box))),
                Expanded(
                    flex: e.isProgress ? 15 : 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(e.title, style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 19)) ), Text(e.des)],
                    )),
                if(e.isProgress && e.type == 'checklist')
                  Expanded(
                      flex: 5,
                      child: Slider(
                        value: itemCubit.checkPercent(e),
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        label: itemCubit.checkPercent(e).toString(),
                        onChanged: (value) {
                          if(role == 'admin'){
                            itemCubit.setValueProgress(e,value);
                          }

                        },
                      ))
              ],
            ),
          )),
        if(itemCubit.isConfirm && role == 'admin')
          AddNewLessonButton((){
            itemCubit.updateProcedureClass();
          }, true)
      ],
    );
  }
}
