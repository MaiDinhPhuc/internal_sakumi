import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/feedback_dialog_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class FooterView extends StatelessWidget {
  FooterView({super.key}) : feedbackDialogCubit = FeedBackDialogCubit();
  final FeedBackDialogCubit feedbackDialogCubit;
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackDialogCubit, int>(
        bloc: feedbackDialogCubit,
        builder: (c,s){
      return Container(
        height: Resizable.size(context, 40),
        padding: EdgeInsets.only(
            bottom: Resizable.padding(context, 5),
            top: Resizable.padding(context, 5)),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Resizable.size(context, 40),
              width: Resizable.size(context, 600),
              child: TextFormField(
                controller: textEditingController,
                onChanged: (String value) {
                  feedbackDialogCubit.inputContent(value);
                },
                cursorColor: Colors.black,
                style: TextStyle(
                    fontSize: Resizable.font(context, 16), color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: AppText.txtHintFeedBack.text,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 16),
                      color: const Color(0xFF461220).withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 20),
                  ),
                  constraints:
                  BoxConstraints(maxHeight: Resizable.size(context, 40)),
                  prefixIcon: Container(
                    margin: EdgeInsets.only(
                      right: Resizable.padding(context, 10),
                    ),
                    height: Resizable.size(context, 40),
                    width: Resizable.font(context, 280),
                    child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: Colors.white,
                          hoverColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    Resizable.padding(context, 1000)),
                                bottomLeft: Radius.circular(
                                    Resizable.padding(context, 1000))),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Resizable.padding(context, 1000)),
                              borderSide: BorderSide(
                                  color: const Color(0xffE0E0E0),
                                  width: Resizable.size(context, 0.5))),
                        ),
                        buttonOverlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        dropdownElevation: Resizable.size(context, 5).toInt(),
                        dropdownDecoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: Resizable.size(context, 4),
                                  offset: Offset(0, Resizable.size(context, 4)))
                            ],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        icon: Padding(
                          padding: EdgeInsets.only(
                              right: Resizable.padding(context, 10)),
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                        buttonPadding: EdgeInsets.symmetric(
                            vertical: Resizable.size(context, 5),
                            horizontal: Resizable.padding(context, 0)),
                        hint: Container(
                            alignment: Alignment.centerLeft,
                            height: Resizable.size(context, 40),
                            padding: EdgeInsets.only(
                                left: Resizable.padding(context, 5)),
                            child: Text(
                              feedbackDialogCubit.listType.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 14),
                                  color: const Color(0xff757575)),
                            )),
                        buttonHeight: Resizable.size(context, 40.toDouble()),
                        items: List.generate(feedbackDialogCubit.listType.length,
                                (index) => (feedbackDialogCubit.listType[index]))
                            .toList()
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (v) {
                          feedbackDialogCubit.chooseCategory(v!);
                        }),
                  ),
                  labelStyle: TextStyle(
                      fontSize: Resizable.font(context, 16),
                      color: Colors.grey.shade900),
                  errorMaxLines: 1,
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 20)),
                    borderSide: BorderSide(
                        color: const Color(0xffE0E0E0), width: Resizable.size(context, 1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1)),
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 20)),
                  ),
                  suffixIcon: InkWell(
                    onTap: (){
                      feedbackDialogCubit.checkAnonymous();
                    },
                    child: Tooltip(
                      padding: EdgeInsets.all(Resizable.padding(context, 10)),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(
                              color: primaryColor,
                              width: Resizable.size(context, 1)),
                          borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 5))),
                      richMessage: WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: Text(AppText.txtAnonymousNote.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 15),
                                  color: Colors.white))),
                      child: IgnorePointer(
                        ignoring: true,
                        child: Padding(
                            padding: EdgeInsets.all(Resizable.padding(context, 10)),
                            child: Image.asset(
                              'assets/images/ic_anonymous.png',
                              height: Resizable.size(context, 15),
                              width: Resizable.size(context, 15),
                              color: feedbackDialogCubit.isAnonymous ?primaryColor:greyColor.shade600,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: Resizable.padding(context, 10)),
            SubmitButton(onPressed: () async {
              waitingDialog(context);
              await feedbackDialogCubit.sendFeedBack();
              feedbackDialogCubit.clearContent();
              textEditingController.text = '';
              Navigator.pop(context);
            }, title: AppText.txtSendFeedback.text)
          ],
        ),
      );
    });
  }
}
