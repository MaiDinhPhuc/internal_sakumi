import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ChooseTestTime extends StatelessWidget {
  const ChooseTestTime(this.cubit, {super.key});
  final ChooseTestTimeCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseTestTimeCubit, int>(
        bloc: cubit,
        builder: (c,s){
          return Container(
            margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            width: Resizable.size(context, 400),
            height: Resizable.size(context, 30),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: cubit.hour,
                        isDense: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xffE0E0E0),
                              width: Resizable.size(context, 0.5)),
                          borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 5)),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(Resizable.padding(context, 5)),
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5))),
                      ),
                      onChanged: (value) {
                        cubit.inputHour(value);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 5)),
                    child: Text(
                      ":",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    )),
                Expanded(
                    flex: 1,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: cubit.minute,
                        isDense: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xffE0E0E0),
                              width: Resizable.size(context, 0.5)),
                          borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 5)),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(Resizable.padding(context, 5)),
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5))),
                      ),
                      onChanged: (value) {
                        cubit.inputMinute(value);
                      },
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 5)),
                    child: Text(
                      ":",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    )),
                Expanded(
                    flex: 1,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: cubit.second,
                        isDense: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color(0xffE0E0E0),
                              width: Resizable.size(context, 0.5)),
                          borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 5)),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(Resizable.padding(context, 5)),
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5))),
                      ),
                      onChanged: (value) {
                        cubit.inputSecond(value);
                      },
                    )),
                Expanded(
                    flex: 5,
                    child:Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 5)),
                        child: Text(
                          "${cubit.hour} giờ ${cubit.minute} phút ${cubit.second} giây",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 20)),
                        ))
                )
              ],
            ),
          );
        }) ;
  }
}

class ChooseTestTimeCubit extends Cubit<int> {
  ChooseTestTimeCubit() : super(0);
  String hour = "00";
  String minute = "00";
  String second = "00";

  loadTime(int time){
    if(time != 0){
      Duration duration = Duration(seconds: time);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;

      hour = hours == 0 ? "00" : hours.toString();
      minute = minutes == 0 ? "00" : minutes.toString();
      second = seconds == 0 ? "00" : seconds.toString();

      emit(state+1);

    }
  }

  inputHour(newValue) {
    hour = newValue;
    emit(state+1);
  }

  inputMinute(newValue) {
    minute = newValue;
    emit(state+1);
  }

  inputSecond(newValue) {
    second = newValue;
    emit(state+1);
  }

  int convertTime() {
    var hour = int.parse(this.hour);
    var minute = int.parse(this.minute);
    var second = int.parse(this.second);

    return hour * 3600 + minute * 60 + second;
  }
}
