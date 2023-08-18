import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonPendingView extends StatelessWidget {
  const LessonPendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteBeforeTeaching.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteBeforeTeaching.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 10)),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteFromSupport.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteFromSupport.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 10)),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          margin:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 250)),
          constraints: BoxConstraints(minHeight: Resizable.size(context, 50)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 1),
                    color: primaryColor)
              ]),
          child: Column(
            children: [
              Text(AppText.titleNoteFromAnotherTeacher.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 24))),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 20)),
                child: Text(
                  AppText.txtNoteFromAnotherTeacher.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Resizable.font(context, 24)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 20)),
        SubmitButton(
            onPressed: () async {
              // BlocProvider.of<DetailLessonCubit>(context)
              //     .updateStatus(context, 'Teaching');
              debugPrint('=====================> 1');
              // SharedPreferences localData =
              //     await SharedPreferences.getInstance();
              debugPrint('=====================> 2');
              // if (context.mounted) {
              //   debugPrint('=====================> 3 == ${int.parse(TextUtils.getName(position: 2))} == ${int.parse(TextUtils.getName())}');
                // await addLessonResult(
                //     context,
                //     LessonResultModel(
                //         id: 1000,
                //         classId: int.parse(TextUtils.getName(position: 2)),
                //         lessonId: int.parse(TextUtils.getName()),
                //         teacherId: int.parse(localData.getInt(PrefKeyConfigs.userId).toString()),
                //         status: 'Teaching',
                //         date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                //         noteForStudent: '',
                //         noteForSupport: '',
                //         noteForTeacher: ''));
                //debugPrint('=====================> 456789');
              // }
              await BlocProvider.of<DetailLessonCubit>(context).updateStatus(context, 'Teaching');
              // if (context.mounted) {
              //   debugPrint('=============> addLessonResult');
              //   await BlocProvider.of<DetailLessonCubit>(context).load(context);
              // }
            },
            title: AppText.txtStartLesson.text)
      ],
    );
  }

  // addLessonResult(context, LessonResultModel model) async {
  //   TeacherRepository teacherRepository = TeacherRepository.fromContext(context);
  //   debugPrint('=====================>');
  //   var check = await teacherRepository.addLessonResult(model);
  //   debugPrint('=====================> $check');
  // }
}

