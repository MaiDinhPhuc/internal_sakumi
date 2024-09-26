import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'list_advise.dart';
import 'manage_advise_cubit.dart';

class ListAdviseView extends StatelessWidget {
  const ListAdviseView({super.key, required this.cubit});
  final ManageAdviseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(AppText.txtAdviseRequest.text.toUpperCase())
                  ],
                )),
            Expanded(
                flex: 3,
                child: DropDownGrading(
                    items: [
                      AppText.txtUnread.text,
                      AppText.txtDone.text,
                    ],
                    onChanged: (item) async {
                      cubit.filter(item!);
                      await cubit.checkData(item);
                    },
                    value: cubit.filterState))
          ],
        ),
        cubit.isLoading == false
            ? Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin:
                EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                    color: cubit.getAdvise().isEmpty
                        ? Colors.transparent
                        : lightGreyColor,
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
                child: ListAdvise(cubit: cubit),
              ),
            ))
            : const Expanded(
            child: Center(
                child: CircularProgressIndicator(color: primaryColor)))
      ],
    );
  }
}
