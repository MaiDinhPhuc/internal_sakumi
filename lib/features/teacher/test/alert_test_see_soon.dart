import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/test/question_test_view.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

Future<void> alertTestSeeSoon(BuildContext context, TestModel testModel) async {
  final SoundCubit questionSoundCubit = SoundCubit();
  await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: BlocProvider(
              create: (context) => TestSeeSoonCubit(testModel),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 20)),
                          child: Text(
                            testModel.title.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20)),
                          ),
                        )),
                    Expanded(
                        flex: 10,
                        child:
                            BlocBuilder<TestSeeSoonCubit, List<QuestionModel>?>(
                                builder: (c, s) {
                          if (s == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                ...s.map((e) => QuestionTestView(
                                      questionModel: e,
                                      soundCubit: questionSoundCubit,
                                      testId: testModel.id,
                                      token:
                                          BlocProvider.of<TestSeeSoonCubit>(c)
                                              .token!,
                                      index: s.indexOf(e),
                                    ))
                              ]));
                        })),
                    Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: Resizable.padding(context, 20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: Resizable.size(context, 100)),
                                  margin: EdgeInsets.only(
                                      right: Resizable.padding(context, 20)),
                                  child: DialogButton(
                                      AppText.textCancel.text.toUpperCase(),
                                      onPressed: () {
                                    Navigator.pop(context);
                                  }),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ));
      });
}

class TestSeeSoonCubit extends Cubit<List<QuestionModel>?> {
  TestSeeSoonCubit(TestModel testModel) : super(null) {
    loadTestQuestion(testModel);
  }

  String? token;

  loadTestQuestion(TestModel testModel) async {
    var courseModel =
        await FireBaseProvider.instance.getCourseById(testModel.courseId);
    token = courseModel.token;
    var listQuestions = await FireBaseProvider.instance.getQuestionByUrl(
        AppConfigs.getDataUrl("test_${testModel.id}.json", token!));
    emit(listQuestions);
  }
}
