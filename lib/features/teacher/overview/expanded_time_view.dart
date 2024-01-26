import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandedTimeView extends StatelessWidget {
  const ExpandedTimeView(this.flipFlashCard, this.reading, this.listening,
      this.kanji, this.grammar, this.alphabet, this.vocabulary, this.flashCard,
      {super.key});
  final String flipFlashCard,
      alphabet,
      flashCard,
      grammar,
      kanji,
      listening,
      reading,
      vocabulary;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text("Vocabulary: ",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                        Text(vocabulary.isEmpty? "00:00:00" : vocabulary,
                            style: TextStyle(
                                color: const Color(0xff757575),
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text("Alphabet: ",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                        Text(alphabet.isEmpty? "00:00:00" :alphabet,
                            style: TextStyle(
                                color: const Color(0xff757575),
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text("Listening: ",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                        Text(listening.isEmpty? "00:00:00" :listening,
                            style: TextStyle(
                                color: const Color(0xff757575),
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text("Kanji: ",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                        Text(kanji.isEmpty? "00:00:00" :kanji,
                            style: TextStyle(
                                color: const Color(0xff757575),
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 20))),
                      ],
                    ))
              ],
            )),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text("Reading: ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                    Text(reading.isEmpty? "00:00:00" :reading,
                        style: TextStyle(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text("Grammar: ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                    Text(grammar.isEmpty? "00:00:00" :grammar,
                        style: TextStyle(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text("FlashCard: ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                    Text(flashCard.isEmpty? "00:00:00" :flashCard,
                        style: TextStyle(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text("Flip FlashCard: ",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                    Text(flipFlashCard.isEmpty? "0" :flipFlashCard,
                        style: TextStyle(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                  ],
                ))
          ],
        ),
      ],
    );
  }
}
