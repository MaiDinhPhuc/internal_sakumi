import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseRegisterSchedule extends StatelessWidget {
  const CollapseRegisterSchedule({super.key, required this.dropDownCubit, required this.cubit, required this.role});
  final DropdownCubit dropDownCubit;
  final ScheduleTabCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(AppText.txtRegisterSchedule.text.toUpperCase(),
                style: TextStyle(
                    color: greyColor.shade600,
                    fontWeight: FontWeight.w700,
                    fontSize:
                    Resizable.font(context, 20))),
            if(role == "teacher" && cubit.isEdit == false)
              Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),child: IconButton(
                  onPressed: () {
                    cubit.changeEdit();
                  },
                  iconSize: Resizable.size(context, 20),
                  icon: Image.asset('assets/images/ic_edit.png',
                      width: Resizable.size(context, 20),
                      height: Resizable.size(context, 20))))
          ],
        ),
        IconButton(
            onPressed: () {
              dropDownCubit.update();
            },
            splashRadius: Resizable.size(context, 15),
            icon: Icon(
              dropDownCubit.state % 2 == 0
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
            ))
      ],
    );
  }
}
