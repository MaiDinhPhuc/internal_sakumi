import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_form.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_image.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_search.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 6),
          Expanded(
              child: BlocProvider(
                  create: (context) => VoucherCubit()..quantityVoucher(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: Resizable.padding(context, 20)),
                          child: Text(
                              AppText.titleManageVoucher.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: Resizable.font(context, 30),
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        BlocBuilder<VoucherCubit, int>(builder: (c, s) {
                          var cubit = BlocProvider.of<VoucherCubit>(c);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 15)),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Container()),
                                Expanded(flex: 3, child: VoucherSearch(cubit)),
                                Expanded(flex: 1, child: Container()),
                              ],
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 20,
                                child: BlocBuilder<VoucherCubit, int>(
                                    builder: (c, s) {
                                  return VoucherView(
                                      BlocProvider.of<VoucherCubit>(c));
                                })),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}

class VoucherView extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherView(this.cubit, {Key? key}) : super(key: key);

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
                Expanded(flex: 8, child: VoucherForm(cubit)),
                Expanded(flex: 1, child: Container()),
                Container(
                    width: Resizable.size(context, 0.5),
                    margin:
                        EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                    color: const Color(0xffe0e0e0)),
                Expanded(flex: 1, child: Container()),
                Expanded(flex: 20, child: VoucherImage(cubit)),
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
