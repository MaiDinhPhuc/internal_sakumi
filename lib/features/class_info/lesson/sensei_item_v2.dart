import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_lesson_cubit_v2.dart';

class SenseiItemV2 extends StatelessWidget {
  const SenseiItemV2({Key? key, required this.cubit}) : super(key: key);
  final DetailLessonCubitV2 cubit;
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
                            : cubit.lessonResult!.date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 18),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          )),
      child: SmallAvatar(cubit.teacher == null ? "" : cubit.teacher!.url),
    );
  }
}
