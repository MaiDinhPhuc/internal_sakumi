import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';

import 'lesson_item_cubit_v2.dart';

class SenseiItemV2 extends StatelessWidget {
  const SenseiItemV2({Key? key, required this.cubit}) : super(key: key);
  final LessonItemCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.all(Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
              color: Colors.black, width: Resizable.size(context, 1)),
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5))),
      richMessage: WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "${AppText.txtName.text}: ",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text: cubit.teacher == null
                            ? "loading..."
                            : cubit.teacher!.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: Resizable.size(context, 5)),
              RichText(
                text: TextSpan(
                  text: '${AppText.txtPhone.text}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text: cubit.teacher == null
                            ? "loading..."
                            : cubit.teacher!.phone,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: Resizable.size(context, 5)),
              RichText(
                text: TextSpan(
                  text: '${AppText.txtTeachingDay.text}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text: cubit.lessonResult == null
                            ? "loading..."
                            : DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(cubit.lessonResult!.date)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          )),
      child: IgnorePointer(
          ignoring: true,
          child: SmallAvatar(cubit.teacher == null ? "" : cubit.teacher!.url)),
    );
  }
}

class SenseiItemBrowseDownload extends StatelessWidget {
  const SenseiItemBrowseDownload({Key? key, required this.teacher}) : super(key: key);
  final TeacherModel? teacher;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.all(Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
              color: Colors.black, width: Resizable.size(context, 1)),
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5))),
      richMessage: WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "${AppText.txtName.text}: ",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text:teacher == null ? "loading..." : teacher!.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: Resizable.size(context, 5)),
              RichText(
                text: TextSpan(
                  text: '${AppText.txtPhone.text}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text:teacher == null ? "loading..." : teacher!.phone,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: Resizable.size(context, 5)),
              RichText(
                text: TextSpan(
                  text: '${AppText.txtTeacherCode.text}: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.white70.withOpacity(0.5)),
                  children: <TextSpan>[
                    TextSpan(
                        text:teacher == null ? "loading..." : teacher!.teacherCode,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          )),
      child: IgnorePointer(
          ignoring: true,
          child: SmallAvatar(teacher == null ? "" :teacher!.url)),
    );
  }
}