import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class LessonItem extends StatelessWidget {
  const LessonItem(this.lesson,{super.key});
  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Resizable.size(context, 500),
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xffE0E0E0),
              width: Resizable.size(context, 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Resizable.font(context, 20),
                  color: Colors.black)),
          SizedBox(height: Resizable.padding(context, 3)),
          Text(lesson.description,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Resizable.font(context, 15),
                  color: const Color(0xff757575)))
        ],
      )
    );
  }
}
