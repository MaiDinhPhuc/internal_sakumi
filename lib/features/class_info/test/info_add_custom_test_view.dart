import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'custom_test_cubit.dart';

class InfoAddCustomTestView extends StatelessWidget {
  const InfoAddCustomTestView({super.key, required this.cubit});
  final CustomTestCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                child: Text(AppText.txtTest.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))))),
                        Expanded(flex: 1, child: Container())
                      ],
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Center(
                                  child: InputDropdownV2(
                                    title: AppText.txtCourse.text,
                                    hint: AppText.textChooseCourse.text,
                                    errorText: AppText.txtPleaseChooseCourse.text,
                                    onChanged:
                                    cubit.testInfo == {}
                                        ? (v) {
                                      cubit.chooseCourse(v);
                                    }
                                        : cubit.testInfo["test_id"] !=
                                        null
                                        ? null
                                        : (v) {
                                      cubit.chooseCourse(v);
                                    },
                                    items: List.generate(
                                        cubit.courses!.length,
                                            (index) =>
                                        ('${cubit.courses![index].title} ${cubit.courses![index].termName} ${cubit.courses![index].code}'))
                                        .toList(),
                                    disableHint: cubit.findCourse(),
                                  ))),
                          Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Resizable.padding(context, 10)),
                                  child: Center(
                                      child: InputDropdownV2(
                                        title: AppText.txtTest.text,
                                        hint: AppText.txtChooseTest.text,
                                        onChanged: (v) {
                                          cubit.chooseTest(v);
                                        },
                                        items: cubit.testInfo == {}
                                            ? []
                                            : List.generate(
                                            cubit.listTestTitle().length,
                                                (index) => (cubit.listTestTitle()[index])).toList(),
                                        disableHint: cubit.findTest(),
                                      )))),
                        ],
                      ),
                  ],
                ))
          ],
        ));
  }
}