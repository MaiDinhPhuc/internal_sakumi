// import 'package:flutter/material.dart';
// import 'package:internal_sakumi/utils/resizable.dart';
//
// class InputFieldWidget extends StatelessWidget {
//   const InputFieldWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 20)),
//       child: TextFormField(
//         onChanged: (v) {},
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.only(
//               left: Resizable.padding(context, 16),
//               bottom: Resizable.padding(context, 12),
//               top: Resizable.padding(context, 12)),
//           fillColor: ModeUtils.whiteBackground(context),
//           suffixIcon: Card(
//             shape: const CircleBorder(),
//             elevation: 0,
//             color: ModeUtils.highlightColor(context),
//             margin: EdgeInsets.all(Resizable.size(context, 12)),
//             child: InkWell(
//               onTap: () => searchController.delete(),
//               borderRadius: BorderRadius.circular(1000),
//               child: Icon(Icons.close,
//                   size: Resizable.size(context, 20),
//                   color: AppConfigs.greyColor.shade300),
//             ),
//           ),
//           filled: true,
//           hintText: AppText.txtNewsSearchHint.text,
//           hintStyle: TextStyle(
//               fontSize: Resizable.font(context, 16),
//               fontWeight: FontWeight.w400,
//               color: AppConfigs.greyColor.shade700),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//                 width: Resizable.size(context, 1),
//                 color: ModeUtils.whiteBackground(context)),
//             borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
//           ),
//         ),
//       ),
//     );
//   }
// }
