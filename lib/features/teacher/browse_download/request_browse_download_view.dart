import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import 'custom_lesson_browse_download_item.dart';
import 'lesson_browse_download_item.dart';

class RequestBrowseDownloadView extends StatelessWidget {
  const RequestBrowseDownloadView({super.key, required this.cubit});

  final RequestBrowseDownloadCubit cubit;

  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return cubit.listBrowseDownload == null? Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...shimmerList.map((e) => const ItemShimmer())
          ],
        ),
      ),
    ) : SingleChildScrollView(
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
