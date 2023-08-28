import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/test/collapse_test_item.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../utils/text_utils.dart';

class ClassTestTab extends StatelessWidget {
  const ClassTestTab(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>TestCubit()..init(context),
      child: Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
              index: 2,
              classId: TextUtils.getName(position: 2),
              name: name,
            ),
            BlocBuilder<TestCubit, int>(builder: (c,s){
              var cubit = BlocProvider.of<TestCubit>(c);
              return cubit.classModel == null ?
              Transform.scale(
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
                          vertical: Resizable.padding(context, 20)),
                      child: Text(
                          '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 30))),
                    ),
                    cubit.listTest == null ?
                    Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    )
                        : Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(
                                    context, 20)),
                            margin: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(
                                    context, 150)),
                            child: TestItemRowLayout(
                                test: Text(
                                    AppText.txtTest.text,
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.w600,
                                        color: const Color(
                                            0xff757575),
                                        fontSize: Resizable.font(
                                            context, 17))),
                                name:
                                Text(AppText.titleSubject.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                submit: Text(AppText.txtRateOfSubmitTest.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                mark: Text(AppText.txtAveragePoint.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                status: Text(AppText.titleStatus.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                               )),
                        ...cubit.listTest!.map((e) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(
                                  context, 150),
                              vertical: Resizable.padding(
                                  context, 5)),
                          child: BlocProvider(
                              create: (context) =>
                                  DropdownCubit(),
                              child: BlocBuilder<
                                  DropdownCubit, int>(
                                builder: (c, state) =>
                                    Stack(
                                      children: [
                                        Container(
                                            alignment: Alignment
                                                .centerLeft,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                Resizable.padding(
                                                    context, 15),
                                                vertical:
                                                Resizable.padding(
                                                    context, 8)),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: Resizable.size(
                                                        context, 1),
                                                    color: state % 2 == 0
                                                        ? greyColor
                                                        .shade100
                                                        : Colors
                                                        .black),
                                                borderRadius:
                                                BorderRadius.circular(Resizable.size(context, 5))),
                                            child: cubit.listTest == null || cubit.listTest!.isEmpty
                                                ? Transform.scale(
                                              scale: 0.75,
                                              child:
                                              const CircularProgressIndicator(),
                                            )
                                                : AnimatedCrossFade(
                                                firstChild: CollapseTestItem(index: cubit.listTest!.indexOf(e), title:  e.title),
                                                secondChild: Column(
                                                  children: [
                                                    CollapseTestItem(index: cubit.listTest!.indexOf(e), title:  e.title)
                                                    // ExpandLessonItem(cubit
                                                    //     .lessons!
                                                    //     .indexOf(e))
                                                  ],
                                                ),
                                                crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                duration: const Duration(milliseconds: 100))),
                                        Positioned.fill(
                                            child: Material(
                                              color: Colors
                                                  .transparent,
                                              child: InkWell(
                                                  onDoubleTap:
                                                      () {},
                                                  onTap: () async {
                                                  },
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      Resizable.size(
                                                          context,
                                                          5))),
                                            )),
                                      ],
                                    ),
                              )),
                        ))
                      ],
                    )
                  ],
                ),
              ));
            })
          ],
        ),
      ),
    );
  }
}

