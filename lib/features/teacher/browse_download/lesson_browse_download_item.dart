import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/teacher/browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class LessonBrowseDownloadItem extends StatelessWidget {
  const LessonBrowseDownloadItem(
      {super.key, required this.cubit, required this.lesson});

  final RequestBrowseDownloadCubit cubit;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 3),
          horizontal: Resizable.padding(context, 10)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 10),
          vertical: Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Row(
        children: [
          Expanded(
              flex: 18,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(lesson.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))))),
          Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: () {
                  int time = DateTime.now().millisecondsSinceEpoch;
                  if (cubit.checkRequest(lesson.lessonId) == false) {
                    BrowseDownloadModel newRequest = BrowseDownloadModel(
                        lessonId: lesson.lessonId,
                        classId: cubit.classModel.classId,
                        teacherId: cubit.teacherId!,
                        submitTime: time,
                        downloadTime: 0,
                        acceptTime: 0,
                        status: 'waiting',
                        supportId: 0,
                        id: time,
                        parentId: 0);
                    Create.createNewBrowseDownload(newRequest);
                    cubit.createNewRequest(newRequest);
                  }
                },
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Resizable.padding(context, 3)))),
                    backgroundColor: MaterialStateProperty.all(
                        cubit.checkRequest(lesson.lessonId)
                            ? darkPrimaryColor
                            : primaryColor),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)))),
                child: Text(AppText.txtRequestDownload.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 16),
                        color: Colors.white)),
              )),
          Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        if (cubit.checkRequest(lesson.lessonId) == false) {
                          notificationDialog(
                              context, AppText.txtRequestRequired.text);
                        } else if (cubit.checkEnableDownload(lesson.lessonId)) {
                          if (cubit.getLinkDownload(lesson.courseId).isEmpty) {
                            notificationDialog(
                                context, AppText.txtDataDownloadEmpty.text);
                          } else {
                            cubit.downloadFile(
                                cubit.getLinkDownload(lesson.courseId));
                            BrowseDownloadModel model = cubit
                                .listBrowseDownload!
                                .firstWhere((e) =>
                                    e.lessonId == lesson.lessonId && e.parentId == 0);
                            Update.updateBrowseDownload(model.copyWith(status: 'download', downloadTime: DateTime.now().millisecondsSinceEpoch));
                            cubit.updateRequest(model);
                          }
                        } else {
                          notificationDialog(
                              context, AppText.txtRequestNotAccept.text);
                        }
                      },
                      splashRadius: Resizable.size(context, 15),
                      icon: Icon(
                        Icons.file_download,
                        color: cubit.checkRequest(lesson.lessonId)
                            ? primaryColor
                            : darkPrimaryColor,
                      )))),
        ],
      ),
    );
  }
}
