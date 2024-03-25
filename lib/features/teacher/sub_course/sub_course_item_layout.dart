import 'package:flutter/Material.dart';

class SubCourseItemLayout extends StatelessWidget {
  const SubCourseItemLayout(
      {super.key,
      required this.lesson,
      required this.title,
      required this.dropdown});

  final Widget lesson, title, dropdown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: lesson,
            )),
        Expanded(
            flex: 18,
            child: Container(alignment: Alignment.centerLeft, child: title)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: dropdown)),
      ],
    );
  }
}

class DetailSubCourseItemLayout extends StatelessWidget {
  const DetailSubCourseItemLayout(
      {super.key, required this.name, required this.flashCard, required this.hw, required this.vocabulary, required this.grammar, required this.reading, required this.kanji, required this.listening, required this.alphabet});

  final Widget name, flashCard, hw, vocabulary, grammar, reading, kanji, listening , alphabet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerLeft,
              child: name,
            )),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: flashCard)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: hw)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: vocabulary)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: grammar)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: reading)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: kanji)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: listening)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: alphabet)),
      ],
    );
  }
}
