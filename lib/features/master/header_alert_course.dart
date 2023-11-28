import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_add_new_course.dart';
import 'manage_course_cubit.dart';

class HeaderAlertCourse extends StatelessWidget {
  const HeaderAlertCourse({super.key, required this.isEdit,required this.courseModel, required this.cubit});
  final bool isEdit;
  final CourseModel? courseModel;
  final ManageCourseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isEdit
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(
              bottom: Resizable.padding(context, 20)),
          child: Text(
            isEdit
                ? AppText.txtEditCourseInfo.text
                .toUpperCase()
                : AppText.btnAddNewCourse.text
                .toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 20)),
          ),
        ),
        if (isEdit)
          Padding(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 20)),
              child: BlocProvider(
                create: (context) =>
                    SwitcherCubit(courseModel!.enable),
                child: BlocBuilder<SwitcherCubit, bool>(
                  builder: (c, s) {
                    return Row(
                      children: [
                        Text(AppText.titleStatus.text,
                            style: TextStyle(
                                fontWeight:
                                FontWeight.w600,
                                fontSize: Resizable.font(
                                    context, 18),
                                color: const Color(
                                    0xff757575))),
                        Switch(
                            value: s,
                            activeColor: primaryColor,
                            onChanged:
                                (bool value) async {
                              BlocProvider.of<
                                  SwitcherCubit>(c)
                                  .update();
                              await FireBaseProvider
                                  .instance
                                  .updateCourseState(
                                  courseModel!,
                                  value);
                              cubit.loadAfterChangeStatus(
                                  courseModel!, value);
                            })
                      ],
                    );
                  },
                ),
              ))
      ],
    );
  }
}
