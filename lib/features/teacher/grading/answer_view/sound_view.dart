import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sounder.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SoundView extends StatelessWidget {
  const SoundView({super.key, required this.answer, required this.soundCubit});
  final AnswerModel answer;
  final SoundCubit soundCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),child: Text(
          AppText
              .textStudentAnswer.text,
          style: TextStyle(
            fontSize: Resizable.font(
                context, 18),
            fontWeight: FontWeight.w700,
          ),
        )),
        ...answer.convertAnswer.map(
              (e) =>Sounder(
                e,
                "network",answer.convertAnswer.indexOf(e),
                soundCubit: soundCubit,
                backgroundColor: primaryColor,
                iconColor: Colors.white,
              ),
        )
      ],
    );
  }
}
