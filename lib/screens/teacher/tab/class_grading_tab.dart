import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ClassGradingTab extends StatelessWidget {
  const ClassGradingTab(this.name, {super.key});
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GradingCubit()..init(context),
      child: Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
                index: 3, classId: TextUtils.getName(position: 2), name: name),
            BlocBuilder<GradingCubit, int>(builder: (c, s) {
              var cubit = BlocProvider.of<GradingCubit>(c);
              if(cubit.classModel == null){
                return Transform.scale(
                  scale: 0.75,
                  child: const CircularProgressIndicator(),
                );
              }
              return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 20)),
                          child: Text(
                              '${AppText.textClass.text} ${cubit.classModel!.classCode}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 30))),
                        ),
                        cubit.listLessonResult == null || cubit.listResultCount == null || cubit.listStudentLessons == null || cubit.lessons == null ? Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ) : Column(
                          children: [
                            ...cubit.listLessonResult!.map((e) =>
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Resizable.padding(
                                          context, 80),
                                      vertical: Resizable.padding(
                                          context, 5)),
                                  child: Stack(
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment : CrossAxisAlignment.start,
                                                children: [
                                                  Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 10) ),child: Text(cubit.lessons![cubit.lessons!.indexWhere((element) => e.lessonId == element.lessonId)].title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: Resizable.font(context, 30),),),
                                                  ),
                                                  Text(cubit.lessons![cubit.lessons!.indexWhere((element) => e.lessonId == element.lessonId)].description.replaceAll("|", "\n"),style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))),
                                                  Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 5)),child: RichText(text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: AppText.textNumberNotGrading.text,
                                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))
                                                        ),
                                                        TextSpan(
                                                            text: " ${cubit.listResultCount![cubit.lessons!.indexWhere((element) => e.lessonId == element.lessonId)]}",
                                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.padding(context, 20), color: primaryColor)
                                                        )
                                                      ]
                                                  )))
                                                ],
                                              )),
                                              if(cubit.listResultCount![cubit.lessons!.indexWhere((element) => e.lessonId == element.lessonId)]!=0)
                                                Expanded(child: Column(
                                                mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment :CrossAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: ()async{
                                                      await Navigator.pushNamed(context,
                                                          "${Routes.teacher}?name=$name/grading/class?id=${TextUtils.getName(position: 2)}/lesson?id=${e.lessonId}");
                                                    },
                                                    style: ButtonStyle(
                                                        shadowColor: MaterialStateProperty.all(
                                                            primaryColor ),
                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(Resizable.padding(context, 1000)))),
                                                        backgroundColor: MaterialStateProperty.all(
                                                            primaryColor ),
                                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                            horizontal: Resizable.padding(context, 30)))),
                                                    child: Text(AppText.titleGrading.text.toUpperCase(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: Resizable.font(context, 16),
                                                            color: Colors.white)),
                                                  )
                                                ],
                                              ))
                                            ],
                                          )),
                                    ],
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
