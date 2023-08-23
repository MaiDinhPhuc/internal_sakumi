import 'dart:typed_data';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/pick_image_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
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
      required this.onOpenFile, required this.onOpenMic, required this.type});
  final ImagePickerCubit imagePickerCubit;
  final AnswerModel answerModel;
  final DetailGradingCubit cubit;
  final TextEditingController noteController;
  final Function(String?) onChange;
  final Function() onOpenFile;
  final Function() onOpenMic;
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, List<Uint8List>>(
        bloc: imagePickerCubit..init(type == 'single' ? answerModel.listImagePicker: []),
        builder: (cc, list) {
          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: Resizable.padding(context, 5)),
                  child: InputTeacherNote(
                      noteController: noteController,
                      onChange: onChange,
                      onOpenFile: onOpenFile,
                      onOpenMic: onOpenMic)),
              list.isEmpty
                  ? Container()
                  : SizedBox(
                      height: Resizable.size(context, 250),
                      child: ListView.builder(
                        itemCount: list.length,
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
                                child: Image.memory(list[i], fit: BoxFit.fill),
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
                                        if(type == 'single'){
                                          await imagePickerCubit.removeImage(
                                              answerModel, list[i]);
                                        }else{
                                          imagePickerCubit.removeImageForAll(cubit.answers, list[i]);
                                        }
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: Resizable.size(context, 18),
                                        color: Colors.white,
                                      )))
                            ])),
                      ))
            ],
          );
        });
  }
}
