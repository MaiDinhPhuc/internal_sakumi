import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'feedback_cubit.dart';
import 'list_feedback.dart';

class ListFeedBackView extends StatelessWidget {
  const ListFeedBackView(
      {super.key, required this.cubit, required this.dropdownCubit});
  final FeedBackCubit cubit;
  final DropdownGradingCubit dropdownCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(AppText.titleFeedBackFromStd.text.toUpperCase())
                  ],
                )),
            Expanded(
                flex: 2,
                child: BlocBuilder<DropdownGradingCubit, String>(
                  bloc: dropdownCubit,
                  builder: (cc, state) {
                    return DropDownGrading(
                        items: [
                          AppText.txtUnread.text,
                          AppText.txtWaiting.text,
                          AppText.txtDone.text,
                        ],
                        onChanged: (item) async {
                          dropdownCubit.change(item!);
                          await cubit.checkData(item);
                          cubit.filter(item);
                        },
                        value: state);
                  },
                ))
          ],
        ),
        cubit.isLoading == false ?
          Expanded(child: SingleChildScrollView(
            child:
            Container(
              margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
              padding: EdgeInsets.all(Resizable.padding(context, 5)),
              decoration: BoxDecoration(
                  color: cubit.getFeedBack().isEmpty
                      ? Colors.transparent
                      : lightGreyColor,
                  borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
              child:ListFeedBack(cubit: cubit),
            ),
          )): const Expanded(child: Center(child: CircularProgressIndicator(color: primaryColor,)))
      ],
    );
  }
}
