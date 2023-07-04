import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/header_teacher.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ListLessonScreen extends StatelessWidget {
  final String name;
  final String classId;

  const ListLessonScreen(this.name, this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListLessonCubit()..load(),
      child: Scaffold(
        body: Column(
          children: [
            HeaderTeacher(),
            BlocBuilder<ListLessonCubit, int>(builder: (c, s) {
              var cubit = BlocProvider.of<ListLessonCubit>(c);
              return s == 0
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: SingleChildScrollView(
                      child: Column(
                        children: [
                          cubit.classModel == null
                              ? const CircularProgressIndicator()
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 20)),
                                  child: Text(
                                      '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:
                                              Resizable.font(context, 30))),
                                ),
                          ...cubit.listLesson!.map((e) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 200),
                                    vertical: Resizable.padding(context, 5)),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              Resizable.size(context, 35)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 20),
                                          vertical:
                                              Resizable.padding(context, 10)),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(0,
                                                    Resizable.size(context, 2)),
                                                blurRadius:
                                                    Resizable.size(context, 1))
                                          ],
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(1000)),
                                      child: cubit.lessons == null ||
                                              cubit.lessons!.isEmpty
                                          ? Center(
                                              child: SizedBox(
                                                height:
                                                    Resizable.font(context, 20),
                                                width:
                                                    Resizable.font(context, 20),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: Resizable.size(
                                                      context, 1),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              cubit
                                                  .lessons![cubit.listLesson!
                                                      .indexOf(e)]
                                                  .title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: Resizable.font(
                                                      context, 20)),
                                            ),
                                    ),
                                    Positioned.fill(
                                        child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              "teacher?name=$name/class?id=${e.classId}/lesson?id=${e.lessonId}");
                                        },
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                      ),
                                    ))
                                  ],
                                ),
                              ))
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

class ListLessonCubit extends Cubit<int> {
  ListLessonCubit() : super(0);

  List<LessonResultModel>? listLesson;

  ClassModel? classModel;

  List<LessonModel>? lessons;

  void load() {
    loadLessonResult();
    loadClass();
  }

  void loadLessonResult() async {
    debugPrint("===============loadLessonResult");
    listLesson = await TeacherRepository.getLessonResultByClassId(
        int.parse(TextUtils.getName()));

    debugPrint("=========><-----------${listLesson!.length}");
    lessons = [];
    for (var i in listLesson!) {
      lessons!.add(await TeacherRepository.getLessonByLessonId(i.lessonId));
      debugPrint("==========....========== ${lessons!.length}");
    }

    emit(state + 1);
  }

  loadClass() async {
    classModel =
        await TeacherRepository.getClassById(int.parse(TextUtils.getName()));
    emit(state + 1);
  }
}
