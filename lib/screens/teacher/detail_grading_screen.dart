
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

class DetailGradingScreen extends StatelessWidget {
  final String name;
  DetailGradingScreen(this.name, {super.key}): questionSoundCubit = SoundCubit();
  final SoundCubit questionSoundCubit;

  @override
  Widget build(BuildContext context) {
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
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                            ) : Column(
                              children: [
                                TitleWidget(AppText.titleQuestion.text.toUpperCase()),
                                Expanded(child: Container(
                                  margin: EdgeInsets.only(
                                      bottom:
                                      Resizable.padding(context, 5)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...(cubit.listQuestions!)
                                            .map((e) => IntrinsicHeight(
                                          child: QuestionOptionItem(
                                              s,
                                              cubit.listQuestions!
                                                  .indexOf(e),
                                              questionModel: e,
                                              onTap: () {
                                                cubit.change(e.id, c);
                                                SoundService.instance.stop();
                                              },
                                              soundCubit: questionSoundCubit
                                          ),
                                        ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          )),
                      Expanded(
                          flex:2,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      flex:3,
                                      child: Padding(
                                      padding: EdgeInsets.only(
                                        top: Resizable.padding(context, 10),
                                      ),
                                      child: Text(AppText.titleGrading.text.toUpperCase(),
                                          style: TextStyle(
                                              fontSize:
                                              Resizable.font(context, 20),
                                              fontWeight: FontWeight.w700,
                                              color: greyColor.shade500)))),
                                  Expanded(
                                      flex: 1,
                                      child: DropDownGrading(items: [
                                        AppText.txtStudent.text,
                                        ...cubit.listStudent!.map((e) => e.name).toList()
                                      ])),
                                  PopupMenuButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Resizable.size(context, 10)),
                                      ),
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(AppText.textShowName.text),
                                          value: true,
                                          onChanged: (newValue) {},
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(AppText.textGeneralComment.text),
                                          value: false,
                                          onChanged: (newValue) {},
                                        ),
                                      ),
                                    ],
                                    icon:const Icon(Icons.more_vert),
                                  )
                                ],
                              ),
                              Expanded(child: Container(
                                margin: EdgeInsets.only(
                                    bottom:
                                    Resizable.padding(context, 5), right: Resizable.padding(context, 10)),
                                padding: EdgeInsets.all(
                                    Resizable.padding(context, 5)),
                                decoration: BoxDecoration(
                                    color: lightGreyColor,
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 5))),
                                child: DetailGradingView(cubit,questionSoundCubit),
                              ))
                            ],
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
