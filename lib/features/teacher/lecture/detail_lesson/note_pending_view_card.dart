import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class NoteInPendingCard extends StatelessWidget {
  const NoteInPendingCard(this.active,this.note,
      {super.key, required this.onPressed, required this.title, required this.isHardCode});
  final Function() onPressed;
  final bool isHardCode;
  final bool? active;
  final String note;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Resizable.padding(context, 10),
          bottom: Resizable.padding(context, 10),
          right: Resizable.padding(context, 150),
          left: Resizable.padding(context, 150)),
      padding: EdgeInsets.only(
          left: Resizable.padding(context, 15),
          top: Resizable.padding(context, 15),
          bottom: Resizable.padding(context, 5),
          right: Resizable.padding(context, 10)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: greyColor.shade50,
          borderRadius: BorderRadius.circular(Resizable.padding(context, 10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Resizable.font(context, 27))),
          if(isHardCode == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...listNoteBeforeLesson.map((e) => Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 10),
                        right: Resizable.padding(context, 15)),
                    child: Row(
                      children: [
                        Transform.translate(offset: Offset(0,-Resizable.padding(context, 8)),child: Container(
                          width: Resizable.size(context, 15),
                          height: Resizable.size(context, 15),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "${listNoteBeforeLesson.indexOf(e) + 1}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Resizable.font(context, 15),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10)),
                                child: Text(e,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: Resizable.font(context, 23)))))
                      ],
                    ))),
                Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 10),
                        right: Resizable.padding(context, 15)),
                    child: Row(
                      children: [
                        Container(
                          width: Resizable.size(context, 15),
                          height: Resizable.size(context, 15),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "5",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Resizable.font(context, 15),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 10)),
                              child: RichText(
                                text: TextSpan(
                                  text: "[LÀM NGAY]",
                                  style: TextStyle(fontSize: Resizable.font(context, 23), fontWeight: FontWeight.w700,color: primaryColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' Sensei nhớ bấm record + note link meet lên sheet. ',
                                      style: TextStyle(fontSize: Resizable.font(context, 23), fontWeight: FontWeight.w400, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          if(isHardCode == false)
            Text(note,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 23))),
          Padding(
            padding: EdgeInsets.only(right: Resizable.padding(context, 10)),
            child: (active != null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: onPressed,
                          splashRadius: Resizable.size(context, 10),
                          icon: active == true
                              ? const Icon(
                                  Icons.check_box,
                                  color: primaryColor,
                                )
                              : const Icon(Icons.check_box_outline_blank,
                                  color: primaryColor)),
                      Text(AppText.txtRead.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Resizable.font(context, 20),
                              color: primaryColor))
                    ],
                  )
                : Opacity(
                    opacity: 0,
                    child: IconButton(
                        onPressed: () {},
                        splashRadius: Resizable.size(context, 10),
                        icon: const Icon(Icons.check_box_outline_blank))),
          )
        ],
      ),
    );
  }
}

List<String> listNoteBeforeLesson = [
  "Nhắc nhở HV làm BTVN hằng ngày. Học chỉ có 2 tiếng, không nhớ nổi ➨ muốn học tốt phải làm BTVN.",
  "App có rất nhiều công cụ học tập. Muốn HV quen với app thì giáo viên phải dùng app trên lớp ÍT NHẤT 3 LẦN.",
  "Hỏi thăm HV vắng học hôm trước. Động viên HV không hiểu thì hỏi ngay. HV học chậm hay vắng nhiều có thể note support hỗ trợ bạn.",
  "Các phần quan trọng bắt buộc phải dạy. Phần luyện tập lớp có thể luyện ở trên app."
];
