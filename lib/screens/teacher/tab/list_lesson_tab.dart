import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/list_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ListLessonTab extends StatelessWidget {
  final String role;
  final LessonTabCubit cubit;
  ListLessonTab(this.role, {Key? key})
      : cubit = LessonTabCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    final shimmerList = List.generate(18, (index) => index);
    return BlocBuilder<DataCubit, int>(builder: (cc, classes) {
      return Scaffold(
        body: Column(
          children: [
            HeaderTeacher(index: 1, classId: TextUtils.getName(), role: role),
            dataController.classes == null
                ? Center(
                    child: Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : BlocBuilder<LessonTabCubit, int>(
                    bloc: cubit
                      ..load(dataController.classes!.firstWhere((e) =>
                          e.classModel.classId ==
                          int.parse(TextUtils.getName()))),
                    builder: (c, s) {
                      return cubit.classModel == null
                          ? Transform.scale(
                              scale: 0.75,
                              child: const CircularProgressIndicator(),
                            )
                          : Expanded(
                              key: Key('aa'),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              Resizable.padding(context, 20)),
                                      child: Text(
                                          '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                                  Resizable.font(context, 30))),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 20)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 150)),
                                            child: LessonItemRowLayout(
                                                lesson: Text(
                                                    AppText.subjectLesson.text,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff757575),
                                                        fontSize: Resizable.font(
                                                            context, 17))),
                                                name:
                                                    Text(AppText.titleSubject.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                sensei: Text(AppText.txtSensei.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                attend: Text(AppText.txtRateOfAttendance.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                submit: Text(AppText.txtRateOfSubmitHomework.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                mark: Text(AppText.titleStatus.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                dropdown: Container())),
                                        cubit.listLessonInfo == null
                                            ? Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: SingleChildScrollView(
                                                    child: Column(
                                                  children: [
                                                    SizedBox(height: Resizable.padding(context, 10)),
                                                    ...shimmerList.map((e) => Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: Resizable
                                                                    .padding(
                                                                        context,
                                                                        150)),
                                                        child:
                                                            const ItemShimmer()))
                                                  ],
                                                )),
                                              )
                                            : ListLessonItem(cubit: cubit, role: role),
                                        SizedBox(
                                            height: Resizable.size(context, 50))
                                      ],
                                    )
                                  ],
                                ),
                              ));
                    }),
          ],
        ),
      );
    });
  }
}
