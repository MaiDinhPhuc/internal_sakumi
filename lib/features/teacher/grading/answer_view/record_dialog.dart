import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class RecordDialog extends StatefulWidget {
  const RecordDialog({super.key, required this.stop, required this.ques});

  final Function() stop;
  final QuestionModel ques;
  @override
  State<RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<RecordDialog> {
  @override
  void dispose() {
    //RecordService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(Resizable.padding(context, 10)),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    "Ghi âm nhận xét bài tập học viên",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.size(context, 10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.ques.instruction != "")
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 5)),
                              child: Text(
                                widget.ques.instruction,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 17)),
                              )),
                        if (widget.ques.question != "")
                          Text(
                            widget.ques.question,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 17)),
                          ),
                        if (widget.ques.paragraph != "")
                          Text(
                            widget.ques.paragraph,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 17)),
                          ),
                        if (widget.ques.questionType == 1 ||
                            widget.ques.questionType == 5)
                          ...widget.ques.listAnswer.map((e) => Padding(
                              padding: EdgeInsets.only(
                                  top: Resizable.padding(context, 3)),
                              child: Text(
                                  "${widget.ques.listAnswer.indexOf(e) + 1}.$e",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Resizable.font(context, 15),
                                      fontWeight: FontWeight.w800)))),
                        if (widget.ques.image != "" || widget.ques.sound != "")
                          Text(
                            "*Câu hỏi này có hình ảnh và âm thanh\nĐể xem chi tiết vui lòng coi ở bên ngoài*",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 17)),
                          ),
                      ],
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                  children: [
                    TimerView(),
                    AvatarGlow(
                        glowColor: primaryColor,
                        endRadius: Resizable.size(context, 40),
                        child: Card(
                            shadowColor: primaryColor,
                            elevation: Resizable.size(context, 2),
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 50))),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 50)),
                                onTap: widget.stop,
                                child: AvatarGlow(
                                  endRadius: Resizable.size(context, 35),
                                  child: Container(
                                      margin: EdgeInsets.all(
                                          Resizable.size(context, 10)),
                                      padding: EdgeInsets.all(
                                          Resizable.size(context, 10)),
                                      child: Icon(Icons.mic,
                                          size: Resizable.size(context, 25),
                                          color: Colors.white)),
                                )))),
                    Text(
                      "Bấm vào nút ghi âm 1 lần nữa để kết thúc ghi âm",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Resizable.font(context, 15)),
                    )
                  ],
                )),
                SizedBox(height: Resizable.size(context, 15))
              ],
            ),
          )),
    );
  }
}

class TimerView extends StatelessWidget {
  TimerView({super.key}) : timerCubit = TimerCubit();
  final TimerCubit timerCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, Duration>(
        bloc: timerCubit..startTimer(),
        builder: (c, s) {
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          final twoDigitMinutes = twoDigits(s.inMinutes.remainder(60));
          final twoDigitSeconds = twoDigits(s.inSeconds.remainder(60));
          return Text("$twoDigitMinutes:$twoDigitSeconds",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 100)));
        });
  }
}

class TimerCubit extends Cubit<Duration> {
  TimerCubit() : super(Duration.zero);

  Timer? _timer;
  int _countedSeconds = 0;
  Duration timedDuration = Duration.zero;
  void startTimer() {
    _timer?.cancel();
    _countedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countedSeconds++;
      timedDuration = Duration(seconds: _countedSeconds);
      emit(timedDuration);
    });
  }
}
