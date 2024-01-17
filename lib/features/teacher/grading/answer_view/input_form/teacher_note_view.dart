import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/pick_image_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/teacher_record_view.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/voice_record_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'input_teacher_note.dart';

class TeacherNoteView extends StatelessWidget {
  const TeacherNoteView(
      {super.key,
      required this.imagePickerCubit,
      required this.answerModel,
      required this.cubit,
      required this.noteController,
      required this.onChange,
      required this.onOpenFile,
      required this.onOpenMic,
      required this.type,
      required this.checkActiveCubit,
      required this.voiceRecordCubit,
      required this.soundCubit});
  final ImagePickerCubit imagePickerCubit;
  final VoiceRecordCubit voiceRecordCubit;
  final AnswerModel answerModel;
  final DetailGradingCubit cubit;
  final TextEditingController noteController;
  final Function(String?) onChange;
  final Function() onOpenFile;
  final Function() onOpenMic;
  final String type;
  final CheckActiveCubit checkActiveCubit;
  final SoundCubit soundCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: Resizable.padding(context, 5)),
            child: InputTeacherNote(
                noteController: noteController,
                onChange: onChange,
                onOpenFile: onOpenFile,
                onOpenMic: onOpenMic)),
        BlocBuilder<ImagePickerCubit, List<dynamic>>(
            bloc: imagePickerCubit
              ..init(type == 'single' ? answerModel.listImagePicker : []),
            builder: (cc, listImage) => listImage.isEmpty
                ? Container()
                : SizedBox(
                    height: Resizable.size(context, 250),
                    child: ListView.builder(
                      itemCount: listImage.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      itemBuilder: (_, i) => Padding(
                          padding: EdgeInsets.only(
                              right: Resizable.padding(context, 10)),
                          child:
                              Stack(alignment: Alignment.topRight, children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 10)),
                              child: answerModel.checkIsUrl(listImage[i])
                                  ? ImageNetwork(
                                      fitWeb: BoxFitWeb.fill,
                                      image: listImage[i],
                                      height: Resizable.size(context, 250),
                                      width: Resizable.size(context, 200),
                                    )
                                  : Image.memory(listImage[i],
                                      fit: BoxFit.fill),
                            ),
                            Container(
                                height: Resizable.size(context, 20),
                                width: Resizable.size(context, 25),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          Resizable.size(context, 10)),
                                      bottomLeft: Radius.circular(
                                          Resizable.size(context, 10))),
                                ),
                                child: GestureDetector(
                                    onTap: () async {
                                      if (type == 'single') {
                                        await imagePickerCubit.removeImage(
                                            answerModel,
                                            listImage[i],
                                            checkActiveCubit,
                                            cubit);
                                      } else {
                                        imagePickerCubit.removeImageForAll(
                                            cubit.answers,
                                            listImage[i],
                                            checkActiveCubit,
                                            cubit);
                                      }
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: Resizable.size(context, 18),
                                      color: Colors.white,
                                    )))
                          ])),
                    ))),
        BlocBuilder<VoiceRecordCubit, List<dynamic>>(
            bloc: voiceRecordCubit
              ..init(type == 'single' ? answerModel.listRecordUrl : []),
            builder: (cc, listRecord) => listRecord.isEmpty
                ? Container()
                : Column(
                    children: [
                      ...listRecord.map((e) => Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        right: Resizable.padding(context, 350)),
                                    child: TeacherSounder(
                                      e,
                                      "network",
                                      listRecord.indexOf(e),
                                      soundCubit: soundCubit,
                                      backgroundColor: primaryColor,
                                      iconColor: Colors.white,
                                      onDelete: () async {
                                        if (type == 'single') {
                                          await voiceRecordCubit.removeRecord(
                                              answerModel,
                                              e,
                                              checkActiveCubit,
                                              cubit);
                                        } else {
                                          voiceRecordCubit.removeRecordForAll(
                                              cubit.answers,
                                              e,
                                              checkActiveCubit,
                                              cubit);
                                        }
                                      },
                                    )),
                              )
                            ],
                          ))
                    ],
                  ))
      ],
    );
  }
}

class TeacherNoteViewV2 extends StatelessWidget {
  const TeacherNoteViewV2(
      {super.key,
        required this.imagePickerCubit,
        required this.answerModel,
        required this.cubit,
        required this.noteController,
        required this.onChange,
        required this.onOpenFile,
        required this.onOpenMic,
        required this.type,
        required this.checkActiveCubit,
        required this.voiceRecordCubit,
        required this.soundCubit});
  final ImagePickerCubit imagePickerCubit;
  final VoiceRecordCubit voiceRecordCubit;
  final AnswerModel answerModel;
  final DetailGradingCubitV2 cubit;
  final TextEditingController noteController;
  final Function(String?) onChange;
  final Function() onOpenFile;
  final Function() onOpenMic;
  final String type;
  final CheckActiveCubit checkActiveCubit;
  final SoundCubit soundCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: Resizable.padding(context, 5)),
            child: InputTeacherNote(
                noteController: noteController,
                onChange: onChange,
                onOpenFile: onOpenFile,
                onOpenMic: onOpenMic)),
        BlocBuilder<ImagePickerCubit, List<dynamic>>(
            bloc: imagePickerCubit
              ..init(type == 'single' ? answerModel.listImagePicker : []),
            builder: (cc, listImage) => listImage.isEmpty
                ? Container()
                : SizedBox(
                height: Resizable.size(context, 250),
                child: ListView.builder(
                  itemCount: listImage.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 5)),
                  itemBuilder: (_, i) => Padding(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 10)),
                      child:
                      Stack(alignment: Alignment.topRight, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 10)),
                          child: answerModel.checkIsUrl(listImage[i])
                              ? ImageNetwork(
                            fitWeb: BoxFitWeb.fill,
                            image: listImage[i],
                            height: Resizable.size(context, 250),
                            width: Resizable.size(context, 200),
                          )
                              : Image.memory(listImage[i],
                              fit: BoxFit.fill),
                        ),
                        Container(
                            height: Resizable.size(context, 20),
                            width: Resizable.size(context, 25),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      Resizable.size(context, 10)),
                                  bottomLeft: Radius.circular(
                                      Resizable.size(context, 10))),
                            ),
                            child: GestureDetector(
                                onTap: () async {
                                  if (type == 'single') {
                                    await imagePickerCubit.removeImageV2(
                                        answerModel,
                                        listImage[i],
                                        checkActiveCubit,
                                        cubit);
                                  } else {
                                    imagePickerCubit.removeImageForAllV2(
                                        cubit.answers,
                                        listImage[i],
                                        checkActiveCubit,
                                        cubit);
                                  }
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  size: Resizable.size(context, 18),
                                  color: Colors.white,
                                )))
                      ])),
                ))),
        BlocBuilder<VoiceRecordCubit, List<dynamic>>(
            bloc: voiceRecordCubit
              ..init(type == 'single' ? answerModel.listRecordUrl : []),
            builder: (cc, listRecord) => listRecord.isEmpty
                ? Container()
                : Column(
              children: [
                ...listRecord.map((e) => Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(
                              right: Resizable.padding(context, 350)),
                          child: TeacherSounder(
                            e,
                            "network",
                            listRecord.indexOf(e),
                            soundCubit: soundCubit,
                            backgroundColor: primaryColor,
                            iconColor: Colors.white,
                            onDelete: () async {
                              if (type == 'single') {
                                await voiceRecordCubit.removeRecordV2(
                                    answerModel,
                                    e,
                                    checkActiveCubit,
                                    cubit);
                              } else {
                                voiceRecordCubit.removeRecordForAllV2(
                                    cubit.answers,
                                    e,
                                    checkActiveCubit,
                                    cubit);
                              }
                            },
                          )),
                    )
                  ],
                ))
              ],
            ))
      ],
    );
  }
}