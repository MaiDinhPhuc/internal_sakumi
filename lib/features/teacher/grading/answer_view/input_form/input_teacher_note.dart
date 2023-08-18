import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputTeacherNote extends StatelessWidget {
  const InputTeacherNote({super.key, required this.noteController, required this.onChange, required this.onOpenFile, required this.onOpenMic});
  final TextEditingController noteController;
  final Function(String) onChange;
  final Function() onOpenFile;
  final Function() onOpenMic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: TextField(
        style: TextStyle(
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        controller: noteController,
        decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
          hoverColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5)),
            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          ),
          filled: true,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: onOpenFile,
                child: Container(
                    margin: EdgeInsets.all(Resizable.padding(context, 5) ),
                    child: Image.asset(
                        'assets/images/ic_file.png',
                        scale: 5))
              ),
              InkWell(
                onTap: onOpenMic,
                child: Container(
                    margin: EdgeInsets.all(Resizable.padding(context, 5)),
                    padding: EdgeInsets.only(right: Resizable.padding(context, 5)),
                    child: Image.asset(
                        'assets/images/ic_mic.png',
                        scale: 5)),
              )
            ],
          ),
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Resizable.padding(context, 5)),
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5))),
        ),
        keyboardType: TextInputType.multiline,
        maxLines:  1,
        minLines: 1,
        onChanged: onChange,
      ),
    );
  }
}
