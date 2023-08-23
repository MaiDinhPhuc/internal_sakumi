import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/pick_image_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/sound_view.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'image_view.dart';
import 'input_form/input_teacher_note.dart';
import 'only_text_view.dart';

class AnswerInfoView extends StatelessWidget {
  const AnswerInfoView(
      {super.key,
      required this.answerModel,
      required this.soundCubit,
      required this.cubit});
  final AnswerModel answerModel;
  final SoundCubit soundCubit;
  final DetailGradingCubit cubit;

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController =
        TextEditingController(text: answerModel.newTeacherNote);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cubit.isShowName)
            Container(
              margin: EdgeInsets.only(bottom: Resizable.padding(context, 1)),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 4),
                  horizontal: Resizable.padding(context, 40)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Resizable.size(context, 5)),
                      topRight: Radius.circular(Resizable.size(context, 5))),
                  color: Colors.white),
              child: Text(
                cubit.getStudentName(answerModel),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 18)),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Resizable.padding(context, 10),
                horizontal: Resizable.padding(context, 10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Resizable.size(context, 5)),
                  bottomRight: Radius.circular(Resizable.size(context, 5)),
                  bottomLeft: Radius.circular(Resizable.size(context, 5)),
                ),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    answerModel.answer.isEmpty
                        ? Expanded(
                        flex: 7,
                        child: Text(
                          AppText.textStudentNotDo.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : Expanded(
                        flex: 7,
                        child: (answerModel.questionType == 1 ||
                            answerModel.questionType == 5 ||
                            answerModel.questionType == 6 ||
                            answerModel.questionType == 7 ||
                            answerModel.questionType == 8)
                            ? OnlyTextView(
                          answer: answerModel,
                        )
                            : (answerModel.questionType == 4 ||
                            answerModel.questionType == 2 ||
                            answerModel.questionType == 11)
                            ? ImageView(answer: answerModel)
                            : SoundView(
                            answer: answerModel,
                            soundCubit: soundCubit)),
                    Expanded(
                        key: Key(
                            "${answerModel.questionId}_${answerModel.studentId}"),
                        flex: 2,
                        child: BlocProvider(
                          create: (context) => DropdownGradingCubit(cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore == -1
                              ? AppText.textGradingScale.text
                              : cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore.toString()),
                          child: BlocBuilder<DropdownGradingCubit, String>(
                            builder: (c, s) {
                              return DropDownGrading(
                                  items: [
                                    AppText.textGradingScale.text,
                                    "1",
                                    "2",
                                    "3",
                                    "4",
                                    "5",
                                    "6",
                                    "7",
                                    "8",
                                    "9",
                                    "10",
                                  ],
                                  onChanged: (item) {
                                    if (item != AppText.textGradingScale.text) {
                                      BlocProvider.of<DropdownGradingCubit>(c).change(item!);
                                      cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore = int.parse(item);
                                    } else {
                                      BlocProvider.of<DropdownGradingCubit>(c).change(item!);
                                      cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore = -1;
                                    }
                                  },
                                  value: s);
                            },
                          ),
                        ))
                  ],
                ),
                if (!cubit.isGeneralComment)
                  ...[
                    Padding(
                        padding:
                        EdgeInsets.only(top: Resizable.padding(context, 5)),
                        child: InputTeacherNote(
                            key: Key("${answerModel.studentId}_${answerModel.questionId}"),
                            noteController:  noteController,
                            onChange: (String? text) {
                              if(text!=null){
                                cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)].newTeacherNote = text;
                              }
                            },
                            onOpenFile: () async{
                              await pickImage(answerModel);
                              print(answerModel.listImagePicker.length);
                            },
                            onOpenMic: () {
                              print("============>open mic");
                            })),
                    BlocProvider(create: (context)=>ImagePickerCubit(answerModel.listImagePicker), child: BlocBuilder<ImagePickerCubit, List<Uint8List>>(
                      builder: (c,list){
                        if(list.isEmpty){
                          return Container();
                        }
                        return SizedBox(
                            height: Resizable.size(context, 250),
                            child: ListView.builder(
                              itemCount: list.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                  Resizable.padding(context, 5)),
                              itemBuilder: (_, i) => Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                      Resizable.padding(context, 10)),
                                  child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Image.memory(answerModel.listImagePicker.first, fit: BoxFit.fill, height: 100,width: 100),
                                        Container(
                                            height: Resizable.size(
                                                context, 40),
                                            width: Resizable.size(
                                                context, 30),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                  Radius.circular(
                                                      Resizable.size(
                                                          context,
                                                          30)),
                                                  bottomLeft:
                                                  Radius.circular(
                                                      Resizable.size(
                                                          context,
                                                          30))),
                                            ),
                                            child: GestureDetector(
                                                onTap: (){},
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  size: Resizable.size(
                                                      context, 18),
                                                  color: Colors.white,
                                                )))
                                      ])),
                            )) ;
                      },
                    ),)
                  ]
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> pickImage(AnswerModel answerModel)async{
  if(kIsWeb){
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var f = await image.readAsBytes();
      answerModel.listImagePicker.add(f);
    }
  }
}
