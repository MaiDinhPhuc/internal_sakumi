import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_services.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherSounder extends StatelessWidget {
  final String sound;
  final double size;
  final double elevation;
  final Color backgroundColor;
  final Color iconColor;
  final SoundCubit soundCubit;
  final int type;
  final String soundType;
  final int index;
  final Function() onDelete;
  const TeacherSounder(this.sound, this.soundType, this.index,
      {Key? key,
      this.size = 18,
      this.elevation = 2,
      this.backgroundColor = Colors.white,
      this.iconColor = Colors.white,
      this.type = 0,
      required this.soundCubit,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(sound),
      width: MediaQuery.of(context).size.width * 0.24,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 50)),
                        child: Container(
                            padding: EdgeInsets.only(
                                left: Resizable.size(context, 10)),
                            child: (soundCubit.activeFilePath != sound)
                                ? Icon(Icons.volume_up,
                                    color: Colors.white,
                                    size: Resizable.size(context, size))
                                : SoundService.instance.isPause() == true &&
                                        soundCubit.activeFilePath == sound
                                    ? Icon(Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: Resizable.size(context, size))
                                    : p == 0 &&
                                            soundCubit.activeFilePath == sound
                                        ? SizedBox(
                                            height:
                                                Resizable.size(context, size),
                                            width:
                                                Resizable.size(context, size),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SoundService.instance.isPause() ==
                                                    false &&
                                                soundCubit.activeFilePath ==
                                                    sound
                                            ? Icon(Icons.pause,
                                                color: Colors.white,
                                                size: Resizable.size(
                                                    context, size))
                                            : Icon(Icons.volume_up,
                                                color: Colors.white,
                                                size: Resizable.size(
                                                    context, size))),
                        onTap: () async {
                          if (soundCubit.activeFilePath != sound) {
                            SoundService.instance
                                .playSound(sound, soundCubit, soundType);
                          }
                          if (SoundService.instance.isPause() == true &&
                              soundCubit.activeFilePath == sound) {
                            SoundService.instance.play();
                          } else if (SoundService.instance.isPause() == false &&
                              soundCubit.activeFilePath == sound) {
                            SoundService.instance.pause(soundCubit);
                          }
                        }),
                    Text(
                        soundType == "network"
                            ? ' File thu âm ${index + 1}'
                            : ' File âm thanh ${index + 1}',
                        style: TextStyle(
                            fontSize: Resizable.font(context, 16),
                            fontWeight: FontWeight.w800,
                            color: Colors.white))
                  ],
                ),
                Padding(
                    padding:
                        EdgeInsets.only(right: Resizable.padding(context, 5)),
                    child: InkWell(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete,
                          size: Resizable.size(context, 18),
                          color: Colors.white,
                        )))
              ],
            );
          }),
    );
  }
}
