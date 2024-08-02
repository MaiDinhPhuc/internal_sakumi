import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/voucher_course_form.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/voucher_course_image.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class VoucherCourseView extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherCourseView(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffFAFAFA),
          borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: Resizable.padding(context, 15),
                        bottom: Resizable.padding(context, 10)),
                    child: Text(AppText.titleInfoVoucher.text.toUpperCase(),
                        style: TextStyle(
                          color: const Color(0xff757575),
                          fontSize: Resizable.font(context, 20),
                          fontWeight: FontWeight.w700,
                        )),
                  )),
              Expanded(
                  flex: 11,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: Resizable.padding(context, 15),
                        bottom: Resizable.padding(context, 10)),
                    child: Text(AppText.txtVoucher.text.toUpperCase(),
                        style: TextStyle(
                          color: const Color(0xff757575),
                          fontSize: Resizable.font(context, 20),
                          fontWeight: FontWeight.w700,
                        )),
                  ))
            ],
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(flex: 8, child: VoucherCourseForm(cubit)),
                Expanded(flex: 1, child: Container()),
                Container(
                    width: Resizable.size(context, 0.5),
                    margin:
                    EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                    color: const Color(0xffe0e0e0)),
                Expanded(flex: 1, child: Container()),
                Expanded(flex: 20, child: VoucherCourseImage(cubit)),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
          SizedBox(height: Resizable.size(context, 10))
        ],
      ),
    );
  }
}