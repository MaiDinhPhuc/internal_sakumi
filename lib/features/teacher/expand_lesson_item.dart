import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/list_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandLessonItem extends StatelessWidget {
  final LessonResultModel lessonResultModel;
  const ExpandLessonItem(this.lessonResultModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ListLessonCubit>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtNoteFromSupport.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 8)),
            child: Text(
                cubit
                    .listLessonResult![
                        cubit.listLessonResult!.indexOf(lessonResultModel)]
                    .noteForSupport
                    .toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 19))),
          ),
          Text(AppText.txtNoteFromAnotherTeacher.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 8)),
            child: Text(
                cubit
                    .listLessonResult![
                        cubit.listLessonResult!.indexOf(lessonResultModel)]
                    .noteForTeacher
                    .toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 19))),
          ),
          Text(AppText.titleManageStudent.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
          cubit.listStudent == null
              ? Center(
                  child: Transform.scale(
                    scale: 0.75,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...cubit.listStudent!
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                Resizable.padding(context, 2)),
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 20),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(cubit
                                            .listStudentLessons![
                                                cubit.listLessonResult!.indexOf(
                                                    lessonResultModel)]![
                                                cubit.listStudent!.indexOf(e)]
                                            .timekeeping
                                            .toString()),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(cubit
                                          .listStudentLessons![cubit
                                                  .listLessonResult!
                                                  .indexOf(lessonResultModel)]![
                                              cubit.listStudent!.indexOf(e)]
                                          .hw
                                          .toString()),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(cubit
                                          .listStudentLessons![cubit
                                                  .listLessonResult!
                                                  .indexOf(lessonResultModel)]![
                                              cubit.listStudent!.indexOf(e)]
                                          .teacherNote
                                          .toString()),
                                    ),
                                  )
                                ],
                              ))
                          .toList()
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
