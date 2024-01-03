import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'list_lesson_cubit_v2.dart';

class SenseiItemV2 extends StatelessWidget {
  const SenseiItemV2({Key? key, required this.cubit, required this.e}) : super(key: key);
  final ListLessonCubitV2 cubit;
  final Map<String, dynamic> e;
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
                        text: cubit
                            .listTeacher![cubit.listLessonInfo!.indexOf(e)]!
                            .name,
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
                        text: cubit
                            .listTeacher![cubit.listLessonInfo!.indexOf(e)]!
                            .phone,
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
                        text: cubit
                            .listTeachingDay![cubit.listLessonInfo!.indexOf(e)],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          )),
      child: SmallAvatar(
          cubit.listTeacher![cubit.listLessonInfo!.indexOf(e)]!.url),
    );
  }
}
