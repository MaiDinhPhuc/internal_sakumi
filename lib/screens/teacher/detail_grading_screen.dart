
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:assets_audio_player_web/web/assets_audio_player_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/grading/question_option.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_services.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/title_widget.dart';
import 'package:screenshot/screenshot.dart';

class DetailGradingScreen extends StatelessWidget {
  final String name;
  DetailGradingScreen(this.name, {super.key}): soundCubit = SoundCubit();
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    AssetsAudioPlayer player = AssetsAudioPlayer();
    return BlocProvider(
        create: (context) => DetailGradingCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                  index: 3,
                  classId: TextUtils.getName(position: 2),
                  name: name),
              Expanded(child: BlocBuilder<DetailGradingCubit, int>(builder: (c, s) {
                var cubit = BlocProvider.of<DetailGradingCubit>(c);
                return s == -1
                    ? Transform.scale(
                  scale: 0.75,
                  child: const CircularProgressIndicator(),
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: Resizable.padding(context, 20)),
                            child: cubit.listQuestions == null
                                ? Transform.scale(
                              scale: 0.75,
                              child: const CircularProgressIndicator(),
                            ) : SingleChildScrollView(
                              child: Column(
                                children: [
                                  TitleWidget(AppText.titleQuestion.text.toUpperCase()),
                                  ...(cubit.listQuestions!)
                                      .map((e) => IntrinsicHeight(
                                    child: QuestionOptionItem(
                                      s,
                                      cubit.listQuestions!
                                          .indexOf(e),
                                      questionModel: e,
                                      onTap: () {
                                        cubit.change(e.id, c);
                                        //SoundService.instance.stop();
                                      },
                                      soundCubit: soundCubit
                                    ),
                                  ))
                                      .toList(),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex:2,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical:
                                Resizable.padding(context, 5)),
                            padding: EdgeInsets.all(
                                Resizable.padding(context, 5)),
                            width: MediaQuery.of(context).size.width *
                                0.5,
                            height:
                            MediaQuery.of(context).size.height *
                                0.85,
                            decoration: BoxDecoration(
                                color: lightGreyColor,
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 5))),
                            child: DetailGradingView(cubit.listAnswer),
                          ))
                    ],
                  ),
                );
              }),)
            ],
          ),
        ));
  }
}
