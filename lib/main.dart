import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "==================> ${MediaQuery.of(context).size.width} == ${MediaQuery.of(context).size.height} == ${Resizable.isTablet(context)}");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Home",
                style: TextStyle(
                    fontSize: //20
                        Resizable.font(context, 20))),
            Text("Home", style: TextStyle(fontSize: 20))
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text("Internal Sakumi",
                      style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 10),
                Container(
                  height: Resizable.size(context, 100),
                  width: Resizable.size(context, 100),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 20))),
                  child: Text("Internal Sakumi",
                      style: TextStyle(
                          fontSize: //16
                              Resizable.font(context, 16))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
