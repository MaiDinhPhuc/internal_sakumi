import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_banner/choose_course_dialog.dart';
import 'package:internal_sakumi/features/master/manage_course_suggest/manage_course_suggest_cubit.dart';
import 'package:internal_sakumi/screens/master/manage_course_suggest_tab.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../admin/manage_general/dotted_border_button.dart';
import '../../admin/manage_tag/group_item.dart';

class CSListView extends StatelessWidget {
  const CSListView({super.key, required this.manageCSCubit});
  final ManageCourseSuggestCubit manageCSCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            AppText.txtListCS.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w600,
                color: darkPrimaryColor),
          ),
        ),
        if (manageCSCubit.courses.isNotEmpty)
          Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Resizable.padding(context, 10)),
                    ...manageCSCubit.courseSuggests.map((e) {
                      final index = manageCSCubit.courseSuggests.indexOf(e);
                      final course = manageCSCubit.courses.where((element) => element.courseId == e.idCourse).first;
                      return Padding(
                        padding:
                        EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                        child: GroupItemV1(
                          isFocus: index == manageCSCubit.csIndex,
                          title: "${course.courseId} - ${course.title} ${course.termName} ${course.code}",
                          onEdit: null,
                          onDelete: () {
                            Dialogs.alertDelete(
                                context, AppText.txtConfirmDeleteCS.text,
                                    () async {
                                  bool value =
                                  await manageCSCubit.deleteCS(index);
                                  if (context.mounted) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtDeleteSuccess.text);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtError.text);
                                    }
                                    Navigator.pop(context);
                                  }
                                });
                          },
                          onClick: () {
                            manageCSCubit.setCurrentIndex(index);
                          },
                        ),
                      );
                    })
                  ],
                ),
              )),
        SizedBox(height: Resizable.padding(context, 10)),
        DottedBorderButton('+ ${AppText.txtAddCourseSuggest.text.toUpperCase()}',
            isManageGeneral: true, onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ChooseCourseDialog(
                      onFinish: (data ) async{

                        final value = await manageCSCubit.updateCourses(data);
                        if (context.mounted) {
                          if (value) {
                            Fluttertoast.showToast(
                                msg: AppText.txtAddSuccess.text);
                          } else {
                            Fluttertoast.showToast(
                                msg: AppText.txtError.text);
                          }
                          Navigator.pop(context);
                        }
                      },
                      listOlds: manageCSCubit.courses,
                    );
                  });
            }),
      ],
    );
  }
}
