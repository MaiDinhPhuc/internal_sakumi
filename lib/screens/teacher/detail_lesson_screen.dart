import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_complete_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_pending_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_teaching_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/pending_view_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../utils/text_utils.dart';

class DetailLessonScreen extends StatelessWidget {
  DetailLessonScreen({Key? key})
      : cubit = DetailLessonCubit(),
        sessionCubit = SessionCubit(),
        pendingViewCubit = PendingViewCubit(),
        super(key: key);
  final DetailLessonCubit cubit;
  final SessionCubit sessionCubit;
  final PendingViewCubit pendingViewCubit;
  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    return BlocBuilder<DataCubit, int>(builder: (c, classes) {
      return Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
              index: 1,
              classId: TextUtils.getName(position: 1),
              role: 'teacher',
            ),
            dataController.classes == null
                ? Transform.scale(
                    scale: 0.75,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    //key: Key('${cubit.state?.status}'),
                    child: SingleChildScrollView(
                        child: BlocProvider.value(
                    value: cubit,
                    child: BlocBuilder<DetailLessonCubit, LessonResultModel?>(
                      bloc: cubit
                        ..checkLessonResult(
                            int.parse(TextUtils.getName(position: 1)),
                            dataController),
                      builder: (cc, s) {
                        return s == null
                            ? Transform.scale(
                                scale: 0.75,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            Resizable.padding(context, 20)),
                                    child: Text(
                                        '${BlocProvider.of<DetailLessonCubit>(cc).title}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize:
                                                Resizable.font(context, 30))),
                                  ),
                                  if (s.status == 'Pending')
                                    LessonPendingView(
                                        BlocProvider.of<DetailLessonCubit>(cc),
                                        dataController,
                                        pendingViewCubit),
                                  if (s.status == 'Teaching')
                                    LessonTeachingView(
                                      dataCubit: dataController,
                                      sessionCubit: sessionCubit,
                                    ),
                                  if (s.status == 'Waiting')
                                    LessonCompleteView(
                                        BlocProvider.of<DetailLessonCubit>(cc),
                                        dataController,
                                        sessionCubit),
                                ],
                              );
                      },
                    ),
                  )))
          ],
        ),
      );
    });
  }
}
