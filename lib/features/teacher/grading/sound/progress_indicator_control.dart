import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:video_player/video_player.dart';

class ProgressIndicatorControl extends StatelessWidget {
  const ProgressIndicatorControl({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      height: Resizable.size(context, 9),
      child: VideoProgressIndicator(
        controller,
        allowScrubbing: true,
        padding: const EdgeInsets.all(0),
        colors: VideoProgressColors(
          backgroundColor: Colors.transparent,
          bufferedColor: Colors.white.withOpacity(0.4),
          playedColor:Colors.white //secondaryColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
