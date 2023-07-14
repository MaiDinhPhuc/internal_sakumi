import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ListClassView extends StatelessWidget {
  const ListClassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadListClassCubit()..load(context),
      child: BlocBuilder<LoadListClassCubit, List<ClassModel>>(
          key: Key("${LoadListClassCubit().state.length}"),
          builder: (c, list) {
            debugPrint(
                "======== ========= =========== ${LoadListClassCubit().state.length} == ${list.length}");
            return list.isEmpty
                ? Center(
                    child: SizedBox(
                      height: Resizable.size(context, 40),
                      width: Resizable.size(context, 40),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 200)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Resizable.size(context, 20)),
                              ...list
                                  .map((e) => Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                Resizable.padding(context, 5)),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryColor,
                                              width:
                                                  Resizable.size(context, 1)),
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                        ),
                                        child: InkWell(
                                            onTap: () => Navigator.pushNamed(
                                                context, Routes.detailClass,
                                                arguments: {'classModel': e}),
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Resizable.padding(
                                                      context, 10),
                                                  horizontal: Resizable.padding(
                                                      context, 20)),
                                              child: Row(
                                                children: [
                                                  Text(e.classCode,
                                                      style: TextStyle(
                                                          fontSize:
                                                              Resizable.font(
                                                                  context, 18)))
                                                ],
                                              ),
                                            )),
                                      ))
                                  .toList(),
                              SizedBox(height: Resizable.size(context, 50)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(
                            bottom: Resizable.padding(context, 20),
                            right: Resizable.padding(context, 20)),
                        child: Stack(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: Resizable.size(context, 30),
                                height: Resizable.size(context, 30),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius:
                                              Resizable.size(context, 5))
                                    ]),
                                child: Icon(
                                  Icons.add,
                                  size: Resizable.size(context, 20),
                                  color: Colors.white,
                                )),
                            Positioned.fill(
                                child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(1000),
                                onTap: () => Navigator.pushNamed(
                                    context, Routes.addClass,
                                    arguments: {'classModel': null}),
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}

class LoadListClassCubit extends Cubit<List<ClassModel>> {
  LoadListClassCubit() : super([]);

  load(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    List<ClassModel> list = await adminRepository.getListClass();
    emit(list);
  }
}
