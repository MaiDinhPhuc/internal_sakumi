import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';


class ManageStdTabView extends StatelessWidget {
  const ManageStdTabView({super.key, required this.cubit});
  final StudentInfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !cubit.firstTab
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Container(
          width: Resizable.size(context, 300),
          height: Resizable.size(context, 40),
          decoration: BoxDecoration(
              color: greyColor.shade100,
              borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: (){
                      cubit.changeTab();
                    },
                    child: Container(
                      height: Resizable.size(context, 40),
                      decoration: cubit.firstTab? ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF757575)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows:const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 2,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ): null,
                      child: Center(child: Text(
                        AppText.titleManageClass.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cubit.firstTab ?Colors.black:greyColor.shade600,
                          fontSize: Resizable.font(context, 18),
                          fontWeight: FontWeight.w700,
                        )
                      ))
                    )
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        cubit.changeTab();
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: !cubit.firstTab? ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF757575)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows:const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ): null,
                          child: Center(child: Text(
                              AppText.txtTabBill.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !cubit.firstTab ?Colors.black:greyColor.shade600,
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w700,
                              )
                          ))
                      )
                  )),
            ],
          ),
        ),
        if(!cubit.firstTab)
          AddButton(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => BillDialogV2(isEdit: false, cubit: cubit.billCubit));
          }, title: AppText.titleAddBill.text,
        )
      ],
    );
  }
}
