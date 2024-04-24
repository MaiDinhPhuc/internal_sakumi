import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import '../manage_bills/search_in_bill.dart';
import 'manage_schedule_cubit.dart';

class SearchInScheduleView extends StatelessWidget {
  const SearchInScheduleView({super.key, required this.cubit});
  final ManageScheduleCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 5)),
                    child: Text(AppText.txtClass.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: const Color(0xff757575))))),
            SizedBox(width: Resizable.padding(context, 10)),
            Expanded(
                flex: 5,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 5)),
                    child: Text(AppText.txtTeacher.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: const Color(0xff757575))))),
            Expanded(
                flex: 1,
                child: Padding(
                padding: EdgeInsets.only(
                    left: Resizable.padding(context, 10)),
                child: Container()))
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: SearchInBill(
                    hint: AppText.txtSearchClass.text,
                    onDelete: () {
                      cubit.deleteClass();
                    },
                    onChange: (newValue) {
                      cubit.searchClass(newValue);
                    },
                    controller: cubit.classSearch,
                    enable: cubit.classId == null)),
            SizedBox(width: Resizable.padding(context, 10)),
            Expanded(
                flex: 5,
                child: SearchInBill(
                    hint: AppText.txtSearchTeacher.text,
                    onDelete: () {
                      cubit.deleteTeacher();
                    },
                    onChange: (newValue) {
                      cubit.searchTeacher(newValue);
                    },
                    controller: cubit.teacherSearch,
                    enable: cubit.teacherId == null)),
            Expanded(
                flex: 1,
                child: Padding(
                padding: EdgeInsets.only(
                    left: Resizable.padding(context, 10)),
                child: SubmitButton(
                    onPressed: () async {
                      waitingDialog(context);
                      await cubit.getSchedule();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    title: "Tìm")))
          ],
        ),
      ],
    );
  }
}
