import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_banner/choose_course_dialog.dart';
import 'package:internal_sakumi/features/master/manage_course_suggest/manage_course_suggest_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import '../../admin/manage_general/dotted_border_button.dart';
import '../../admin/manage_tag/group_item.dart';
import 'cs_option_cubit.dart';


class CSCourseView extends StatelessWidget {
  const CSCourseView(
      {super.key,
        required this.csOptionCubit,
        required this.manageCSCubit});

  final CSOptionCubit csOptionCubit;
  final ManageCourseSuggestCubit manageCSCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greyAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(Resizable.padding(context, 15)),
      child: Container(
        constraints:
        BoxConstraints(minHeight: Resizable.size(context, 100)),
        padding: EdgeInsets.all(Resizable.padding(context, 10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Khoá học',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Divider(
                    color: grey2,
                    indent: Resizable.padding(context, 5),
                    endIndent: Resizable.padding(context, 5),
                  ),
                )
              ],
            ),
            SizedBox(
              height: Resizable.padding(context, 5),
            ),
            if (csOptionCubit.courses.isNotEmpty)
              Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: Resizable.padding(context, 10)),
                        ...csOptionCubit.courses.map((e) {
                          final index =
                          csOptionCubit.courses.indexOf(e);
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: Resizable.padding(context, 5)),
                            child: GroupItemV1(
                              isFocus: false,
                              title: "${e.courseId} - ${e.title} ${e.termName} ${e.code}",
                              onEdit: null,
                              onDelete: () {
                                csOptionCubit.deleteCourseItem(e);
                              },
                              onClick: () {},
                            ),
                          );
                        })
                      ],
                    ),
                  )),
            SizedBox(height: Resizable.padding(context, 10)),
            DottedBorderButton(
              '+ ${AppText.textAdd.text.toUpperCase()}',
              isManageGeneral: true,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ChooseCourseDialog(
                        listOlds: csOptionCubit.courses,
                        onFinish: (data) async {
                          final value = await csOptionCubit
                              .changeListCourse(data);
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
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
