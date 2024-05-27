import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';

class LessonBrowseDownloadItem extends StatelessWidget {
  const LessonBrowseDownloadItem({super.key, required this.cubit, required this.lesson});

  final RequestBrowseDownloadCubit cubit;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
