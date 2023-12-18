import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'expanded_time_view.dart';

class ExpandLearnedLesson extends StatelessWidget {
  final String spNote;
  final String ssNote;
  final String flipFlashCard,
      alphabet,
      flashCard,
      grammar,
      kanji,
      listening,
      reading,
      vocabulary;
  const ExpandLearnedLesson(
      this.spNote,
      this.ssNote,
      this.flipFlashCard,
      this.reading,
      this.listening,
      this.kanji,
      this.grammar,
      this.alphabet,
      this.vocabulary,
      this.flashCard,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandedTimeView(flipFlashCard,reading,listening,kanji,grammar, alphabet,vocabulary, flashCard),
        Container(
          margin: EdgeInsets.only(
              top: Resizable.padding(context, 10),
              bottom: Resizable.padding(context, 15)),
          height: Resizable.size(context, 0.5),
          width: double.maxFinite,
          color: const Color(0xffE0E0E0),
        ),
        Text(AppText.titleNoteFromAnotherTeacher.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 10)),
            constraints: BoxConstraints(minHeight: Resizable.size(context, 30)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: greyColor.shade50,
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5))),
            child: Text(ssNote,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 19)))),
        Text(AppText.titleNoteFromSupport.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
            constraints: BoxConstraints(minHeight: Resizable.size(context, 30)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: greyColor.shade50,
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5))),
            child: Text(spNote,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 19)))),
      ],
    );
  }
}
