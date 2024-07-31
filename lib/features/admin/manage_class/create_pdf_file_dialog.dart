import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html';

class CreatePdfFileDialog extends StatelessWidget {
  CreatePdfFileDialog({super.key, required this.classModel})
      : cubit = CreatePdfFileCubit(classModel);

  final ClassModel classModel;
  final CreatePdfFileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePdfFileCubit, int>(
        bloc: cubit..load(),
        builder: (context, state) {
          return cubit.isLoading
              ? const WaitingAlert()
              : Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height:
                          cubit.listStd.length * Resizable.size(context, 75),
                      padding: EdgeInsets.all(Resizable.padding(context, 20)),
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...cubit.listStd.map((e) => Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 3),
                                    horizontal: Resizable.padding(context, 10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 10),
                                    vertical: Resizable.padding(context, 5)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: Resizable.size(context, 1),
                                        color: greyColor.shade100),
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 5))),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 12,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(e.name),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await cubit.createPdfFile(e);
                                              },
                                              style: ButtonStyle(
                                                  shadowColor: WidgetStateProperty.all(
                                                      Colors.black),
                                                  shape: WidgetStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(
                                                              Resizable.padding(
                                                                  context, 3)))),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                          primaryColor),
                                                  padding: WidgetStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                          horizontal: Resizable.padding(context, 10)))),
                                              child: Text(
                                                  AppText.txtCreatePDFFile.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Resizable.font(
                                                          context, 16),
                                                      color: Colors.white)),
                                            ))),
                                  ],
                                ),
                              ))
                        ],
                      ))));
        });
  }
}

class CreatePdfFileCubit extends Cubit<int> {
  CreatePdfFileCubit(this.classModel) : super(0);

  final ClassModel classModel;
  List<LessonResultModel> listLessonResult = [];
  List<LessonModel> listLesson = [];
  List<StudentLessonModel> listStdLesson = [];
  List<StudentClassModel> listStdClass = [];
  List<StudentModel> listStd = [];
  bool isLoading = false;
  load() async {
    isLoading = true;
    emit(state + 1);
    listLessonResult = await FireBaseProvider.instance
        .getLessonResultByClassId(classModel.classId);
    listLesson = await FireBaseProvider.instance
        .getLessonsByLessonId(listLessonResult.map((e) => e.lessonId).toList());
    var lessonId = listLesson.map((e) => e.lessonId).toList();

    if (classModel.customLessons.isNotEmpty) {
      for (var i in classModel.customLessons) {
        if (!lessonId.contains(i['custom_lesson_id'])) {
          listLesson.add(LessonModel(
              lessonId: i['custom_lesson_id'],
              courseId: -1,
              description: i['description'],
              content: "",
              title: i['title'],
              btvn: -1,
              vocabulary: 0,
              listening: 0,
              kanji: 0,
              grammar: 0,
              flashcard: 0,
              alphabet: 0,
              order: 0,
              reading: 0,
              enable: true,
              customLessonInfo: i['lessons_info'],
              isCustom: true));
        }
      }
    }
    listStdLesson = await FireBaseProvider.instance
        .getAllStudentLessonsInClass(classModel.classId);

    listStdClass = (await FireBaseProvider.instance
            .getStudentClassInClass(classModel.classId))
        .where((e) => ![
              "Remove",
              "Dropped",
              "Deposit",
              "Retained",
              "Moved",
              "Viewer"
            ].contains(e.classStatus))
        .toList();

    listStd = await FireBaseProvider.instance
        .getAllStudentInFoInClass(listStdClass.map((e) => e.userId).toList());

    isLoading = false;
    emit(state + 1);
  }

  createPdfFile(StudentModel std) async {
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Montserrat-Regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/fonts/Montserrat-Bold.ttf")));
    final pdf = pw.Document(theme: myTheme);

    List<List<LessonResultModel>> subLists = [];
    int chunkSize = 10;

    for (var i = 0; i < listLessonResult.length; i += chunkSize) {
      subLists.add(listLessonResult.sublist(
          i,
          i + chunkSize > listLessonResult.length
              ? listLessonResult.length
              : i + chunkSize));
    }

    for (int k = 0; k < subLists.length; k++) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  if (k == 0)
                    pw.Text(classModel.classCode,
                        style: pw.TextStyle(
                            fontSize: 32, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  if (k == 0)
                    pw.Row(children: [
                      pw.Text("Họ tên: ",
                          style: const pw.TextStyle(fontSize: 18)),
                      pw.Text(std.name,
                          style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor(0.8901960784313725,
                                  0.24705882352941178, 0.39215686274509803)))
                    ]),
                  pw.SizedBox(height: 10),
                  for (int i = 0; i < subLists[k].length; i++)
                    pw.Column(children: [
                      pw.Table(
                          columnWidths: {
                            0: const pw.FixedColumnWidth(300),
                            1: const pw.FlexColumnWidth(),
                            2: const pw.FixedColumnWidth(64),
                          },
                          border: pw.TableBorder.all(),
                          children: <pw.TableRow>[
                            if (i == 0)
                              pw.TableRow(children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text("Buổi học"),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text("Điểm danh"),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text("Bài tập"),
                                ),
                              ]),
                            pw.TableRow(children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                                child: pw.Column(
                                    crossAxisAlignment:
                                    pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Padding(
                                          padding: const pw.EdgeInsets.symmetric(vertical: 5),
                                          child: pw.Text(getLessonTitle(
                                              subLists[k][i].lessonId))),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.only(bottom: 5),
                                        child: pw.Text(
                                            "Ngày học: ${DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(subLists[k][i].date))}"),

                                      )
                                       ])
                              ),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(getAttendance(
                                      subLists[k][i].lessonId, std.userId))),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(getBTVN(
                                      subLists[k][i].lessonId, std.userId))),
                            ])
                          ])
                    ])
                ]); // Center
          }));
    }

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "${std.name}_${classModel.classCode}.pdf")
      ..click();
    emit(1);
  }

  String getLessonTitle(int lessonId) {
    List<LessonModel> list =
        listLesson.where((e) => e.lessonId == lessonId).toList();

    if (list.isEmpty) return "Lỗi load data";

    return list.first.title;
  }

  String getAttendance(int lessonId, int stdId) {
    List<StudentLessonModel> list = listStdLesson
        .where((e) => e.lessonId == lessonId && e.studentId == stdId)
        .toList();
    if (list.isEmpty) return "Không có dữ liệu";

    switch (list.first.timekeeping) {
      case 0:
        return AppText.txtNotAttendance.text;
      case 1:
        return AppText.txtPresent.text;
      case 2:
        return AppText.txtInLate.text;
      case 3:
        return AppText.txtOutSoon.text;
      case 4:
        return "VT&RS";
      case 5:
        return AppText.txtPermitted.text;
      case 6:
        return AppText.txtAbsent.text;
      default:
        return "null";
    }
  }

  String getBTVN(int lessonId, int stdId) {
    List<StudentLessonModel> list = listStdLesson
        .where((e) => e.lessonId == lessonId && e.studentId == stdId)
        .toList();

    if (list.isEmpty) return "Không có dữ liệu";

    return list.first.hw! == -1
        ? AppText.textNotMarked.text.toUpperCase()
        : list.first.hw! > -1
            ? list.first.hw.toStringAsFixed(1)
            : AppText.txtNotSubmit.text.toUpperCase();
  }
  //
  // String getNote(int lessonId, int stdId){
  //   List<StudentLessonModel> list = listStdLesson.where((e)=>e.lessonId == lessonId && e.studentId == stdId).toList();
  //   if(list.isEmpty) return "Không có dữ liệu";
  //
  //   return list.first.teacherNote;
  // }
}
