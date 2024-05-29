import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class LessonBrowseDownloadItem extends StatelessWidget {
  const LessonBrowseDownloadItem({super.key, required this.cubit, required this.lesson});

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
              width: Resizable.size(context, 1),
              color: greyColor.shade100),
          borderRadius: BorderRadius.circular(
              Resizable.size(context, 5))),
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
                          fontSize: Resizable.font(
                              context, 20))))),
          Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: (){},
                style: ButtonStyle(
                    shadowColor:
                    MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 3)))),
                    backgroundColor:
                    MaterialStateProperty.all(primaryColor),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                            horizontal:
                            Resizable.padding(context, 10)))),
                child: Text("Yêu cầu tải",
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

                      },
                      splashRadius:
                      Resizable.size(context, 15),
                      icon: Icon(
                        Icons.file_download,
                        color: primaryColor,
                      )))),
        ],
      ),
    );
  }
}
