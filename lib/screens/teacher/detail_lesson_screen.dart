import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_complete_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_pending_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_teaching_view.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  final DetailLessonCubit cubit;
  DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : cubit = DetailLessonCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailLessonCubit()..load(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                index: 1,
                classId: TextUtils.getName(position: 2),
                name: name,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: Resizable.padding(context, 20)),
                child: Text('${AppText.txtLesson.text} ${TextUtils.getName()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Resizable.font(context, 30))),
              ),
              BlocBuilder<DetailLessonCubit, LessonResultModel?>(
                  builder: (c, s) => s == null
                      ? Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                              child: BlocProvider(
                                  create: (c) => SessionCubit()..init(c),
                                  child: BlocBuilder<SessionCubit, int>(
                                    builder: (_, state) {
                                      return Column(
                                        children: [
                                          if (s.status == 'Pending')
                                            LessonPendingView(s),
                                          if (s.status == 'Teaching')
                                            LessonTeachingView(),
                                          if (s.status == 'Complete')
                                            LessonCompleteView(),
                                        ],
                                      );
                                    },
                                  )))))
            ],
          ),
        ));
  }
}
