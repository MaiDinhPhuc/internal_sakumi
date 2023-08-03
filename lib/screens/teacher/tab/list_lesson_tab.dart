import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/collapse_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/expand_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ListLessonTab extends StatelessWidget {
  final String name;
  final String classId;
  //final ListLessonCubit cubit;

  ListLessonTab(this.name, this.classId, {Key? key}) : //cubit = ListLessonCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ListLessonCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                  index: 1,
                  classId: TextUtils.getName(position: 2),
                  name: name),
              BlocBuilder<ListLessonCubit, int>(
                //bloc: ListLessonCubit()..init(context),
                  builder: (c, s) {
                var cubit = BlocProvider.of<ListLessonCubit>(c);
                return cubit.classModel == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                  key: Key('aa ${cubit.listLessonResult?.first.status}'),
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
                            cubit.listLessonResult == null
                                ? Transform.scale(
                                    scale: 0.75,
                                    child: const CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      ...cubit.listLessonResult!.map((e) =>
                                          Container(
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
                                                  builder: (c, state) => Stack(
                                                    children: [
                                                      Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Resizable.padding(
                                                                      context, 20),
                                                              vertical: Resizable.padding(
                                                                  context, 8)),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: Resizable.size(
                                                                      context, 1.5),
                                                                  color: greyColor
                                                                      .shade100),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Resizable.size(context, 5))),
                                                          child: cubit.lessons == null || cubit.lessons!.isEmpty
                                                              ? Transform.scale(
                                                                  scale: 0.75,
                                                                  child:
                                                                      const CircularProgressIndicator(),
                                                                )
                                                              : AnimatedCrossFade(
                                                                  firstChild: CollapseLessonItem(e),
                                                                  secondChild: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CollapseLessonItem(
                                                                          e),
                                                                      ExpandLessonItem(
                                                                          e),
                                                                    ],
                                                                  ),
                                                                  crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                  duration: const Duration(milliseconds: 100))),
                                                      Positioned.fill(
                                                          child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                            onTap: e.status != 'Finished' ? () async{
                                                              var result = await  Navigator.pushNamed(
                                                                  context,
                                                                  "/teacher?name=$name/lesson/class?id=${e.classId}/lesson?id=${e.lessonId}");
                                                              if(result != null && c.mounted){
                                                                cubit.loadLessonResult(c);
                                                              }
                                                            } : (){
                                                              //TODO navigate to detail grading
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Resizable.size(
                                                                        context,
                                                                        5))),
                                                      )),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: Resizable
                                                                .padding(
                                                                    context,
                                                                    10),
                                                            top: Resizable
                                                                .padding(
                                                                    context,
                                                                    8)),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              cubit.loadStudent(
                                                                  c);
                                                              BlocProvider.of<
                                                                      DropdownCubit>(c)
                                                                  .update();
                                                            },
                                                            splashRadius:
                                                                Resizable.size(
                                                                    context,
                                                                    15),
                                                            icon: Icon(
                                                              state % 2 == 0
                                                                  ? Icons
                                                                      .keyboard_arrow_down
                                                                  : Icons
                                                                      .keyboard_arrow_up,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ))
                                    ],
                                  )
                          ],
                        ),
                      ));
              }),
            ],
          ),
        ));
  }
}
