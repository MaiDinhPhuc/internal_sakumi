import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lesson_teaching_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class NoteForTeamCard extends StatelessWidget {
  final TextEditingController controller;
  final String hintText, noNote;
  const NoteForTeamCard(
      {required this.hintText,
      required this.noNote,
      required this.controller,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<CheckBoxCubit>(context);
    return Container(
      margin: EdgeInsets.only(
          top: Resizable.padding(context, 10),
          bottom: Resizable.padding(context, 10),
          right: Resizable.padding(context, 150),
          left: Resizable.padding(context, 150)),
      padding: EdgeInsets.all(Resizable.padding(context, 5)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: greyColor.shade50,
          borderRadius: BorderRadius.circular(Resizable.padding(context, 10))),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              enabled: cubit.state == true ? false : true,
              hintText: cubit.state == true ? noNote : hintText,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Resizable.font(context, 18)),
              fillColor: greyColor.shade50,
              hoverColor: greyColor.shade50,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 10)),
              ),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Resizable.padding(context, 10)),
                  borderSide: BorderSide.none),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 2,
            onChanged: (v) {
              cubit.check(v.isNotEmpty ? null : false);
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: Resizable.padding(context, 10)),
            child: (cubit.state != null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () =>
                              cubit.check(cubit.state == true ? false : true),
                          splashRadius: Resizable.size(context, 10),
                          icon: cubit.state == true
                              ? const Icon(
                                  Icons.check_box,
                                  color: primaryColor,
                                )
                              : const Icon(Icons.check_box_outline_blank)),
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
                        icon: const Icon(Icons.check_box_outline_blank))),
          )
        ],
      ),
    );
  }
}
