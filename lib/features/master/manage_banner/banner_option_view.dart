import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_course_view.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_option_cubit.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_tag_view.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import 'manage_banner_cubit.dart';

class BannerOptionView extends StatelessWidget {
  BannerOptionView({super.key, required this.manageBannerCubit})
      : bannerOptionCubit = BannerOptionCubit(manageBannerCubit.currentBanner);
  final ManageBannerCubit manageBannerCubit;
  final BannerOptionCubit bannerOptionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bannerOptionCubit..load(),
      builder: (context, state) {
        if(state == 0) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                AppText.txtBannerOption.text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Resizable.font(context, 20),
                    fontWeight: FontWeight.w600,
                    color: darkPrimaryColor),
              ),
            ),
            SizedBox(height: Resizable.padding(context, 10),),
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: BannerTagView(
                  bannerOptionCubit: bannerOptionCubit,
                  manageBannerCubit: manageBannerCubit,
                )),
                SizedBox(width: Resizable.padding(context, 10),),
                Expanded(child: BannerCourseView(
                  bannerOptionCubit: bannerOptionCubit,
                  manageBannerCubit: manageBannerCubit,
                )),
              ],
            ))
          ],
        );
      },
    );
  }
}
