import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class NoteForTeamCard extends StatelessWidget {
  final String hintText, noNote;
  final SessionCubit cubit;
  final Function() onPressed;
  final Function(String v) onChanged;
  final bool? active;
  NoteForTeamCard(this.active,
      {required this.hintText,
      required this.noNote,
      required this.onChanged,
      required this.onPressed,
      Key? key})
      : cubit = SessionCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, int>(
        bloc: cubit,
        builder: (c, _) => Container(
              margin: EdgeInsets.only(
                  top: Resizable.padding(context, 10),
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 150),
                  left: Resizable.padding(context, 150)),
              padding: EdgeInsets.all(Resizable.padding(context, 5)),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: greyColor.shade50,
                  borderRadius:
                      BorderRadius.circular(Resizable.padding(context, 10))),
              child: Column(
                children: [
                  TextFormField(
                    //controller: controller,
                    autofocus: true,
                    initialValue: '',
                    decoration: InputDecoration(
                      enabled: active == true ? false : true,
                      hintText: active == true ? noNote : hintText,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Resizable.font(context, 18)),
                      fillColor: greyColor.shade50,
                      hoverColor: greyColor.shade50,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(
                            Resizable.padding(context, 10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(
                            Resizable.padding(context, 10)),
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Resizable.padding(context, 10)),
                          borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    onChanged: onChanged,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: Resizable.padding(context, 10)),
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
                                      : const Icon(
                                          Icons.check_box_outline_blank)),
                              Text(noNote,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)))
                            ],
                          )
                        : Opacity(
                            opacity: 0,
                            child: IconButton(
                                onPressed: () {},
                                splashRadius: Resizable.size(context, 10),
                                icon:
                                    const Icon(Icons.check_box_outline_blank))),
                  )
                ],
              ),
            ));
  }
}

// class CheckBoxCubit extends Cubit<bool?> {
//   CheckBoxCubit() : super(false);
//
//   check(bool? isShow) {
//     emit(isShow);
//   }
// }
