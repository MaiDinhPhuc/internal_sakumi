import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_services.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class RecordDialog extends StatefulWidget {
  const RecordDialog({super.key, required this.stop});

  final Function() stop;

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
    return AlertDialog(
      title: TimerView(),
      titlePadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 100),
          vertical: Resizable.padding(context, 30)),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        AvatarGlow(
            glowColor: primaryColor,
            endRadius: Resizable.size(context, 70),
            child: Card(
                shadowColor: primaryColor,
                elevation: Resizable.size(context, 2),
                color: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 50))),
                child: InkWell(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 50)),
                    onTap: widget.stop,
                    child: AvatarGlow(
                      endRadius: Resizable.size(context, 45),
                      child: Container(
                          margin: EdgeInsets.all(Resizable.size(context, 10)),
                          padding: EdgeInsets.all(Resizable.size(context, 10)),
                          child: Icon(Icons.mic,
                              size: Resizable.size(context, 50),
                              color: Colors.white)),
                    ))))
      ],
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
  bool _timerRunning = false;
  void startTimer() {
    _timerRunning = true;
    _timer?.cancel();
    _countedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countedSeconds++;
      timedDuration = Duration(seconds: _countedSeconds);
      emit(timedDuration);
    });
  }
}
