import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class NoteForTeamCard extends StatelessWidget {
  final String hintText, noNote;
  final SessionCubit sessionCubit;
  final Function() onPressed;
  final Function(String v) onChanged;
  final bool? active;
  const NoteForTeamCard(this.active,
      {required this.hintText,
      required this.noNote,
      required this.onChanged,
      required this.onPressed,
      required this.sessionCubit,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, int>(
        bloc: sessionCubit,
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

// class CheckBoxCubit extends Cubit<int> {
//   CheckBoxCubit() : super(0);
//
//   bool? isShow = false;
//   String textNote = '';
//
//   input(String text){
//     textNote = text;
//     emit(state+1);
//   }
//   check(bool? check) {
//     isShow = check;
//     emit(state+1);
//   }
// }
//
// class NoteTeamCard extends StatelessWidget {
//   final String hintText, noNote;
//   final SessionCubit cubit;
//   final Function() onPressed;
//   final Function(String v) onChanged;
//   NoteTeamCard(
//       {required this.hintText,
//       required this.noNote,
//       required this.onChanged,
//       required this.onPressed,
//       Key? key})
//       : cubit = SessionCubit(),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CheckBoxCubit(),
//         child: BlocBuilder<CheckBoxCubit, int>(
//             builder: (c, _) => Container(
//                   margin: EdgeInsets.only(
//                       top: Resizable.padding(context, 10),
//                       bottom: Resizable.padding(context, 10),
//                       right: Resizable.padding(context, 150),
//                       left: Resizable.padding(context, 150)),
//                   padding: EdgeInsets.all(Resizable.padding(context, 5)),
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                       color: greyColor.shade50,
//                       borderRadius: BorderRadius.circular(
//                           Resizable.padding(context, 10))),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         //controller: controller,
//                         autofocus: true,
//                         initialValue: '',
//                         decoration: InputDecoration(
//                           enabled: BlocProvider.of<CheckBoxCubit>(c).isShow == true ? false : true,
//                           hintText: BlocProvider.of<CheckBoxCubit>(c).isShow == true ? noNote : hintText,
//                           hintStyle: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: Resizable.font(context, 18)),
//                           fillColor: greyColor.shade50,
//                           hoverColor: greyColor.shade50,
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: BorderRadius.circular(
//                                 Resizable.padding(context, 10)),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                             borderRadius: BorderRadius.circular(
//                                 Resizable.padding(context, 10)),
//                           ),
//                           filled: true,
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   Resizable.padding(context, 10)),
//                               borderSide: BorderSide.none),
//                         ),
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         minLines: 2,
//                         onChanged: (v){
//                           if(v.isNotEmpty) {
//                             BlocProvider.of<CheckBoxCubit>(c).isShow = null;
//                           } else{
//                             BlocProvider.of<CheckBoxCubit>(c).isShow = false;
//                           }
//                           BlocProvider.of<CheckBoxCubit>(c).input(v);
//                           debugPrint('=================> input input ${BlocProvider.of<CheckBoxCubit>(c).isShow}');
//                         },
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             right: Resizable.padding(context, 10)),
//                         child: (BlocProvider.of<CheckBoxCubit>(c).isShow != null)
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                       onPressed: (){
//                                         if(BlocProvider.of<CheckBoxCubit>(c).textNote.isNotEmpty){
//                                           //BlocProvider.of<CheckBoxCubit>(c).isShow = null;
//                                           BlocProvider.of<CheckBoxCubit>(c).check(null);
//                                         }
//                                         else{
//                                           //BlocProvider.of<CheckBoxCubit>(c).isShow == true ? false : true;
//                                           BlocProvider.of<CheckBoxCubit>(c).check(BlocProvider.of<CheckBoxCubit>(c).isShow == true ? false : true);
//                                         }
//                                         BlocProvider.of<SessionCubit>(c).isNoteSupport = BlocProvider.of<CheckBoxCubit>(c).isShow;
//                                         //BlocProvider.of<SessionCubit>(c).updateUI();
//                                       },
//                                       splashRadius: Resizable.size(context, 10),
//                                       icon: BlocProvider.of<CheckBoxCubit>(c).isShow == true
//                                           ? const Icon(
//                                               Icons.check_box,
//                                               color: primaryColor,
//                                             )
//                                           : const Icon(
//                                               Icons.check_box_outline_blank)),
//                                   Text(noNote,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize:
//                                               Resizable.font(context, 20)))
//                                 ],
//                               )
//                             : Opacity(
//                                 opacity: 0,
//                                 child: IconButton(
//                                     onPressed: () {},
//                                     splashRadius: Resizable.size(context, 10),
//                                     icon: const Icon(
//                                         Icons.check_box_outline_blank))),
//                       )
//                     ],
//                   ),
//                 )));
//   }
// }
