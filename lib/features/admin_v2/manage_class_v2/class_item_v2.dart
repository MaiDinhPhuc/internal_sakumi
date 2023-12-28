import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/class_status_item_admin.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/card_item.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

import 'class_overview_v2.dart';

class ClassItemV2 extends StatelessWidget {
  const ClassItemV2({super.key, required this.classModel});
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownCubit(),
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardItem(
                  widget: ClassOverViewV2(
                  classModel: classModel
                  ),
                  onTap: () async {

                  },
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: StatusClassItemAdminV2(
                    classModel: classModel,
                    color:classModel.getColor(),
                    icon: classModel.getIcon())),
              secondChild: CardItem(
                isExpand: true,
                widget: Column(
                  children: [
                    ClassOverViewV2(
                        classModel: classModel
                    ),
                    Text("Chart in here"),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: Resizable.size(context, 1),
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 15)),
                            color: const Color(0xffD9D9D9),
                          ),
                          Row(
                            children: [
                              Text(AppText.txtLastLesson.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 19))),
                              SizedBox(width: Resizable.padding(context, 10)),
                              Text("last lesson",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 19))),
                            ],
                          ),
                          Container(
                            height: Resizable.size(context, 1),
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 15)),
                            color: const Color(0xffD9D9D9),
                          ),
                          Text(AppText.titleClassDes.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 19))),
                          NoteWidget(classModel.description),
                          Text(AppText.titleClassNote.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 19))),
                          NoteWidget(classModel.note)
                        ],
                      ),
                    )
                  ],
                ),
                onTap: () async {

                },
                onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                widgetStatus: StatusClassItemAdminV2(
                    classModel: classModel,
                    color:classModel.getColor(),
                    icon: classModel.getIcon())
              ),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
