import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/detail_lesson_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/lesson_pending_view_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/lesson_teaching_view_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/lesson_waiting_view_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailLessonV2 extends StatelessWidget {
  DetailLessonV2({super.key})
      : cubit = DetailLessonCubitV2(int.parse(TextUtils.getName(position: 1)),
            int.parse(TextUtils.getName()));

  final DetailLessonCubitV2 cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
            index: 1,
            classId: TextUtils.getName(position: 1),
            role: 'teacher',
          ),
          BlocBuilder<DetailLessonCubitV2, int>(
              bloc: cubit,
              builder: (c, s) {
                return cubit.loading
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
                                      vertical: Resizable.padding(context, 20)),
                                  child: Text(cubit.lesson!.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:
                                              Resizable.font(context, 30)))),
                              if (cubit.lessonResult == null || cubit.lessonResult!.status == "Pending")
                                LessonPendingViewV2(cubit),
                              if(cubit.lessonResult != null && cubit.lessonResult!.status == "Teaching")
                                LessonTeachingViewV2(cubit),
                              if(cubit.lessonResult != null && cubit.lessonResult!.status == "Waiting")
                                LessonWaitingViewV2(cubit)
                            ],
                          ),
                        ));
              }),
        ],
      ),
    );
  }
}
