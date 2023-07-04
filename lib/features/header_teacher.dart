import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class HeaderTeacher extends StatelessWidget {
  final NameCubit cubit;
  HeaderTeacher({Key? key})
      : cubit = NameCubit(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: cubit,
        builder: (c, s) => Container(
              padding: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  left: Resizable.padding(context, 100),
                  right: Resizable.padding(context, 100),
                  top: Resizable.padding(context, 10)),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1), color: Colors.grey, blurRadius: 2)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  s == null
                      ? const CircularProgressIndicator()
                      : Text('$s ${AppText.txtSensei.text}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 40))),
                  SizedBox(width: Resizable.padding(context, 10)),
                  CircleAvatar(
                    radius: Resizable.size(context, 15),
                    backgroundColor: greyColor.shade300,
                  ),
                ],
              ),
            ));
  }
}

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null) {
    load();
  }
  load() async {
    emit(await UserRepository.getName());
  }
}
