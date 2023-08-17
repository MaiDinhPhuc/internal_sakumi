import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_complete_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_pending_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_teaching_view.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailLessonScreen extends StatelessWidget {
  final String name, classId, lessonId;
  final DetailLessonCubit cubit;
  late SharedPreferences localData;
  DetailLessonScreen(this.name, this.classId, this.lessonId, {Key? key})
      : cubit = DetailLessonCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) async{
    //  localData = await SharedPreferences.getInstance();
    // });
    return BlocProvider(
        create: (context) => DetailLessonCubit(),
        //   ..addLessonResult(
        // context,
        // LessonResultModel(
        //     id: 1000,
        //     classId: int.parse(TextUtils.getName(position: 2)),
        //     lessonId: int.parse(TextUtils.getName()),
        //     teacherId: int.parse(localData.getInt(PrefKeyConfigs.userId).toString()),
        //     status: 'Teaching',
        //     date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        //     noteForStudent: 'noteForStudent',
        //     noteForSupport: 'noteForSupport',
        //     noteForTeacher: 'noteForTeacher')),
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
                  builder: (c, s){
                    var cubit = BlocProvider.of<DetailLessonCubit>(c);
                    return Expanded(
                        child: SingleChildScrollView(
                            child: BlocProvider(
                                create: (c) => SessionCubit()..init(c),
                                child: BlocBuilder<SessionCubit, int>(
                                  builder: (_, state) {
                                    return Column(
                                      children: [
                                        s == null? LessonPendingView() : (s.status == 'Teaching')
                                            ? LessonTeachingView() :
                                        LessonCompleteView(),
                                      ],
                                    );
                                  },
                                ))));
                  })
            ],
          ),
        ));
  }
}
