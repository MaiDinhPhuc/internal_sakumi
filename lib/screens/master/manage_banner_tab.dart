import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/master/manage_banner/manage_banner_cubit.dart';

import '../../configs/text_configs.dart';
import '../../features/master/manage_banner/banner_list_view.dart';
import '../../features/master/manage_banner/banner_option_view.dart';
import '../../utils/resizable.dart';
import '../../widget/custom_appbar.dart';

class ManageBannerTab extends StatelessWidget {
  const ManageBannerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomAppbar( s: 4),
            SizedBox(height: Resizable.padding(context, 10),),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 20),
                      horizontal: Resizable.padding(context, 70)),
                  child: BlocProvider(
                    create: (context) => ManageBannerCubit()..load(),
                    child: BlocBuilder<ManageBannerCubit, int>(
                      builder: (context, state) {
                        if(state == 0) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final manageBannerCubit = context.read<ManageBannerCubit>();
                        return Row(
                          children: [
                            Expanded(
                                child: BannerListView(
                                    manageBannerCubit: manageBannerCubit
                                )),
                            SizedBox(width: Resizable.padding(context, 10),),
                            Expanded(flex: 2, child: BannerOptionView(
                                manageBannerCubit: manageBannerCubit
                            ))
                          ],
                        );
                      },
                    ),
                  ),
                ))
          ],
        ));
  }
}
