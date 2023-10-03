import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/classification_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonCompleteView extends StatelessWidget {
  final DetailLessonCubit detailCubit;
  const LessonCompleteView(this.detailCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SessionCubit>(context);
    List<TextEditingController> listController = List.generate(cubit.listStudent == null ? 0 : cubit.listStudent!.length, (index) => TextEditingController()).toList();
    return
      // cubit.listStudent == null || cubit.listStudentLesson == null
      //   ? Transform.scale(
      //       scale: 0.75,
      //       child: const CircularProgressIndicator(),
      //     )
      //   :
      Column(
            children: [
              SizedBox(height: Resizable.padding(context, 10)),
              ...cubit.listStudent!
                  .map((e) => ClassificationItem(
                          e,
                          cubit.listStudentClass![cubit.listStudent!.indexOf(e)]
                              .activeStatus, listController![cubit.listStudent!.indexOf(e)],
                          firstItems: [
                            AppText.txtActiveStatus.text.toUpperCase(),
                            'A',
                            'B',
                            'C',
                            'D',
                            'E'
                          ],
                          secondItems: [
                            AppText.txtLearningStatus.text.toUpperCase(),
                            'A',
                            'B',
                            'C',
                            'D',
                            'E'
                          ]
    ))
                  .toList(),
              BlocBuilder<SessionCubit, int>(builder: (c, s){
                return Column(
                  children: [
                    NoteForTeamCard(cubit.isNoteSupport,
                        hintText: AppText.txtHintNoteForSupport.text,
                        noNote: AppText.txtNoNoteForSupport.text, onChanged: (v) {
                          cubit.isNoteSupport = v.isNotEmpty ? null : true;
                          cubit.inputSupport(v);
                          cubit.checkNoteSupport();
                        }, onPressed: () {
                          cubit.checkNoteSupport();
                        }),
                    NoteForTeamCard(cubit.isNoteSensei,
                        hintText: AppText.txtHintNoteForTeacher.text,
                        noNote: AppText.txtNoNoteForTeacher.text, onChanged: (v) {
                          cubit.isNoteSensei = v.isNotEmpty ? null : true;
                          cubit.inputSensei(v);
                          cubit.checkNoteSensei();
                        }, onPressed: () {
                          cubit.checkNoteSensei();
                        }),
                    SizedBox(height: Resizable.size(context, 40)),
                    SubmitButton(
                      onPressed: ()async{
                        waitingDialog(context);
                        await detailCubit
                            .noteForSupport( cubit.noteSupport.isNotEmpty
                            ? cubit.noteSupport
                            : '');
                        if(context.mounted) {
                          await detailCubit
                              .noteForAnotherSensei( cubit.noteSupport.isNotEmpty
                              ? cubit.noteSensei
                              : '');
                        }
                        if(context.mounted){
                          for(var std in cubit.listStudent!){
                            await updateTeacherNote(std.userId, listController[cubit.listStudent!.indexOf(std)].text);
                          }
                          SharedPreferences localData = await SharedPreferences.getInstance();
                          if(context.mounted){
                            Navigator.popUntil(context, ModalRoute.withName("${Routes.teacher}?name=${localData.getString(PrefKeyConfigs.code).toString()}/role?role=teacher/lesson/class?id=${int.parse(TextUtils.getName(position: 3))}"));
                          }
                        }
                      },
                      isActive:
                      cubit.isNoteSupport != false && cubit.isNoteSensei != false,
                      title: AppText.txtCompleteLesson.text,
                    ),
                  ],
                );
              }),

              SizedBox(height: Resizable.size(context, 100)),
            ],
          );
  }

  updateTeacherNote(int userId, String note)async{
    await FireBaseProvider.instance.updateTeacherNote(userId, int.parse(TextUtils.getName()), int.parse(TextUtils.getName(position: 3)), note);
  }
}
