import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';

class CustomLessonBrowseDownloadItem extends StatelessWidget {
  const CustomLessonBrowseDownloadItem({super.key, required this.cubit, required this.lesson});

  final RequestBrowseDownloadCubit cubit;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
