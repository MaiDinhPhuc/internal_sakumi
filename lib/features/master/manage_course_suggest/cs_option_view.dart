import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_course_view.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_option_cubit.dart';
import 'package:internal_sakumi/features/master/manage_banner/banner_tag_view.dart';
import 'package:internal_sakumi/features/master/manage_course_suggest/manage_course_suggest_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import 'cs_course_view.dart';
import 'cs_option_cubit.dart';
import 'cs_tag_view.dart';


class CSOptionView extends StatelessWidget {
  CSOptionView({super.key, required this.manageCSCubit})
      : csOptionCubit = CSOptionCubit(manageCSCubit.currentCS);
  final ManageCourseSuggestCubit manageCSCubit;
  final CSOptionCubit csOptionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: csOptionCubit..load(),
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
                AppText.txtCSOption.text.toUpperCase(),
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
                Expanded(child: CSTagView(
                  manageCSCubit: manageCSCubit,
                  csOptionCubit: csOptionCubit,
                )),
                SizedBox(width: Resizable.padding(context, 10),),
                Expanded(child: CSCourseView(
                  manageCSCubit: manageCSCubit,
                  csOptionCubit: csOptionCubit,
                )),
              ],
            ))
          ],
        );
      },
    );
  }
}
