import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../model/course_model.dart';
import '../../../utils/resizable.dart';
import '../../admin/manage_tag/custom_button_v1.dart';
import '../../admin/manage_tag/group_item.dart';
import '../../admin/search/general_tags/add_tag_filter_dialog.dart';

class ChooseCourseDialog extends StatelessWidget {
  const ChooseCourseDialog(
      {super.key, required this.onFinish, required this.listOlds});

  final Function(List<CourseModel>) onFinish;
  final List<CourseModel> listOlds;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Resizable.size(context, 16))),
        child: Container(
            padding: EdgeInsets.all(Resizable.padding(context, 20)),
            width: MediaQuery.of(context).size.width * 0.35,
            child: BlocProvider(
              create: (context) => ChooseCourseCubit(listOlds)..load(),
              child: BlocBuilder<ChooseCourseCubit, int>(
                builder: (context, state) {
                  final addCubit = context.read<ChooseCourseCubit>();
                  final isDataChange = areListsDifferent(
                      listOlds.map((e) => e.courseId).toList(),
                      addCubit.listChoose.map((e) => e.courseId).toList());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          AppText.textChooseCourse.text.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w600,
                              color: darkPrimaryColor),
                        ),
                      ),
                      Expanded(
                          child: state == 0 ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 10)
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: Resizable.padding(context, 10)),
                                ...addCubit.listShows.map((e) {
                                  final index = addCubit.listShows.indexOf(e);
                                  return Padding(
                                    padding:
                                    EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                                    child: GroupItemV1(
                                      isFocus: addCubit.listChoose.map((el) => el.courseId).contains(e.courseId),
                                      title: "${e.courseId} - ${e.title} ${e.termName} ${e.code}",
                                      onEdit: null,
                                      onDelete: null,
                                      onClick: () {
                                        addCubit.click(e);
                                      },
                                    ),
                                  );
                                })
                              ],
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtonV1(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                border: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                title: AppText.btnCancel.text),
                            SizedBox(
                              width: Resizable.padding(context, 5),
                            ),
                            CustomButtonV1(
                                onPressed: () async {
                                  if (addCubit.listChoose.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg:
                                            AppText.txtAtLeast1CourseChoosen.text);
                                    return;
                                  }
                                  if (!isDataChange) {
                                    Fluttertoast.showToast(
                                        msg: AppText.txtDataNotChange.text);
                                    return;
                                  }
                                  await onFinish(addCubit.listChoose);
                                },
                                textColor: Colors.white,
                                backgroundColor: primaryColor,
                                title: AppText.btnAdd.text),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            )));
  }
}

class ChooseCourseCubit extends Cubit<int> {
  ChooseCourseCubit(this.listOlds) : super(0);
  final List<CourseModel> listOlds;
  List<CourseModel> listAllCourses = [];
  List<CourseModel> listShows = [];
  List<CourseModel> listChoose = [];

  load() async {
    listAllCourses = await FireBaseProvider.instance.getAllCourseEnable();
    listShows = [...listAllCourses];
    listChoose = [...listOlds];
    emit(state + 1);
  }

  click(CourseModel e) {

    print(e.courseId);
    print(listChoose.map((el) => el.courseId));

    if(listChoose.map((el) => el.courseId).contains(e.courseId)) {
      listChoose.removeWhere((el) => el.courseId == e.courseId);
    }
    else {
      listChoose.add(e);
    }
    emit( state + 1);
  }
}
