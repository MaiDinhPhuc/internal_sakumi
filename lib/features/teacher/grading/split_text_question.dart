
import 'package:flutter/Material.dart';
import 'package:flutter/gestures.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SplitTextCustom extends StatelessWidget {
  const SplitTextCustom({
    super.key,
    required this.text,
    this.kanjiSize = 22,
    this.kanjiColor = Colors.black,
    this.kanjiFW = FontWeight.w500,
    this.phoneticFW = FontWeight.w500,
    this.phoneticSize = 10,
    this.vieSize = 14,
    this.phoneticColor = Colors.black,
    this.vieColor = const Color(0xff757575),
    this.isParagraph = false,
    this.vText = '',
    this.isTitle = false,
    this.maxLines,
    this.onShowWord,
    this.foreground,
    this.isReading = false,
    this.isUsingResize = true,
    this.isSelected = false,
    this.isCenter = false,
  });

  final String text;
  final String vText;
  final double kanjiSize;
  final Color kanjiColor;
  final FontWeight kanjiFW;
  final Color phoneticColor;
  final double phoneticSize;
  final FontWeight phoneticFW;
  final double vieSize;
  final Color vieColor;
  final bool isParagraph;
  final bool isTitle;
  final int? maxLines;
  final bool isReading;
  final Function? onShowWord;
  final Paint? foreground;
  final bool isUsingResize;
  final bool isSelected;
  final bool isCenter;
  @override
  Widget build(BuildContext context) {
    var listString = <String>[];
    if (!isReading) {
      listString = SplitText().splitGrammarString(text);
    } else {
      var spl1 = SplitText().extractSentencesReading(text);
      for (var item in spl1) {
        if (!(item.contains('[') &&
            item.contains(']') &&
            item.contains('||'))) {
          listString.addAll(SplitText().splitGrammarString(item));
        } else {
          listString.add(item);
        }
      }
    }
    var listSpans = <TextSpan>[];
    for (var e in listString) {
      var item = e;
      var type = checkType(item);
      if ([0, 1, 2, 3].contains(type)) {
        createTextSpan(context, type, item, listSpans);
      } else if (type == 4) {
        var text = item.replaceAll('[', '').replaceAll(']', '');

        var spl = text.split('||');
        var id = spl[1];
        var listSpl = SplitText().splitGrammarString(spl[0]);
        for (var i in listSpl) {
          var newType = checkType(i);
          createTextSpan(context, newType, i, listSpans, int.parse(id));
        }
      }
    }
    return IgnorePointer(
      ignoring: !isReading,
      child: Column(
        crossAxisAlignment: isParagraph ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          if (text.isNotEmpty)
            Container(
              transform: Matrix4.translationValues(0, 3, 0),
              child: RichText(
                maxLines: maxLines,
                textAlign: isParagraph ? TextAlign.start : TextAlign.center,
                text: TextSpan(
                  children: listSpans,
                ),
              ),
            ),
          SizedBox(height: Resizable.padding(context, 2),),
          if (vText.isNotEmpty)
            Builder(builder: (context) {
              List<TextSpan> spans = [];
              List<String> parts = vText.split(RegExp(r'<|>'));
              for (int i = 0; i < parts.length; i++) {
                if (i % 2 == 0) {
                  spans.add(TextSpan(
                      text: parts[i],
                      style: TextStyle(
                        color: vieColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                      )));
                } else {
                  spans.add(TextSpan(
                      text: parts[i],
                      style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          color: primaryColor)));
                }
              }

              RichText richText = RichText(
                textAlign: isParagraph ? TextAlign.start : TextAlign.center,
                text: TextSpan(
                    children: spans,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: !isUsingResize
                            ? vieSize
                            : Resizable.font(context, vieSize))),
              );
              return richText;
            }),

        ],
      ),
    );
  }

  void addSpanType2or3(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    int start = item.indexOf('{');
    int end = item.indexOf('}');
    if (start != -1 && end != -1) {
      String contents = item.substring(start + 1, end);
      if (contents.contains('|')) {
        List<String> parts = contents.split('|');
        if (parts.length == 2) {
          var kanjiStyle = TextStyle(
              fontWeight: isTitle || type == 3 ? FontWeight.w700 : kanjiFW,
              fontSize: !isUsingResize
                  ? kanjiSize
                  : Resizable.font(context, kanjiSize),
              foreground: foreground,
              color: foreground != null
                  ? null
                  : isTitle || type == 3
                  ? isSelected
                  ? Colors.black
                  : primaryColor
                  : kanjiColor,

              fontFamily: 'GenShinGothic');
          var phoneticStyle = TextStyle(
              fontFamily: 'GenShinGothic',
              fontSize: !isUsingResize
                  ? phoneticSize
                  : Resizable.font(context, phoneticSize),
              fontWeight: phoneticFW,
              foreground: foreground,
              color: foreground != null ? null : phoneticColor);

          listSpans.add(SplitTextSpan.japanType2or3(
              phonetic: parts[1],
              kanji: parts[0],
              kanjiStyle: kanjiStyle,
              phoneticStyle: phoneticStyle,
              onClick: id == -1
                  ? null
                  : () {
                onShowWord!(id);
              }));
        }
      } else {
        var style = TextStyle(
            fontWeight:
            isTitle || type == 3 ? FontWeight.w700 : FontWeight.w500,
            fontSize:
            !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
            foreground: foreground,
            color: foreground != null
                ? null
                : isTitle || type == 3
                ? primaryColor
                : kanjiColor,
            fontFamily: 'GenShinGothic');

        listSpans.add(SplitTextSpan.japanType1orDefault(
            style: style,
            text: contents,
            onClick: id == -1
                ? null
                : () {
              onShowWord!(id);
            }));
      }
    }
  }

  void addSpanType0(
      BuildContext context, int type, String item, List<TextSpan> listSpans) {
    if (CustomCheck.isVietnameseCharacter(item)) {
      var style = TextStyle(
        fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
        fontSize:
        !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
        foreground: foreground,
        color: foreground != null
            ? null
            : isTitle
            ? primaryColor
            : kanjiColor,
      );
      listSpans
          .add(SplitTextSpan.japanType1orDefault(style: style, text: item));
    } else {
      var listS = <TextSpan>[];
      List<String> words = item.split('');
      for (var k in words) {
        var style = TextStyle(
            fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
            fontSize:
            !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
            color: foreground != null
                ? null
                : isTitle
                ? primaryColor
                : kanjiColor,
            foreground: foreground,
            fontFamily:
            CustomCheck.isVietnameseCharacter(k) ? null : 'GenShinGothic');
        listS.add(SplitTextSpan.japanType1orDefault(style: style, text: k));
      }
      listSpans.addAll(listS);
    }
  }

  void addSpanType1(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    final RegExp pattern = RegExp(r'<(.*?)>');
    final match = pattern.firstMatch(item);
    if (match != null) {
      var type1 = match.group(1)!;
      if (CustomCheck.isVietnameseCharacter(type1)) {
        var style = TextStyle(
          fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
          fontSize:
          !isUsingResize ? kanjiSize : Resizable.font(context, kanjiSize),
          color: foreground != null
              ? null
              : isSelected
              ? Colors.black
              : primaryColor,
          foreground: foreground,
        );
        listSpans.add(SplitTextSpan.japanType1orDefault(
            style: style,
            text: type1,
            onClick: id == -1
                ? null
                : () {
              onShowWord!(id);
            }));
      } else {
        var listS = <TextSpan>[];
        List<String> words = type1.split('');
        for (var k in words) {
          var style = TextStyle(
              fontWeight: isTitle ? FontWeight.w700 : kanjiFW,
              fontSize: !isUsingResize
                  ? kanjiSize
                  : Resizable.font(context, kanjiSize),
              color: foreground != null
                  ? null
                  : isSelected
                  ? Colors.black
                  : primaryColor,
              foreground: foreground,
              fontFamily: CustomCheck.isVietnameseCharacter(k)
                  ? null
                  : 'GenShinGothic');
          listS.add(SplitTextSpan.japanType1orDefault(
              style: style,
              text: k,
              onClick: id == -1
                  ? null
                  : () {
                onShowWord!(id);
              }));
        }
        listSpans.addAll(listS);
      }
    }
  }

  void createTextSpan(
      BuildContext context, int type, String item, List<TextSpan> listSpans,
      [int id = -1]) {
    if (type == 0) {
      addSpanType0(context, type, item, listSpans);
    } else if (type == 1) {
      addSpanType1(context, type, item, listSpans, id);
    } else if (type == 2 || type == 3) {
      addSpanType2or3(context, type, item, listSpans, id);
    }
  }
}

int checkType(String s) {
  if (isStringValidType4(s)) return 4;
  if (isStringValidType3(s)) return 3;
  if (isStringValidType2(s)) return 2;
  if (isStringValidType1(s)) return 1;
  return 0;
}

bool isStringValidType1(String input) {
  final RegExp pattern = RegExp(r'^<[^<>]+>$');
  return pattern.hasMatch(input);
}

bool isStringValidType2(String input) {
  final RegExp pattern = RegExp(r'^\{[^{}]+\}$');
  return pattern.hasMatch(input);
}

bool isStringValidType3(String input) {
  final RegExp pattern = RegExp(r'^<\{[^{}]+\}>$');
  return pattern.hasMatch(input);
}

bool isStringValidType4(String input) {
  return input.contains('[') && input.contains(']') && input.contains('||');
}

// bool isStringValidType4(String input) {
//   final RegExp pattern = RegExp(r'<\{[^{}]+\}[^{}]+>');
//   return pattern.hasMatch(input);
// }

class SplitText {
  List<String> splitJapanese(String text) {
    List<String> a = [];
    List<String> pairs = text.split('}');
    for(int i = 0 ; i< pairs.length; i++)
    {
      var k = pairs[i].split('{');
      for(int n =0 ; n< k.length;n++) {
        a.add(k[n]);
      }
    }
    return a;
  }
  List<String> splitFuriganaVoc(String text) {
    return text.split(',');
  }
  String getBehind(String pair) {
    return pair.substring(pair.indexOf('|') + 1, pair.length).trim();
  }

  String getFront(String pair) {
    return pair.substring(0, pair.indexOf('|')).trim();
  }

  List<String> extractPathDataList(String inputString) {
    final regex = RegExp(r'<path d="([^"]+)"\/>');
    final matches = regex.allMatches(inputString);

    final pathDataList = <String>[];
    for (final match in matches) {
      final pathData = match.group(1);
      pathDataList.add(pathData!);
    }

    return pathDataList;
  }

  List<String> extractRhythmKanji(String text) {
    return text.split('/');
  }
  List<int> extractVocabularies(String text) {
    var listVoc = <int>[];
    final list = text.split(';');
    for(var item in list){
      listVoc.add(int.parse(item.trim()));
    }
    return listVoc;
  }

  List<String> splitGrammarString(String input) {
    try {

      List<String> parts = [];
      final RegExp pattern = RegExp(r'(\{.*?\}|<.*?>|。|[^<{}。]+)');

      for (RegExpMatch match in pattern.allMatches(input)) {
        parts.add(match.group(0)!);
      }

      return parts;
    }
    catch (e) {
      return [input];
    }
  }
  List<Map<String, dynamic>> splitSentence(String japaneseText) {
    try {
      List<Map<String, dynamic>> resultList = [];

      int start = 0;
      int end = -1;

      for (int i = 0; i < japaneseText.length; i++) {
        if (japaneseText[i] == '[' || japaneseText[i] == '{') {
          start = i + 1;
        } else if (japaneseText[i] == ']' || japaneseText[i] == '}') {
          String previous = japaneseText.substring(end +1 , start - 1);
          resultList.add({
            'text': previous,
            'highlight': false,
          });
          end = i;
          String segment = japaneseText.substring(start, end);
          resultList.add({
            'text': segment,
            'highlight': true,
          });
        }

        if(i == japaneseText.length - 1 && i != end) {
          String segment = japaneseText.substring(end + 1 , japaneseText.length);
          resultList.add({
            'text': segment,
            'highlight': false,
          });
        }
      }
      return resultList;
    }
    catch (e) {
      return [
        {
          'text': japaneseText,
          'highlight': false,
        }
      ];
    }
  }

  String getId(String s) {
    int lastDotIndex = s.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return  s.substring(0, lastDotIndex); // Lấy phần tử từ đầu đến dấu chấm cuối cùng
    } else {
      return s;
    }
  }

  List<String> splitKaiwaString(String input) {
    try {
      List<String> parts = [];
      final RegExp regex =   RegExp(r'\S+\|\S+|\S+');
      for (RegExpMatch match in regex.allMatches(input)) {
        parts.add(match.group(0)!);
      }
      return parts;
    }
    catch (e) {
      return [input];
    }
  }

  List<String> splitMatchColumn(String input, String separator) {
    List<String> resultList = [];
    StringBuffer currentToken = StringBuffer();
    int nestedLevel = 0;

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '{') {
        nestedLevel++;
      } else if (input[i] == '}') {
        nestedLevel--;
      }

      if (input[i] == separator && nestedLevel == 0) {
        resultList.add(currentToken.toString());
        currentToken.clear();
      } else {
        currentToken.write(input[i]);
      }
    }
    resultList.add(currentToken.toString());
    return resultList;
  }

  List<String> extractSentencesReading(String input) {
    List<String> parts = [];
    RegExp exp = RegExp(r'\[.*?\]');
    Iterable<Match> matches = exp.allMatches(input);

    int start = 0;
    for (Match match in matches) {
      if (match.start > start) {
        parts.add(input.substring(start, match.start));
      }
      parts.add(match.group(0)!);
      start = match.end;
    }

    if (start < input.length) {
      parts.add(input.substring(start));
    }

    return parts;
  }
}

class SplitTextSpan {
  static TextSpan japanType1orDefault({
    required TextStyle style,
    required String text,
    Function? onClick,
  }) {
    return TextSpan(
      text: text,
      style: style.copyWith(

        decoration: onClick == null ? null : TextDecoration.underline,
        decorationStyle:  onClick == null ? null : TextDecorationStyle.dashed,
        decorationColor: onClick == null ? null : primaryColor,
        decorationThickness: onClick == null ? null : 1.5,
      ),

      recognizer:  TapGestureRecognizer()
        ..onTap = () {

          if(onClick == null) return;
          onClick();// Call the function when tapped
        },
    );
  }


  static TextSpan japanType2or3({
    required TextStyle kanjiStyle,
    required TextStyle phoneticStyle,
    required String kanji,
    required String phonetic,
    Function? onClick,

  }) {
    return  TextSpan(
        style: kanjiStyle.copyWith(
          decoration: onClick == null ? null : TextDecoration.underline,
          decorationStyle:  onClick == null ? null : TextDecorationStyle.dashed,
          decorationColor: onClick == null ? null : primaryColor,
          decorationThickness: onClick == null ? null : 1.5,
        ),
        text: '\u200C',

        children: <InlineSpan>[
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.bottom,

            child: GestureDetector(
              onTap: onClick ==null ? null : (){
                onClick();

              },
              child: Container(
                transform: Matrix4.translationValues(0, -3.25, 0),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(phonetic, style: phoneticStyle),
                    Text(kanji,
                        style: kanjiStyle.copyWith(
                            height: 1.1,
                            fontWeight: FontWeight.w700
                        )),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }

}


class CustomCheck {
  static bool isVietnameseCharacter(String character) {
    final RegExp regex = RegExp(r'^[a-zA-ZÀ-ỹĂ-ửẠ-ỹẰ-ỶẢ-ỸẲ-ỶÂ-ỬĂ-ỰĐđĨŨẼỄỖỐ0-9!@#\$%^&*(),.?":{}|<>+=\-\[\]\\/\s]*$');
    return regex.hasMatch(character);
  }
}