import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_add_new_lesson.dart';
import 'collapse_lesson_item.dart';
import 'expand_lesson_item.dart';
import 'manage_course_cubit.dart';

class LessonItem extends StatelessWidget {
  const LessonItem(this.lesson,this.cubit, {super.key});
  final LessonModel lesson;
  final ManageCourseCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Resizable.size(context, 500),
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.only(
            left: Resizable.padding(context, 10),
            top: Resizable.padding(context, 10),bottom: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 1))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${lesson.lessonId} - ${lesson.title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Resizable.font(context, 20),
                                color: Colors.black)),
                        SizedBox(height: Resizable.padding(context, 3)),
                        Text(lesson.description,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Resizable.font(context, 15),
                                color: const Color(0xff757575)))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                        borderRadius:
                        BorderRadius.circular(Resizable.size(context, 100)),
                        onTap: (){
                          alertAddNewLesson(context,lesson,true, cubit);
                        },
                        child: Image.asset('assets/images/ic_edit.png',
                            height: Resizable.size(context, 20),
                            width: Resizable.size(context, 10))))
              ],
            ),
            BlocProvider(
                create: (context) => DropdownCubit(),
                child: BlocBuilder<DropdownCubit, int>(
                    builder: (c, state) => AnimatedCrossFade(
                        firstChild: CollapseLesson(
                          onPress: () {
                            BlocProvider.of<DropdownCubit>(c)
                                .update();
                          },
                          state: state,
                        ),
                        secondChild: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CollapseLesson(
                              onPress: () {
                                BlocProvider.of<DropdownCubit>(
                                    c)
                                    .update();
                              },
                              state: state,
                            ),
                            ExpandLessonItem(lesson: lesson, cubit: cubit)
                          ],
                        ),
                        crossFadeState: state % 2 == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration:
                        const Duration(milliseconds: 100))))
          ],
        ));
  }
}
