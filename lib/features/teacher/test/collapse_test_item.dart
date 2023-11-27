import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class CollapseTestItem extends StatelessWidget {
  const CollapseTestItem(
      {super.key,
      required this.index,
      required this.title,
      required this.testId,
      required this.cubit});
  final int index, testId;
  final String title;
  final TestCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TestItemRowLayout(
      test: Padding(
          padding: EdgeInsets.only(left: Resizable.padding(context, 10)),
          child: Text(
              '${AppText.textLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
                  .toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 20)))),
      name: Text(title.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16))),
      submit: cubit.listSubmit == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : cubit.listSubmit![index] == 0
              ? CircleProgress(
                  title:
                      '0%',
                  lineWidth: Resizable.size(context, 3),
                  percent: 0,
                  radius: Resizable.size(context, 16),
                  fontSize: Resizable.font(context, 14),
                )
              : CircleProgress(
                  title:
                      '${(cubit.listSubmit![index] * 100).toStringAsFixed(0)} %',
                  lineWidth: Resizable.size(context, 3),
                  percent: cubit.listSubmit![index],
                  radius: Resizable.size(context, 16),
                  fontSize: Resizable.font(context, 14),
                ),
      mark: cubit.listGPA == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : cubit.listGPA![index] == 0
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10),
                      horizontal: Resizable.padding(context, 12)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: Resizable.size(context, 1),
                          color: greyColor.shade100),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    cubit.listGPA![index].toString(),
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: Resizable.font(context, 18),
                        fontWeight: FontWeight.w800),
                  )),
      status: cubit.listTestResult == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : cubit.listStatus![cubit.listTest!.indexOf(
                      cubit.listTest!.firstWhere((e) => e.id == testId))] ==
                  null
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 4),
                      horizontal: Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10000),
                      color: cubit.listStatus![cubit.listTest!.indexOf(cubit
                                  .listTest!
                                  .firstWhere((e) => e.id == testId))] ==
                              true
                          ? greenColor
                          : redColor),
                  child: Text(
                    (cubit.listStatus![cubit.listTest!.indexOf(cubit.listTest!
                                    .firstWhere((e) => e.id == testId))] ==
                                true
                            ? AppText.txtMarked.text
                            : AppText.txtNotMark.text)
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w800),
                  )),
      dropdown: Container(),
    );
  }
}
