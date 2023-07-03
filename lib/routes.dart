import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/empty_screen.dart';
import 'package:internal_sakumi/screens/teacher_screen.dart';

class Routes {
  static FluroRouter router = FluroRouter();

  static const splash = "/";

  static const login = "/login";
  static const home = "/home";

  static const admin = "/admin";
  static const classes = "/classes";
  static const detailClass = "/detailClass";
  static const addClass = "/addClass";
  static const addStudent = "/addStudent";
  static const detailStudent = "/detailStudent";
  static const addUserToClass = "/addUserToClass";

  static const master = "/master";
  static const addTeacher = "/addTeacher";

  static const teacher = "/teacher";

  static const profile = "/profile";
  static const changePassword = "/changePassword";

  static const lesson = '/lesson';
  static const empty = '/empty';

  static const demoSimple = "/demo";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(teacher,
        handler: teacherHandler, transitionType: TransitionType.fadeIn);
  }
}

var emptyHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return const EmptyScreen();
});

var teacherHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  return TeacherScreen(params['name']?.first);
});

// var demoRouteHandler =
//     Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//   String? message = params["message"]?.first;
//   // String? colorHex = params["color_hex"]?.first;
//   // String? result = params["result"]?.first;
//   // Color color = Color(0xFFFFFFFF);
//   // if (colorHex != null && colorHex.length > 0) {
//   //   color = Color(ColorHelpers.fromHexString(colorHex));
//   // }
//   return DemoSimpleComponent(message: message ?? 'Testing');
// });
//
// class DemoSimpleComponent extends StatelessWidget {
//   // DemoSimpleComponent(
//   //     {String message = "Testing",
//   //     Color color = const Color(0xFFFFFFFF),
//   //     String? result})
//   //     : this.message = message,
//   //       this.color = color,
//   //       this.result = result;
//   const DemoSimpleComponent({Key? key, this.message = "Testing"})
//       : super(key: key);
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(message),
//           Padding(
//             padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0),
//             child: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.green,
//                 height: 2.0,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 15.0),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: 42.0),
//               child: TextButton(
//                 onPressed: () {
//                   FluroRouter.appRouter.pop(context);
//                 },
//                 child: Text(
//                   "OK",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
