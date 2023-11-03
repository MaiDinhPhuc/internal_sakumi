import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ClassGradingTab extends StatelessWidget {
  ClassGradingTab({super.key}) : cubit = GradingCubit();
  final GradingCubit cubit;


  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    final shimmerList = List.generate(10, (index) => index);
    return BlocBuilder<DataCubit, int>(builder: (c, classes){
      return Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
                index: 3, classId: TextUtils.getName(), role: 'teacher'),
            dataController.classes == null
                ? Center(
              child: Transform.scale(
                scale: 0.75,
                child: const CircularProgressIndicator(),
              ),
            )
                :BlocBuilder<GradingCubit, int>(
                bloc: cubit
                  ..load(dataController.classes!.firstWhere((e) =>
                  e.classModel.classId ==
                      int.parse(TextUtils.getName()))),
                builder: (c, s) {
              return cubit.classModel == null
                  ? Transform.scale(
                scale: 0.75,
                child: const CircularProgressIndicator(),
              )
                  :  Expanded(child: SingleChildScrollView(
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
                    cubit.listLessonResult == null
                        ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor:
                      Colors.grey[100]!,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...shimmerList.map((e) => Padding(
                                  padding: EdgeInsets
                                      .symmetric(
                                      horizontal: Resizable
                                          .padding(
                                          context,
                                          150)),
                                  child:
                                  const ItemShimmer()))
                            ],
                          )),
                    )
                        :Column(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(
                            context, 80)),child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                flex:25,
                                child: Container()),
                            Expanded(
                                flex:4,
                                child: BlocProvider(
                                  create: (context) => DropdownGradingCubit(AppText.titleHomework.text),
                                  child: BlocBuilder<DropdownGradingCubit, String>(
                                    builder: (cc, state) {
                                      return DropDownGrading(
                                          items: [
                                            AppText.titleHomework.text,
                                            AppText.txtTest.text,
                                          ],
                                          onChanged: (item) {
                                            if(item == AppText.titleHomework.text){
                                              cubit.isBTVN = true;
                                            }else if(item == AppText.txtTest.text){
                                              cubit.isBTVN = false;
                                            }
                                            BlocProvider.of<DropdownGradingCubit>(cc)
                                                .change(item!);
                                            cubit.update();
                                          },
                                          value: state);
                                    },
                                  ),
                                )),
                            Expanded(
                                flex:1,
                                child: Container()),
                            Expanded(
                                flex:4,
                                child: BlocProvider(
                                  create: (context) => DropdownGradingCubit(AppText.textNotMarked.text),
                                  child: BlocBuilder<DropdownGradingCubit, String>(
                                    builder: (ccc, ss) {
                                      return DropDownGrading(
                                          items: [
                                            AppText.textNotMarked.text,
                                            AppText.textMarked.text,
                                          ],
                                          onChanged: (item) {
                                            if(item == AppText.textNotMarked.text){
                                              cubit.isNotGrading = true;
                                            }else if(item == AppText.textMarked.text){
                                              cubit.isNotGrading = false;
                                            }

                                            BlocProvider.of<DropdownGradingCubit>(ccc)
                                                .change(item!);
                                            cubit.update();
                                          },
                                          value: ss);
                                    },
                                  ),
                                ))
                          ],
                        )),
                        if(cubit.isBTVN)
                          ...cubit.filterListLesson().map((e) => Container(
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
                                                          text: AppText.textNumberResultReceive.text,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))
                                                      ),
                                                      TextSpan(
                                                          text: " ${cubit.getBTVNResultCount(e.lessonId, 1)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.padding(context, 20), color: primaryColor)
                                                      )
                                                    ]
                                                ))),
                                                Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 5)),child: RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: AppText.textNumberNotGrading.text,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))
                                                      ),
                                                      TextSpan(
                                                          text: " ${cubit.getBTVNResultCount(e.lessonId, 0)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.padding(context, 20), color: primaryColor)
                                                      )
                                                    ]
                                                )))
                                              ],
                                            )),
                                        Expanded(child: Column(
                                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment :CrossAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: ()async{
                                                await Navigator.pushNamed(context,
                                                    "${Routes.teacher}/grading/class=${TextUtils.getName()}/type=btvn/parent=${e.lessonId}");
                                              },
                                              style: ButtonStyle(
                                                  shadowColor: MaterialStateProperty.all(
                                                      cubit.getBTVNResultCount(e.lessonId, 0) == 0? greenColor: primaryColor ),
                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(Resizable.padding(context, 1000)))),
                                                  backgroundColor: MaterialStateProperty.all(
                                                      cubit.getBTVNResultCount(e.lessonId, 0) == 0 ? greenColor :primaryColor ),
                                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                      horizontal: Resizable.padding(context, 30)))),
                                              child: Text(cubit.getBTVNResultCount(e.lessonId, 0) == 0? AppText.textDetail.text : AppText.titleGrading.text.toUpperCase(),
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
                          )),
                        if(!cubit.isBTVN)
                          ...cubit.filterListTest().map((e) => Container(
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
                                                Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 10) ),child: Text(cubit.tests![cubit.tests!.indexWhere((element) => e.testId == element.id)].title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: Resizable.font(context, 30))),
                                                ),
                                                Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 5)),child: RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: AppText.textNumberResultReceive.text,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))
                                                      ),
                                                      TextSpan(
                                                          text: " ${cubit.getTestResultCount(e.testId,1)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.padding(context, 20), color: primaryColor)
                                                      )
                                                    ]
                                                ))),
                                                Padding(padding: EdgeInsets.symmetric(vertical:Resizable.padding(context, 5)),child: RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: AppText.textNumberNotGrading.text,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: Resizable.padding(context, 16))
                                                      ),
                                                      TextSpan(
                                                          text: " ${cubit.getTestResultCount(e.testId,0)}",
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.padding(context, 20), color: primaryColor)
                                                      )
                                                    ]
                                                )))
                                              ],
                                            )),
                                        Expanded(child: Column(
                                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment :CrossAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: ()async{
                                                await Navigator.pushNamed(context,
                                                    "${Routes.teacher}/grading/class=${TextUtils.getName()}/type=test/parent=${e.testId}");
                                              },
                                              style: ButtonStyle(
                                                  shadowColor: MaterialStateProperty.all(
                                                      cubit.getTestResultCount(e.testId, 0) == 0? greenColor: primaryColor ),
                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(Resizable.padding(context, 1000)))),
                                                  backgroundColor: MaterialStateProperty.all(
                                                      cubit.getTestResultCount(e.testId, 0) == 0 ? greenColor :primaryColor ),
                                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                      horizontal: Resizable.padding(context, 30)))),
                                              child: Text(cubit.getTestResultCount(e.testId, 0) == 0? AppText.textDetail.text : AppText.titleGrading.text.toUpperCase(),
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
      );
    });
  }
}
