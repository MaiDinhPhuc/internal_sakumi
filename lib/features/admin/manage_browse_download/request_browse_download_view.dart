import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/request_browse_download_cubit.dart';

import 'custom_lesson_browse_download_item.dart';
import 'lesson_browse_download_item.dart';

class RequestBrowseDownloadView extends StatelessWidget {
  const RequestBrowseDownloadView({super.key, required this.cubit});

  final RequestBrowseDownloadCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...cubit.listLessons.map((e) => e.isCustom
              ? CustomLessonBrowseDownloadItem(cubit: cubit, lesson: e)
              : LessonBrowseDownloadItem(cubit: cubit, lesson: e)),
        ],
      ),
    );
  }
}
