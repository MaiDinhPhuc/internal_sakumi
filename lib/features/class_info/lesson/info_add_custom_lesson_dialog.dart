import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'custom_lesson_cubit.dart';

class InfoAddCustomLesson extends StatelessWidget {
  const InfoAddCustomLesson({super.key, required this.cubit});
  final CustomLessonCubit cubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.txtTitle.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: const Color(0xff757575))),
              InputField(controller: cubit.titleCon)
            ],
          ),
          Text(AppText.txtContent.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 15),
                vertical: Resizable.padding(context, 8)),
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: greyColor.shade50),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Center(
                                    child: Text(AppText.txtCourse.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: Resizable.font(context, 18),
                                            color: const Color(0xff757575))))),
                            Expanded(
                                flex: 5,
                                child: Center(
                                    child: Text(AppText.titleLesson.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: Resizable.font(context, 18),
                                            color: const Color(0xff757575))))),
                            Expanded(flex: 1, child: Container())
                          ],
                        ),
                        for (int i = 0; i < cubit.count; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Center(
                                      child: InputDropdown(
                                          title: AppText.txtCourse.text,
                                          hint: AppText.textChooseCourse.text,
                                          errorText: AppText.txtPleaseChooseCourse.text,
                                          onChanged: (v) {
                                            cubit.chooseCourse(v);
                                          },
                                          items: List.generate(
                                              cubit.courses!.length,
                                                  (index) =>
                                              ('${cubit.courses![index].title} ${cubit.courses![index].termName} ${cubit.courses![index].code}'))
                                              .toList()))),
                              Expanded(
                                  flex: 5,
                                  child: Center(
                                      child: InputDropdown(
                                          title: AppText.txtLesson.text,
                                          hint: AppText.txtChooseLesson.text,
                                          errorText: AppText.txtPleaseChooseCourse.text,
                                          onChanged: (v) {
                                            //cubit.chooseCourse(v);
                                          },
                                          items: List.generate(
                                              cubit.lessons.length,
                                                  (index) =>
                                              (cubit.lessons[index].title))
                                              .toList()))),
                              Expanded(flex: 1, child: Container())
                            ],
                          ),
                        DottedBorderButton(AppText.btnAddNewLesson.text, onPressed: (){})
                      ],
                    ))
              ],
            )
          ),
          InputItem(
              title: AppText.txtDescription.text,
              controller: cubit.desCon,
              isExpand: true),
        ],
      ),
    );
  }
}
