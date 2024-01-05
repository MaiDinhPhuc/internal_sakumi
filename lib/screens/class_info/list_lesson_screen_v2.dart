import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/lesson/list_lesson_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/lesson/list_lesson_items_v2.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ListLessonScreenV2 extends StatelessWidget {
  ListLessonScreenV2({super.key, required this.role})
      : cubit = ListLessonCubitV2(int.parse(TextUtils.getName()));
  final String role;
  final ListLessonCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(18, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 1, classId: TextUtils.getName(), role: role),
          BlocBuilder<ListLessonCubitV2, int>(
              bloc: cubit,
              builder: (c, s) {
                return cubit.classModel == null
                    ? Transform.scale(
                  scale: 0.75,
                  child: const CircularProgressIndicator(),
                )
                    : Expanded(
                    key: const Key('aa'),
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
                                  padding: EdgeInsets.only(
                                      right: Resizable.padding(context, 20),
                                      left: Resizable.padding(context, 15)),
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
                                      Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 20)),child: Text(AppText.titleSubject.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17)))),
                                      sensei: Text(AppText.txtSensei.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                      attend: Text(AppText.txtRateOfAttendance.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                      submit: Text(AppText.txtRateOfSubmitHomework.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                      mark: Text(AppText.titleStatus.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                      dropdown: Container())),
                              cubit.lessons == null
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
                                  : Column(
                                children: [
                                  ...cubit.lessons!.map((e) => LessonItemV2(cubit: cubit, role: role, lesson: e)).toList()
                                ],
                              ),
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
  }
}
