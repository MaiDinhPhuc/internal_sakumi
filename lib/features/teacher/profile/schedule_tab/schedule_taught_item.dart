import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ScheduleTaughtItem extends StatelessWidget {
  const ScheduleTaughtItem({super.key, required this.cubit, required this.lessonResultModel});
  final ScheduleTabCubit cubit;
  final LessonResultModel lessonResultModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:Resizable.padding(context, 5), vertical:Resizable.padding(context, 3) ),
      decoration: BoxDecoration(
          color: const Color(0xffEDFFE6),
          border: Border.all(
              width: Resizable.size(context, 1),
              color: const Color(0xffEDFFE6)),
          borderRadius:
          BorderRadius.circular(Resizable.size(context, 5))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal:Resizable.padding(context, 5),
                vertical:Resizable.padding(context, 2)),
            decoration: BoxDecoration(
                color: const Color(0xffADE099),
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: const Color(0xffADE099)),
                borderRadius:
                BorderRadius.circular(Resizable.size(context, 15))),
            child: Text(
              cubit.convertTime(lessonResultModel.date),
              style: TextStyle(color: const Color(0xff33691E),
                  fontSize: Resizable.font(context, 16), fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Center(child: Text(
            cubit.getClassCode(lessonResultModel.classId).toUpperCase(),
            style: TextStyle(color: Colors.black,
                fontSize: Resizable.font(context, 20), fontWeight: FontWeight.w600),
          )))
        ],
      )
    );
  }
}
