import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ChangeTabVoucherView extends StatelessWidget {
  const ChangeTabVoucherView({super.key, required this.cubit});
  final VoucherCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Resizable.size(context, 35),
      decoration: BoxDecoration(
          color: greyColor.shade100,
          borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: ()async{
                    await cubit.changeTab(AppText.txtCourse.text);
                  },
                  child: Container(
                      height: Resizable.size(context, 35),
                      decoration: cubit.tab == AppText.txtCourse.text? ShapeDecoration(
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
                          AppText.txtCourse.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cubit.tab == AppText.txtCourse.text ?Colors.black:greyColor.shade600,
                            fontSize: Resizable.font(context, 22),
                            fontWeight: FontWeight.w700,
                          )
                      ))
                  )
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: ()async{
                   await cubit.changeTab(AppText.txtApp.text);
                  },
                  child: Container(
                      height: Resizable.size(context, 35),
                      decoration: cubit.tab != AppText.txtCourse.text? ShapeDecoration(
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
                          AppText.txtApp.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cubit.tab != AppText.txtCourse.text ?Colors.black:greyColor.shade600,
                            fontSize: Resizable.font(context, 22),
                            fontWeight: FontWeight.w700,
                          )
                      ))
                  )
              )),
        ],
      ),
    );
  }
}
