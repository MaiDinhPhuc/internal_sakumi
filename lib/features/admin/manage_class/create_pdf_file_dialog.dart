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

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(children: [
                  pw.Expanded(
                      flex: 4,
                      child: pw.Column(children: [
                        pw.Text("CÔNG TY CỔ PHẦN GIẢI PHÁP",
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                        pw.Text("CÔNG NGHỆ PORO",
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                        pw.Container(
                            width: 100,
                            height: 1,
                            color: const PdfColor(0.19607843137254902,
                                0.19607843137254902, 0.19607843137254902)),
                        pw.SizedBox(height: 10),
                        pw.Text("TRUNG TÂM NHẬT NGỮ SAKUMI",
                            style: const pw.TextStyle(fontSize: 12)),
                      ])),
                  pw.Expanded(
                      flex: 5,
                      child: pw.Column(children: [
                        pw.Text("CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM",
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                        pw.Text("Độc lập - Tự do - Hạnh phúc",
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                        pw.Container(
                            width: 100,
                            height: 1,
                            color: const PdfColor(0.19607843137254902,
                                0.19607843137254902, 0.19607843137254902)),
                        pw.SizedBox(height: 10),
                        pw.Text(
                            "TP.HCM, ngày ${DateTime.now().day} tháng ${DateTime.now().month} năm ${DateTime.now().year}",
                            style: const pw.TextStyle(fontSize: 12))
                        // pw.Padding(
                        //   padding: const pw.EdgeInsets.only(right: 15),
                        //   child: ,
                        // )
                      ]))
                ]),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 15),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("BẢNG QUÁ TRÌNH HỌC TẬP",
                            style: pw.TextStyle(
                                fontSize: 21, fontWeight: pw.FontWeight.bold))
                      ]),
                ),
                pw.Row(children: [
                  pw.Text("Họ và tên học viên: ",
                      style: const pw.TextStyle(fontSize: 12)),
                  pw.Text(std.name,
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor(0.8901960784313725,
                              0.24705882352941178, 0.39215686274509803)))
                ]),
                pw.SizedBox(height: 10),
                pw.Row(children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Row(children: [
                      pw.Text("MSHV: ",
                          style: const pw.TextStyle(fontSize: 13)),
                      pw.Text(std.studentCode,
                          style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor(0.8901960784313725,
                                  0.24705882352941178, 0.39215686274509803)))
                    ]),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Row(children: [
                      pw.Text("Lớp: ", style: const pw.TextStyle(fontSize: 13)),
                      pw.Text(classModel.classCode,
                          style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor(0.8901960784313725,
                                  0.24705882352941178, 0.39215686274509803))),
                    ]),
                  ),
                  pw.Expanded(flex: 1, child: pw.Container()),
                ]),
                pw.SizedBox(height: 10),
                pw.Row(children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Row(children: [
                      pw.Text("Tỉ lệ đi học: ",
                          style: const pw.TextStyle(fontSize: 13)),
                      pw.Text(getAttendancePercent(std.userId),
                          style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor(0.8901960784313725,
                                  0.24705882352941178, 0.39215686274509803))),
                    ]),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Row(children: [
                      pw.Text("Tỉ lệ làm bài tập: ",
                          style: const pw.TextStyle(fontSize: 13)),
                      pw.Text(getHwPercent(std.userId),
                          style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor(0.8901960784313725,
                                  0.24705882352941178, 0.39215686274509803))),
                    ]),
                  ),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Row(children: [
                        pw.Text("Điểm trung bình: ",
                            style: const pw.TextStyle(fontSize: 13)),
                        pw.Text(
                            getGPAPoint(std.userId) == null
                                ? "Không có"
                                : getGPAPoint(std.userId)!.toStringAsFixed(1),
                            style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: const PdfColor(0.8901960784313725,
                                    0.24705882352941178, 0.39215686274509803))),
                      ])),
                ]),
                pw.SizedBox(height: 15),
                pw.Text("-  Chi tiết cụ thể như sau:",
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 15),
                for (int i = 0; i < subLists[0].length; i++)
                  classModel.classType == 1
                      ? pw.Column(children: [
                          pw.Table(
                              columnWidths: {
                                0: const pw.FixedColumnWidth(75),
                                1: const pw.FixedColumnWidth(200),
                                2: const pw.FixedColumnWidth(50),
                                3: const pw.FixedColumnWidth(50),
                                4: const pw.FixedColumnWidth(150),
                              },
                              border: pw.TableBorder.all(),
                              children: <pw.TableRow>[
                                if (i == 0)
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Ngày học",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Buổi học",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Điểm danh",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Bài tập",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Ghi chú",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  pw.FontWeight.bold))),
                                    ),
                                  ]),
                                pw.TableRow(children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(5),
                                    child: pw.Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                subLists[0][i].date)),
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getLessonTitle(
                                              subLists[0][i].lessonId),
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getAttendance(subLists[0][i].lessonId,
                                              std.userId),
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getBTVN(subLists[0][i].lessonId,
                                              std.userId),
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          subLists[0][i].noteForStudent,
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                ])
                              ])
                        ])
                      : pw.Column(children: [
                          pw.Table(
                              columnWidths: {
                                0: const pw.FixedColumnWidth(75),
                                1: const pw.FixedColumnWidth(200),
                                2: const pw.FixedColumnWidth(50),
                                3: const pw.FixedColumnWidth(50),
                              },
                              border: pw.TableBorder.all(),
                              children: <pw.TableRow>[
                                if (i == 0)
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Ngày học",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Buổi học",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Điểm danh",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold))),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Bài tập",
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold))),
                                    ),
                                  ]),
                                pw.TableRow(children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(5),
                                    child: pw.Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                subLists[0][i].date)),
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                  ),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getLessonTitle(
                                              subLists[0][i].lessonId),
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getAttendance(subLists[0][i].lessonId,
                                              std.userId),
                                          style: const pw.TextStyle(
                                              fontSize: 10))),
                                  pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          getBTVN(subLists[0][i].lessonId,
                                              std.userId),
                                          style:
                                              const pw.TextStyle(fontSize: 10)))
                                ])
                              ])
                        ])
              ]); // Center
        }));
    for (int k = 1; k < subLists.length; k++) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < subLists[k].length; i++)
                    classModel.classType == 1
                        ? pw.Column(children: [
                            pw.Table(
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(75),
                                  1: const pw.FixedColumnWidth(200),
                                  2: const pw.FixedColumnWidth(50),
                                  3: const pw.FixedColumnWidth(50),
                                  4: const pw.FixedColumnWidth(150),
                                },
                                border: pw.TableBorder.all(),
                                children: <pw.TableRow>[
                                  if (i == 0)
                                    pw.TableRow(children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Ngày học",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Buổi học",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Điểm danh",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Bài tập",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Ghi chú",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                    ]),
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      subLists[k][i].date)),
                                          style:
                                              const pw.TextStyle(fontSize: 10)),
                                    ),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getLessonTitle(
                                                subLists[k][i].lessonId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getAttendance(
                                                subLists[k][i].lessonId,
                                                std.userId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getBTVN(subLists[k][i].lessonId,
                                                std.userId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            subLists[k][i].noteForStudent,
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                  ])
                                ])
                          ])
                        : pw.Column(children: [
                            pw.Table(
                                columnWidths: {
                                  0: const pw.FixedColumnWidth(75),
                                  1: const pw.FixedColumnWidth(200),
                                  2: const pw.FixedColumnWidth(50),
                                  3: const pw.FixedColumnWidth(50),
                                },
                                border: pw.TableBorder.all(),
                                children: <pw.TableRow>[
                                  if (i == 0)
                                    pw.TableRow(children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Ngày học",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Buổi học",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Điểm danh",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Center(
                                            child: pw.Text("Bài tập",
                                                style: pw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        pw.FontWeight.bold))),
                                      ),
                                    ]),
                                  pw.TableRow(children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      subLists[k][i].date)),
                                          style:
                                              const pw.TextStyle(fontSize: 10)),
                                    ),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getLessonTitle(
                                                subLists[k][i].lessonId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getAttendance(
                                                subLists[k][i].lessonId,
                                                std.userId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
                                    pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Text(
                                            getBTVN(subLists[k][i].lessonId,
                                                std.userId),
                                            style: const pw.TextStyle(
                                                fontSize: 10))),
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

    List<LessonModel> lesson =
        listLesson.where((e) => e.lessonId == lessonId).toList();

    if (lesson.isEmpty) return "Không có dữ liệu";

    if (lesson.first.isCustom && lesson.first.customLessonInfo.isEmpty)
      return "Không có btvn";

    if (list.isEmpty) return "Không có dữ liệu";

    return list.first.hw! == -1
        ? AppText.textNotMarked.text.toUpperCase()
        : list.first.hw! > -1
            ? list.first.hw.toStringAsFixed(1)
            : AppText.txtNotSubmit.text.toUpperCase();
  }

  String getAttendancePercent(int stdId) {
    int tempAttendance = 0;

    var stdLessons = listStdLesson.where((e) => e.studentId == stdId).toList();

    int count = stdLessons.where((e) => e.timekeeping != 0).toList().length;

    for (var i in stdLessons) {
      if (i.timekeeping != 6 && i.timekeeping != 5 && i.timekeeping != 0) {
        tempAttendance++;
      }
    }

    return '${((tempAttendance / (count == 0 ? 1 : count)) * 100).toStringAsFixed(0)}%';
  }

  String getHwPercent(int stdId) {
    List<LessonModel> lessonTemp1 =
        listLesson.where((element) => element.btvn == 0).toList();

    List<LessonModel> lessonTemp2 = [];

    for (var i in listLesson) {
      if (i.isCustom == true && i.customLessonInfo.isEmpty) {
        lessonTemp2.add(i);
      }
    }

    List<int> lessonExceptionIds = [];

    for (var i in lessonTemp1) {
      lessonExceptionIds.add(i.lessonId);
    }

    for (var i in lessonTemp2) {
      if (lessonExceptionIds.contains(i.lessonId) == false) {
        lessonExceptionIds.add(i.lessonId);
      }
    }

    int tempHw = 0;
    int countHw = 0;

    var stdLessons = listStdLesson.where((e) => e.studentId == stdId).toList();

    for (var i in stdLessons) {
      if (i.timekeeping != 0) {
        if (lessonExceptionIds.contains(i.lessonId) == false) {
          if (getPoint(i.lessonId, stdId) != -2) {
            tempHw++;
          }
          countHw++;
        }
      }
    }

    return '${((tempHw / (countHw == 0 ? 1 : countHw)) * 100).toStringAsFixed(0)}%';
  }

  double? getGPAPoint(int stdId) {
    var stdLessons = listStdLesson.where((e) => e.studentId == stdId).toList();
    double temp = 0;
    double count = 0;
    for (int i = 0; i < stdLessons.length; i++) {
      if (getPoint(stdLessons[i].lessonId, stdId) > -1) {
        temp += getPoint(stdLessons[i].lessonId, stdId);
        count++;
      }
    }
    return count == 0 ? null : temp / count;
  }

  double getPoint(int lessonId, int stdId) {
    var lesson = listLesson.where((e) => e.lessonId == lessonId).toList();
    bool isCustom = false;
    if (lesson.isNotEmpty) {
      isCustom = lesson.first.isCustom;
    }
    var stdLessons = listStdLesson
        .where((e) => e.studentId == stdId && e.lessonId == lessonId)
        .toList();

    if (isCustom) {
      return getHwCustomPoint(lessonId, stdId);
    }

    if (stdLessons.isEmpty) return -2;
    return stdLessons.first.hw;
  }

  double getHwCustomPoint(int lessonId, int stdId) {
    List<StudentLessonModel> stdLesson = listStdLesson
        .where((e) => e.lessonId == lessonId && e.studentId == stdId)
        .toList();

    if (stdLesson.isEmpty) {
      return -2;
    }
    List<dynamic> listHws = stdLesson.first.hws.map((e) => e['hw']).toList();

    if (listHws.every((e) => e == -2)) {
      return -2;
    } else if (listHws.every((e) => e > 0)) {
      return listHws.reduce((value, element) => value + element) /
          listHws.length;
    }
    return -1;
  }
}
