import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageGeneralScreen extends StatelessWidget {
  const ManageGeneralScreen(
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ahihih')),
      // body: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      //   child: Row(
      //     children: [
      //       Expanded(child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //
      //           ],
      //         ),
      //       )),
      //       Expanded(child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //             Expanded(flex: 1, child: Container()),
      //             Expanded(flex: 1, child: Container())
      //           ],
      //         ),
      //       ))
      //     ],
      //   ),
      // )
    );
  }
}

class ManageGeneralCubit extends Cubit<int>{
  ManageGeneralCubit() : super(0);

}