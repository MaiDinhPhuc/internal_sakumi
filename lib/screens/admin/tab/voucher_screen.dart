import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/voucher/app_voucher/voucher_app_view.dart';
import 'package:internal_sakumi/features/admin/voucher/change_tab_voucher.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/voucher_course_search_list.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/voucher_course_view.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_search.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class VoucherScreen extends StatelessWidget {
  VoucherScreen({Key? key})
      : cubit = VoucherCubit(),
        super(key: key);

  final VoucherCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 6),
          BlocBuilder<VoucherCubit, int>(
              bloc: cubit,
              builder: (c,s){
            return Padding(
              padding: EdgeInsets.only(
                  top: Resizable.padding(context, 10)),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 3, child: ChangeTabVoucherView(cubit: cubit)),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            );
          }),
          BlocBuilder<VoucherCubit, int>(
              bloc: cubit,
              builder: (c,s){
            return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 15)),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(flex: 3, child: VoucherSearch(cubit)),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                      ),
                      cubit.tab == AppText.txtCourse.text
                          ? Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 20,
                                  child:VoucherCourseView(cubit)),
                              Expanded(flex: 1, child: Container()),
                            ],
                          ),
                          if (cubit.listSearchVoucherCourse.isNotEmpty)
                            Row(
                              children: [
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 3, child: VoucherCourseSearchList(cubit)),
                                Expanded(flex: 1, child: Container()),
                              ],
                            ),
                        ],
                      )
                          : Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 20,
                                  child:VoucherAppView(cubit)),
                              Expanded(flex: 1, child: Container()),
                            ],
                          ),
                          // if (cubit.listSearchVoucherCourse.isNotEmpty)
                          //   Row(
                          //     children: [
                          //       Expanded(flex: 1, child: Container()),
                          //       Expanded(
                          //           flex: 3, child: VoucherCourseSearchList(cubit)),
                          //       Expanded(flex: 1, child: Container()),
                          //     ],
                          //   ),
                        ],
                      )
                    ],
                  ),
                ));
          })
        ],
      ),
    );
  }
}


