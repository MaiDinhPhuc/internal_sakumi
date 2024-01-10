import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_grading_cubit.dart';

class HeaderGrading extends StatelessWidget {
  const HeaderGrading({super.key, required this.cubit});
  final DetailGradingCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            flex: 6,
            child: Padding(
                padding: EdgeInsets.only(
                  top: Resizable.padding(context, 10),
                ),
                child: Text(AppText.titleGrading.text.toUpperCase(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w700,
                        color: greyColor.shade500)))),
        Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton(
                    itemBuilder: (context) => [
                          ...cubit.listStudent!.map((e) => PopupMenuItem(
                              padding: EdgeInsets.zero,
                              child: BlocProvider(
                                  create: (c) => CheckBoxFilterCubit(
                                      cubit.listStudentId!.contains(e.userId)),
                                  child: BlocBuilder<CheckBoxFilterCubit, bool>(
                                      builder: (cc, state) {
                                    return CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(e.name),
                                      value: state,
                                      onChanged: (newValue) {
                                        if (state &&
                                            cubit.listStudentId!.length == 1) {
                                        } else if (state &&
                                            cubit.listStudentId!.length != 1) {
                                          cubit.listStudentId!.remove(e.userId);
                                          BlocProvider.of<CheckBoxFilterCubit>(
                                                  cc)
                                              .update();
                                        } else {
                                          cubit.listStudentId!.add(e.userId);
                                          BlocProvider.of<CheckBoxFilterCubit>(
                                                  cc)
                                              .update();
                                        }
                                        cubit.updateAnswerView(cubit.state);
                                      },
                                    );
                                  }))))
                        ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Resizable.size(context, 10)),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: Resizable.size(context, 2),
                                color: greyColor.shade100)
                          ],
                          border: Border.all(color: greyColor.shade100),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1000)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(AppText.txtStudent.text,
                                      style: TextStyle(
                                          fontSize: Resizable.font(context, 18),
                                          fontWeight: FontWeight.w500)))),
                          const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    )),
              ),
            )),
        BlocProvider(
          create: (c) => PopUpOptionCubit(),
          child: BlocBuilder<PopUpOptionCubit, List<bool>>(
            builder: (cc, list) {
              return PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Resizable.size(context, 10)),
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(AppText.textShowName.text),
                      value: list[0],
                      onChanged: (newValue) {
                        BlocProvider.of<PopUpOptionCubit>(cc)
                            .change(newValue!, 0);
                        cubit.isShowName = !cubit.isShowName;
                        cubit.updateAnswerView(cubit.state);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(AppText.textGeneralComment.text),
                      value: list[1],
                      onChanged: (newValue) {
                        BlocProvider.of<PopUpOptionCubit>(cc)
                            .change(newValue!, 1);
                        cubit.isGeneralComment = !cubit.isGeneralComment;
                        if (newValue == true) {
                          for (var i in cubit.answers) {
                            i.listImagePicker = [];
                          }
                        }
                        cubit.updateAnswerView(cubit.state);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              );
            },
          ),
        )
      ],
    );
  }
}
