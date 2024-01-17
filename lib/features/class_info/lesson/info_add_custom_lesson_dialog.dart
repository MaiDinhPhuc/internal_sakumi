import 'package:flutter/Material.dart';
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
                                    child: InputDropdownV2(
                                  key: Key("course_$i"),
                                  title: AppText.txtCourse.text,
                                  hint: AppText.textChooseCourse.text,
                                  errorText: AppText.txtPleaseChooseCourse.text,
                                  onChanged: cubit.listLessonInfo.isEmpty
                                      ? (v) {
                                          cubit.chooseCourse(v, i);
                                        }
                                      : cubit.listLessonInfo[i]["lessonId"] !=
                                              null
                                          ? null
                                          : (v) {
                                              cubit.chooseCourse(v, i);
                                            },
                                  items: List.generate(
                                          cubit.courses!.length,
                                          (index) =>
                                              ('${cubit.courses![index].title} ${cubit.courses![index].termName} ${cubit.courses![index].code}'))
                                      .toList(),
                                  disableHint: cubit.findCourse(i),
                                ))),
                            Expanded(
                                flex: 5,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: Resizable.padding(context, 10)),
                                    child: Center(
                                        child: InputDropdownV2(
                                      key: Key("lesson_$i"),
                                      title: AppText.txtLesson.text,
                                      hint: AppText.txtChooseLesson.text,
                                      errorText:
                                          AppText.txtPleaseChooseCourse.text,
                                      onChanged: (v) {
                                        cubit.chooseLesson(v, i);
                                      },
                                      items: cubit.listLessonInfo.isEmpty
                                          ? []
                                          : List.generate(
                                              cubit.listLessonTitle(i).length,
                                              (index) => (cubit.listLessonTitle(
                                                  i)[index])).toList(),
                                      disableHint: cubit.findLesson(i),
                                    )))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.all(
                                      Resizable.padding(context, 5)),
                                  height: Resizable.size(context, 30),
                                  width: Resizable.size(context, 30),
                                  decoration: BoxDecoration(
                                      color: greyColor.shade50,
                                      borderRadius: BorderRadius.circular(
                                          Resizable.size(context, 5))),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          Resizable.size(context, 100)),
                                      onTap: () {
                                        cubit.delete(i);
                                      },
                                      child: Icon(Icons.delete,
                                          color: greyColor.shade500,
                                          size: Resizable.size(context, 20))),
                                )),

                          ],
                        ),
                      if (cubit.count < 3)
                        DottedBorderButton(AppText.btnAddNewLesson.text,
                            onPressed: () {
                              if (cubit.listLessonInfo.isNotEmpty) {
                                cubit.addNewCourse();
                              }
                            })
                    ],
                  ))
                ],
              )),
          InputItem(
              title: AppText.txtDescription.text,
              controller: cubit.desCon,
              isExpand: true),
        ],
      ),
    );
  }
}
