import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_complete_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_pending_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/lesson_teaching_view.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  final DetailLessonCubit cubit;
  DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : cubit = DetailLessonCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SessionCubit()..init(context), child: Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
            index: 1,
            classId: TextUtils.getName(position: 2),
            name: name,
          ),
          Expanded(
              key: Key('${cubit.state?.status}'),
              child: SingleChildScrollView(
                  child: BlocBuilder<SessionCubit, int>(
                    builder: (cc, state) {
                      return BlocProvider(
                          create: (cc) => DetailLessonCubit()
                            ..addLessonResult(cc, LessonResultModel(
                                id: 1000,
                                classId: int.parse(TextUtils.getName(position: 2)),
                                lessonId: int.parse(TextUtils.getName()),
                                teacherId: BlocProvider.of<SessionCubit>(cc).teacherId,
                                status: 'Teaching',
                                date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                noteForStudent: '',
                                noteForSupport: '',
                                noteForTeacher: '')),
                          child: BlocBuilder<DetailLessonCubit,
                              LessonResultModel?>(
                            builder: (cc, s) {
                              return (s == null && cubit.check == null) ? Transform.scale(
                                scale: 0.75,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ): Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                        Resizable.padding(context, 20)),
                                    child: Text('${BlocProvider.of<DetailLessonCubit>(cc).title}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: Resizable.font(
                                                context, 30))),
                                  ),
                                  if (BlocProvider.of<DetailLessonCubit>(cc).check == true)
                                    LessonPendingView(),
                                  if (BlocProvider.of<DetailLessonCubit>(cc).check == false &&
                                      s!.status == 'Teaching')
                                    LessonTeachingView(),
                                  if (BlocProvider.of<DetailLessonCubit>(cc).check == false &&
                                      s!.status == 'Complete')
                                    LessonCompleteView(),
                                ],
                              );
                            },
                          ));
                    },
                  )))
        ],
      ),
    ));
  }
}
