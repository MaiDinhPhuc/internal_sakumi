import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/master/manage_banner/manage_banner_cubit.dart';

import '../../configs/text_configs.dart';
import '../../features/master/manage_banner/banner_list_view.dart';
import '../../features/master/manage_banner/banner_option_view.dart';
import '../../features/master/manage_course_suggest/cs_list_view.dart';
import '../../features/master/manage_course_suggest/cs_option_view.dart';
import '../../features/master/manage_course_suggest/manage_course_suggest_cubit.dart';
import '../../utils/resizable.dart';
import '../../widget/custom_appbar.dart';

class ManageCourseSuggestTab  extends StatelessWidget {
  const ManageCourseSuggestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomAppbar(s: 5),
            SizedBox(height: Resizable.padding(context, 10),),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 20),
                      horizontal: Resizable.padding(context, 70)),
                  child: BlocProvider(
                    create: (context) => ManageCourseSuggestCubit()..load(),
                    child: BlocBuilder<ManageCourseSuggestCubit, int>(
                      builder: (context, state) {
                        if(state == 0) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final manageCSCubit = context.read<ManageCourseSuggestCubit>();
                        return Row(
                          children: [
                            Expanded(
                                child: CSListView(
                                    manageCSCubit: manageCSCubit
                                )),
                            SizedBox(width: Resizable.padding(context, 10),),
                            Expanded(flex: 2, child: CSOptionView(
                                manageCSCubit: manageCSCubit
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
