import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'feedback_dialog_cubit.dart';
import 'info_feedback_view.dart';

class FeedBackDialog extends StatelessWidget {
  FeedBackDialog({super.key}) : feedbackDialogCubit = FeedBackDialogCubit();
  final FeedBackDialogCubit feedbackDialogCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackDialogCubit, int>(
        bloc: feedbackDialogCubit,
        builder: (c,s){
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Form(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: Resizable.size(context, 300),
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin:
                              EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                              child: Text(
                                AppText.txtSendFeedBackToCentre.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            )),
                        Expanded(
                            flex: 5,
                            child: InfoFeedBackView(feedbackDialogCubit: feedbackDialogCubit)),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(value: feedbackDialogCubit.isAnonymous, onChanged: (newValue){
                                        feedbackDialogCubit.checkAnonymous();
                                      }),
                                      Text(AppText.txtAnonymous.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: Resizable.font(context, 18),
                                              color: const Color(0xff757575))),
                                      SizedBox(width: Resizable.size(context, 5)),
                                      Tooltip(
                                        padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            border: Border.all(
                                                color: primaryColor, width: Resizable.size(context, 1)),
                                            borderRadius: BorderRadius.circular(Resizable.padding(context, 5))),
                                        richMessage: WidgetSpan(
                                            alignment: PlaceholderAlignment.baseline,
                                            baseline: TextBaseline.alphabetic,
                                            child: Text(AppText.txtAnonymousNote.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(context, 15),
                                                    color: Colors.white))),
                                        child: Image.asset('assets/images/ic_warning.png', height: Resizable.font(context, 20)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: Resizable.size(context, 100)),
                                        margin: EdgeInsets.only(
                                            right: Resizable.padding(context, 20)),
                                        child: DialogButton(
                                            AppText.textCancel.text.toUpperCase(),
                                            onPressed: () => Navigator.pop(context)),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: Resizable.size(context, 100)),
                                        child: SubmitButton(
                                            onPressed: ()async{
                                              await feedbackDialogCubit.sendFeedBack();
                                              Navigator.pop(context);
                                            },
                                            title: AppText.txtSendFeedback.text),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )));
        });
  }
}
