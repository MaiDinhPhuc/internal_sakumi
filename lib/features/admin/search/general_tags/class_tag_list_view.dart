import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/object_tag_item.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../../configs/text_configs.dart';
import '../../../../model/manage_tag_model.dart';
import '../../../../model/tag_model.dart';
import '../../../../routes.dart';
import 'list_manage_tags_cubit.dart';

class ClassTagListView extends StatefulWidget {
  ClassTagListView({super.key, required this.list, required this.listTags})
      : classTagCubit = ClassTagCubit(list, listTags);

  final List<ManageTagModel> list;
  final List<TagModel> listTags;
  final ClassTagCubit classTagCubit;

  @override
  State<ClassTagListView> createState() => _ClassTagListViewState();
}

class _ClassTagListViewState extends State<ClassTagListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build again');
    final manageCubit = context.read<ListManageTagsCubit>();
    return BlocProvider.value(
      value: widget.classTagCubit..load(),
      child: BlocBuilder<ClassTagCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final cubit = context.read<ClassTagCubit>();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 15),
              vertical: Resizable.padding(context, 15),
            ),
            child: Column(
              children: [
                ...cubit.listClassTags.map((e) => ObjectTagItem(
                    onTap: () async {
                      await Navigator.pushNamed(context,
                          "${Routes.admin}/overview/class=${e.classModel.classId}");
                      manageCubit.update();
                    },
                    title: "${AppText.txtClassCode.text}: ${e.classModel.classCode}",
                    description: "${AppText.txtClassType.text}: ${e.classModel.classType == 0 ? "Lớp Chung" : "Lớp 1-1"}",
                    prefixIcon: Tooltip(
                        padding: EdgeInsets.all(Resizable.padding(context, 10)),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                                color: Colors.black,
                                width: Resizable.size(context, 1)),
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 5))),
                        richMessage: WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: vietnameseSubText(
                                        e.classModel.classStatus),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        child: Center(
                          child: Image.asset(
                            'assets/images/ic_${getIcon(e.classModel.classStatus)}.png',
                            scale: 50,
                          ),
                        )),
                    color: getColor(e.classModel.classStatus),
                    tags: e.listTags))
              ],
            ),
          );
        },
      ),
    );
  }
}

class ClassTagCubit extends Cubit<int> {
  ClassTagCubit(this.list, this.listTags) : super(0);
  final List<ManageTagModel> list;
  final List<TagModel> listTags;
  List<ClassTag> listClassTags = [];

  Future<List<ClassModel>> getClasses(List<ManageTagModel> list) async {
    List<Future<ClassModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getClassById(item.ownId));
    }
    List<ClassModel> classes = await Future.wait(futures);
    return classes;
  }
  load() async {
    var classes = await getClasses(list);
    for (var item in list) {
      var cl = classes.where((element) => element.classId == item.ownId).first;
      var tags = <TagModel>[];
      for (var k in item.tags) {
        var tag = listTags.where((element) => element.id == (k as int)).first;
        tags.add(tag);
      }
      listClassTags.add(ClassTag(
        classModel: cl,
        listTags: [...tags],
      ));
    }
    emit(state + 1);
  }
}

class ClassTag {
  final ClassModel classModel;
  final List<TagModel> listTags;

  const ClassTag({
    required this.classModel,
    required this.listTags,
  });
}

Color getColor(String status) {
  switch (status) {
    case 'InProgress':
      return const Color(0xff33691e);
    case 'Cancel':
    case 'Remove':
      return const Color(0xffB71C1C);
    case 'Completed':
    case 'Preparing':
      return const Color(0xff757575);
    default:
      return const Color(0xff33691e);
  }
}

String getIcon(String status) {
  switch (status) {
    case 'InProgress':
    case 'Preparing':
      return "in_progress";
    case 'Cancel':
    case 'Remove':
      return "dropped";
    case 'Completed':
      return "check";
    default:
      return "in_progress";
  }
}
