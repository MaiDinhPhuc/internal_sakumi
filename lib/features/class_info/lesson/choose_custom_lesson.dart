import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ChooseCustomLessonCubit extends Cubit<int> {
  ChooseCustomLessonCubit(this.listCustomLesson) : super(0) {
    loadLesson();
  }
  List<dynamic> listCustomLesson;
  List<LessonModel> lessons = [];

  loadLesson() async {
    var listLessonId = listCustomLesson.map((e) => e['lesson_id']).toList();
    for (var i in listLessonId) {
      lessons.add(await FireBaseProvider.instance.getLessonById(i));
    }
    emit(state + 1);
  }
}

Future<void> selectionCustomLessonDialog(
    BuildContext context, List<dynamic> listCustomLesson, int classId, int customLessonId) {
  return showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
          create: (context) => ChooseCustomLessonCubit(listCustomLesson),
          child: BlocBuilder<ChooseCustomLessonCubit, int>(
            builder: (c, s) {
              return s == 0
                  ? const WaitingAlert()
                  : Dialog(
                      child: Container(
                          padding:
                              EdgeInsets.all(Resizable.padding(context, 20)),
                          width: Resizable.width(context) / 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Resizable.padding(context, 20)),
                                child: Text(AppText.txtPleaseSelect.text,
                                    style: TextStyle(
                                        fontSize: Resizable.font(context, 20),
                                        fontWeight: FontWeight.w700)),
                              ),
                              ...BlocProvider.of<ChooseCustomLessonCubit>(c)
                                  .lessons
                                  .map((e) => Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),child: DottedBorderButton(e.title,
                                  isManageGeneral: true,
                                  onPressed: ()async{
                                    await Navigator.pushNamed(c,
                                        "/teacher/grading/class=$classId/type=btvn/customLesson=$customLessonId/lesson=${e.lessonId}");
                                  })))
                            ],
                          )));
            },
          ),
        );
      });
}
