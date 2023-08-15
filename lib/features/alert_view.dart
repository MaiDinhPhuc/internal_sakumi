import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

void alertView(BuildContext context, String note) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(Resizable.padding(context, 20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppText.titleNoteForSenseiAfterTeach.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 15)),
                    child: Text(
                      AppText.txtNoteForSenseiAfterTeach.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 15)),
                    child: Text(
                      AppText.txtQuestionForSenseiAfterTeach.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        Resizable.padding(context, 1000)))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal:
                                        Resizable.padding(context, 30)))),
                        child: Text(AppText.txtBack.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 16),
                                color: Colors.black)),
                      ),
                      SubmitButton(
                          onPressed: () {
                            BlocProvider.of<DetailLessonCubit>(context)
                                .updateStatus(context, 'Complete');
                            BlocProvider.of<DetailLessonCubit>(context)
                                .noteForStudents(context, note);
                            Navigator.pop(context);
                          },
                          title: AppText.txtAgree.text)
                    ],
                  )
                ],
              ),
            ));
      });
}
