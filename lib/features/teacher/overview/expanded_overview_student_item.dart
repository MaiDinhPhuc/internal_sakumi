import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandedOverviewStudentItem extends StatelessWidget {
  final StudentClassModel stdClass;
  const ExpandedOverviewStudentItem(this.stdClass, {Key? key, required this.cubit}) : super(key: key);
  final ClassOverviewCubit cubit;
  @override
  Widget build(BuildContext context) {
    int index = cubit.listStdClass!.indexOf(stdClass);
    return Column(
            children: [
              Container(
                height: Resizable.size(context, 0.5),
                width: double.maxFinite,
                color: const Color(0xffE0E0E0),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              for (int i = 0; i<cubit.listStdDetail[index]["attendance"].length; i++)
                BlocProvider(
                    create: (context) => DropdownCubit(),
                    child: BlocBuilder<DropdownCubit, int>(
                      builder: (c, state) => Container(
                          margin: EdgeInsets.only(
                              left: Resizable.padding(context, 25),
                              right: Resizable.padding(context, 25),
                              bottom: Resizable.padding(context, 10)),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 15),
                              vertical: Resizable.padding(context, 5)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: Resizable.size(context, 0.5),
                                  color: state % 2 == 0
                                      ? greyColor.shade100
                                      : Colors.black),
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 5))),
                          child: AnimatedCrossFade(
                              firstChild: CollapseLearnedLesson(cubit.listStdDetail[index]["title"][i], cubit.listStdDetail[index]["attendance"][i], cubit.listStdDetail[index]["hw"][i]),
                              secondChild: Column(
                                children: [
                                  CollapseLearnedLesson(cubit.listStdDetail[index]["title"][i], cubit.listStdDetail[index]["attendance"][i], cubit.listStdDetail[index]["hw"][i]),
                                  ExpandLearnedLesson(cubit.listStdDetail[index]["spNote"][i], cubit.listStdDetail[index]["teacherNote"][i])
                                ],
                              ),
                              crossFadeState: state % 2 == 1
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration:
                              const Duration(milliseconds: 100))),
                    ))
            ],
          );
  }
}

class CollapseLearnedLesson extends StatelessWidget {
  final String title;
  final int attend;
  final double? hw;
  const CollapseLearnedLesson(this.title, this.attend,this.hw, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(
                    context, 18)))),
        Expanded(
            flex: 8,
            child: Row(
          children: [
            Expanded(
                flex:4,
                child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minWidth: Resizable.size(context, 100)
              ),
              decoration: BoxDecoration(
                  color: attend == 5 ? const Color(0xffF57F17) : attend == 6? const Color(0xffB71C1C) : attend == 0 ? const Color(0xff757575) : const Color(0xff33691E),
                  borderRadius:
                  BorderRadius.circular(
                      1000)),
              margin: EdgeInsets.only(
                  right: Resizable.padding(
                      context, 20)),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(
                      context, 3)),
              child: Text(
                  attend == 5 ? AppText.txtPermitted.text : attend == 6? AppText.txtAbsent.text : attend == 0 ? AppText.txtNoAttendance.text : AppText.txtPresent.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: Resizable.font(
                          context, 16))),
            )),
            Expanded(
                flex:4,
                child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minWidth: Resizable.size(context, 100)
              ),
              decoration: BoxDecoration(
                  color: hw == -2 ? const Color(0xffB71C1C) : hw == -1 ? const Color(0xffF57F17) : hw == null ? const Color(0xff757575) : const Color(0xff33691E),
                  borderRadius:
                  BorderRadius.circular(
                      1000)),
              margin: EdgeInsets.only(
                  right: Resizable.padding(
                      context, 20)),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(
                      context, 3)),
              child: Text(
                  hw == -2 ? AppText.txtNotSubmit.text : hw == -1 ?  AppText.textNotMarked.text: hw == null ? AppText.txtNull.text : hw.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: Resizable.font(
                          context, 16))),
            )),
            Expanded(
                flex:5,
                child: Container()),
            Expanded(
                flex:1,
                child: IconButton(
                onPressed: () {
                  BlocProvider.of<
                      DropdownCubit>(context)
                      .update();
                },
                splashRadius:
                Resizable.size(context, 15),
                icon: Icon(
                  BlocProvider.of<
                      DropdownCubit>(context).state % 2 == 0
                      ? Icons
                      .keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                )))
          ],
        ))
      ],
    );
  }
}

class ExpandLearnedLesson extends StatelessWidget {
  final String spNote;
  final String ssNote;
  const ExpandLearnedLesson(this.spNote,this.ssNote, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
        margin: EdgeInsets.only(
          top: Resizable.padding(context, 5),
            bottom: Resizable.padding(context, 15)),
        height: Resizable.size(context, 0.5),
        width: double.maxFinite,
        color: const Color(0xffE0E0E0),
      ),
        Text(AppText.titleNoteFromAnotherTeacher.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
          margin:
          EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
          constraints: BoxConstraints(
            minHeight: Resizable.size(context, 30)
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: greyColor.shade50,
              borderRadius:
              BorderRadius.circular(Resizable.padding(context, 5))),
          child: Text(
            ssNote, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Resizable.font(context, 19))
          )
        ),
        Text(AppText.titleNoteFromSupport.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
            margin:
            EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
            constraints: BoxConstraints(
                minHeight: Resizable.size(context, 30)
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: greyColor.shade50,
                borderRadius:
                BorderRadius.circular(Resizable.padding(context, 5))),
            child: Text(
                spNote, style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Resizable.font(context, 19))
            )
        ),
      ],
    );
  }
}
