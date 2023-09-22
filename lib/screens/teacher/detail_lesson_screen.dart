import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_complete_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_pending_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_teaching_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  const DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SessionCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                index: 1,
                classId: TextUtils.getName(position: 3),
                name: name,
                role: 'teacher',
              ),
              Expanded(
                  //key: Key('${cubit.state?.status}'),
                  child: SingleChildScrollView(
                      child: BlocProvider(
                          create: (context) => DetailLessonCubit()
                            ..checkLessonResult(),
                          child: BlocBuilder<DetailLessonCubit,
                              LessonResultModel?>(
                            builder: (cc, s) {
                              debugPrint('==============> lesson detail ${BlocProvider.of<DetailLessonCubit>(
                                  cc)
                                  .state?.status}');
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
                                        vertical: Resizable.padding(
                                            context, 20)),
                                    child: Text(
                                        '${BlocProvider.of<DetailLessonCubit>(cc).title}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: Resizable.font(
                                                context, 30))),
                                  ),
                                  if (s.status == 'Pending')
                                    LessonPendingView(BlocProvider.of<DetailLessonCubit>(
                                        cc)),
                                  if (s.status == 'Teaching')
                                    const LessonTeachingView(),
                                  if (s.status == 'Complete')
                                    LessonCompleteView(BlocProvider.of<DetailLessonCubit>(
                                        cc)),
                                ],
                              );
                            },
                          ))))
            ],
          ),
        ));
  }
}
