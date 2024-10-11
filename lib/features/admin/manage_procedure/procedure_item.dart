import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_procedure/procedure_dialog.dart';
import 'package:internal_sakumi/model/procedure_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_procedure_cubit.dart';

class ProcedureItem extends StatelessWidget {
  const ProcedureItem({super.key, required this.procedureModel, required this.cubit});
  final ProcedureModel procedureModel;
  final ManageProcedureCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
      child: Stack(
        children: [
          Container(
              padding:
                  EdgeInsets.all(Resizable.padding(context, 9)),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(context, 1),
                      color: greyColor.shade100),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(procedureModel.title,style:  TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 20))),
                  Text(procedureModel.des, style: TextStyle(
                      color:  Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 16)))
                ],
              )),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: ()async{
                showDialog(
                    context: context,
                    builder: (_) {
                      return ProcedureDialog(
                          cubit: cubit, procedureModel: procedureModel);
                    });
              },
              borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
            ),
          )),
        ],
      ),
    );
  }
}
