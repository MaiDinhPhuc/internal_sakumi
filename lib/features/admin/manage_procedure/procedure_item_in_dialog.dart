import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/procedure_item_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ProcedureItemInDialog extends StatelessWidget {
  const ProcedureItemInDialog(
      {super.key, required this.item, required this.onRemove});
  final ProcedureItemModel item;
  final Function() onRemove;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: Resizable.size(context, 5)),
        padding: EdgeInsets.all(Resizable.size(context, 5)),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.size(context, 12), color: primaryColor)),
              SizedBox(width: Resizable.size(context, 5)),
              Text(item.des,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.size(context, 10), color: Colors.black)),
              SizedBox(width: Resizable.size(context, 5)),
            ],
          )),
          Expanded(
              flex: 1,
              child: GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.delete,
                size: Resizable.size(context, 20),
                color: primaryColor,
              )))
        ]));
  }
}
