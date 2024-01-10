import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading_v2/grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'collapse_grading_item.dart';
import 'expand_BTVN_item.dart';
import 'grading_cubit.dart';
import 'grading_item_layout.dart';

class BTVNItem extends StatelessWidget {
  const BTVNItem(this.e, {super.key, required this.cubit});
  final GradingCubitV2 cubit;
  final LessonResultModel e;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Resizable.padding(context, 80),
          right: Resizable.padding(context, 80),
          bottom: Resizable.padding(context, 5)),
      child: BlocProvider(
          create: (context) => DropdownCubit(),
          child: BlocBuilder<DropdownCubit, int>(
            builder: (c, state) => Stack(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 15),
                        vertical: Resizable.padding(context, 5 )),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(context, 1),
                            color: state % 2 == 0
                                ? greyColor.shade100
                                : Colors.black),
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                    child: AnimatedCrossFade(
                        firstChild: CollapseGradingItem(
                          title: cubit
                              .lessons![cubit.lessons!.indexWhere(
                                  (element) => e.lessonId == element.lessonId)]
                              .title,
                          receiveTitle:
                              '${cubit.getBTVNResultCount(e.lessonId, 1)}/${cubit.students!.length}',
                          gradingTitle:
                              '${cubit.getBTVNResultCount(e.lessonId, 0)}/${cubit.students!.length}',
                          receivePercent:
                              cubit.getBTVNResultCount(e.lessonId, 1) /
                                  cubit.students!.length,
                          gradingPercent:
                              cubit.getBTVNResultCount(e.lessonId, 0) /
                                  cubit.students!.length,
                        ),
                        secondChild: Column(
                          children: [
                            CollapseGradingItem(
                              title: cubit
                                  .lessons![cubit.lessons!.indexWhere(
                                      (element) =>
                                          e.lessonId == element.lessonId)]
                                  .title,
                              receiveTitle:
                                  '${cubit.getBTVNResultCount(e.lessonId, 1)}/${cubit.students!.length}',
                              gradingTitle:
                                  '${cubit.getBTVNResultCount(e.lessonId, 0)}/${cubit.students!.length}',
                              receivePercent:
                                  cubit.getBTVNResultCount(e.lessonId, 1) /
                                      cubit.students!.length,
                              gradingPercent:
                                  cubit.getBTVNResultCount(e.lessonId, 0) /
                                      cubit.students!.length,
                            ),
                            Container(
                              height: Resizable.size(context, 1),
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 15)),
                              color: const Color(0xffD9D9D9),
                            ),
                            ExpandBTVNItem(cubit: cubit, lessonId: e.lessonId)
                          ],
                        ),
                        crossFadeState: state % 2 == 1
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 100))),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 15),
                      vertical: Resizable.padding(context, 8)),
                  child: GradingItemLayout(
                      title: Container(),
                      receivedNUmber: Container(),
                      gradingNumber: Container(),
                      button: ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context,
                              "${Routes.teacher}/grading/class=${TextUtils.getName()}/type=btvn/parent=${e.lessonId}");
                        },
                        style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all(
                                cubit.getBTVNResultCount(e.lessonId, 1) ==
                                        cubit.getBTVNResultCount(e.lessonId, 0)
                                    ? greenColor
                                    : primaryColor),
                            shape:
                                MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Resizable.padding(context, 1000)))),
                            backgroundColor: MaterialStateProperty.all(
                                cubit.getBTVNResultCount(e.lessonId, 1) ==
                                        cubit.getBTVNResultCount(e.lessonId, 0)
                                    ? greenColor
                                    : primaryColor),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: Resizable.padding(context, 30)))),
                        child: Text(
                            cubit.getBTVNResultCount(e.lessonId, 1) ==
                                    cubit.getBTVNResultCount(e.lessonId, 0)
                                ? AppText.textDetail.text
                                : AppText.titleGrading.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 16),
                                color: Colors.white)),
                      ),
                      dropdown: IconButton(
                          onPressed: () {
                            BlocProvider.of<DropdownCubit>(c).update();
                          },
                          splashRadius: Resizable.size(context, 15),
                          icon: Icon(
                            state % 2 == 0
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                          ))),
                )
              ],
            ),
          )),
    );
  }
}
