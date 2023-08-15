
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_services.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class Sounder extends StatelessWidget {
  final String sound;
  final double size;
  final double elevation;
  final Color backgroundColor;
  final Color iconColor;
  final SoundCubit soundCubit;
  final int type;
  final String soundType;
  const Sounder(this.sound, this.soundType,
      {Key? key,
      this.size = 18,
      this.elevation = 2,
      this.backgroundColor = Colors.white,
      this.iconColor = Colors.white,
      this.type = 0,
      required this.soundCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(sound),
      height: Resizable.size(context, 25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(Resizable.size(context, 30)),
      ),
      margin: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 5),
      ),
      child: BlocBuilder<SoundCubit, double>(
          bloc: soundCubit,
          builder: (cc, p) {
            return Row(
              children: [
                InkWell(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 50)),
                    child: Container(
                        padding:
                            EdgeInsets.only(left: Resizable.size(context, 10)),
                        child: (p == -2 || soundCubit.activeFilePath != sound)
                            ? Icon(Icons.volume_up,
                                color: Colors.white,
                                size: Resizable.size(context, size))
                            : p == -1 && soundCubit.activeFilePath == sound
                                ? Icon(Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: Resizable.size(context, size))
                                : p == 0 && soundCubit.activeFilePath == sound
                                    ? SizedBox(
                                        height: Resizable.size(context, size),
                                        width: Resizable.size(context, size),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : soundCubit.activeFilePath == sound
                                        ? Icon(Icons.pause,
                                            color: Colors.white,
                                            size: Resizable.size(context, size))
                                        : Icon(Icons.volume_up,
                                            color: Colors.white,
                                            size:
                                                Resizable.size(context, size))),
                    onTap: () async {
                      if (soundCubit.activeFilePath != sound) {
                        SoundService.instance
                            .playSound(sound, soundCubit, soundType);
                      }
                      if (p == -1 && soundCubit.activeFilePath == sound) {
                        SoundService.instance.resume(soundCubit);
                      }
                      if (p > 0 && soundCubit.activeFilePath == sound) {
                        SoundService.instance.pause(soundCubit);
                      }
                    }),
                SizedBox(
                  width: Resizable.size(context, 175),
                  child: Slider(
                      key: Key("${soundCubit.duration}"),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey.shade100,
                      thumbColor: Colors.white,
                      min: -2,
                      max: soundCubit.duration,
                      value: p == 0
                          ? -2
                          : p == -1
                              ? soundCubit.currentPosition
                              : p,
                      onChanged: (value) async {
                        final position = Duration(milliseconds: value.toInt());
                        await SoundService.instance.seek(position, sound);
                      }),
                ),
              ],
            );
          }),
    );
  }
}
