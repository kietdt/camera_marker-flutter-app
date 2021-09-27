import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/result.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as syncfusion;

mixin ExportMix {
  Future<String> filePath({Exam? exam}) async {
    String excelRoot = await getExcelRoot(exam, returnPath: true);
    // String zipPath = await saveZip(exam, [excelRoot]);

    // deletefile(excelRoot);

    // return zipPath;
    return excelRoot;
  }

  Future<String> _localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  //Lưu file excel và trả về đường dẫn chưa thư mục excel
  Future<String> getExcelRoot(Exam? exam, {bool returnPath = false}) async {
    String classCode = exam?.myClass?.code ?? "";
    String examName = (exam?.title ?? "").replaceAll(" ", "_");
    String excelName = "$classCode-$examName.xlsx";

    String excelRoot = await _localPath() + Platform.pathSeparator + "export";
    String excelPath = excelRoot + Platform.pathSeparator + excelName;

    initBorder(exam, excelPath);

    Excel excel = await initExcel(exam: exam, excelPath: excelPath);

    //stopwatch.reset();
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File file = File(excelPath)..createSync(recursive: true);
      await file.writeAsBytes(fileBytes);
      return returnPath ? excelPath : excelRoot;
    }
    return "";
  }

  Future<String> saveZip(Exam? exam, List<String> fileDir) async {
    String classCode = exam?.myClass?.code ?? "";
    String examName = (exam?.title ?? "").replaceAll(" ", "_");
    String zipName = "$classCode-$examName.zip";

    String zipRoot = await _localPath() + Platform.pathSeparator + "archive";
    String zipPath = zipRoot + Platform.pathSeparator + zipName;

    ZipFileEncoder encoder = ZipFileEncoder();
    encoder.create(zipPath);
    for (int i = 0; i < fileDir.length; i++) {
      encoder.addDirectory(Directory(fileDir[i]));
    }
    encoder.close();

    return zipPath;
  }

  Future<void> deletefile(String path) async {
    File file = File(path);
    try {
      await file.delete();
      print("delete====SUCCESS===>$path");
    } catch (e) {
      try {
        Directory dir = Directory(path);
        dir.deleteSync(recursive: true);
        print("delete==directory==SUCCESS===>$path");
      } catch (e) {
        print(e);
      }
      print(e);
    }
  }

  //sử dụng 1 thư viện khác để border trang tính
  Future<void> initBorder(Exam? exam, String excelPath) async {
    // Create a new Excel document.
    final syncfusion.Workbook workbook = new syncfusion.Workbook();
    //Accessing worksheet via index.
    syncfusion.Worksheet sheet = workbook.worksheets[0];

    syncfusion.Style globalStyle = workbook.styles.add('style');
    globalStyle.borders.all.lineStyle = syncfusion.LineStyle.thin;

    syncfusion.Style descStyle = workbook.styles.add('descStyle');
    descStyle.borders.all.lineStyle = syncfusion.LineStyle.thin;
    descStyle.hAlign = syncfusion.HAlignType.center;

    syncfusion.Style titleStyle = workbook.styles.add('titleStyle');
    titleStyle.borders.all.lineStyle = syncfusion.LineStyle.thin;
    titleStyle.backColor = "#6691cd";

    for (int i = 0; i <= (exam?.result.length ?? 0); i++) {
      int j = 15 + i;
      syncfusion.Style _temp = j == 15 ? titleStyle : descStyle;
      sheet.getRangeByName('A$j').cellStyle = _temp;
      sheet.getRangeByName('B$j').cellStyle = _temp;
      sheet.getRangeByName('C$j').cellStyle = _temp;
      sheet.getRangeByName('D$j').cellStyle = _temp;
      sheet.getRangeByName('E$j').cellStyle = _temp;
      sheet.getRangeByName('F$j').cellStyle = _temp;
    }

    for (int i = 5; i <= 10; i++) {
      sheet.getRangeByName('A$i').cellStyle = globalStyle;
      sheet.getRangeByName('B$i').cellStyle = globalStyle;
      sheet.getRangeByName('C$i').cellStyle = globalStyle;
      sheet.getRangeByName('D$i').cellStyle = globalStyle;
    }

    final List<int> bytes = workbook.saveAsStream();
    File file = File(excelPath)..createSync(recursive: true);
    await file.writeAsBytes(bytes);
    workbook.dispose();
  }

  Future<Excel> initExcel({Exam? exam, required String excelPath}) async {
    var bytes = await File(excelPath).readAsBytes();
    Excel excel = Excel.decodeBytes(bytes);

    Sheet sheet = excel["Sheet1"];

    sheet = sheetTitle(exam, sheet);
    sheet = sheetDesc(exam, sheet);
    sheet = sheetDetail(exam, sheet);

    return excel;
  }

  Sheet sheetTitle(Exam? exam, Sheet sheet) {
    sheet.merge(
      CellIndex.indexByString("A1"),
      CellIndex.indexByString("F1"),
    );
    sheet.merge(
      CellIndex.indexByString("A2"),
      CellIndex.indexByString("F2"),
    );
    sheet.merge(
      CellIndex.indexByString("A1"),
      CellIndex.indexByString("A2"),
    );

    CellStyle cellStyle = CellStyle(
      // bold: true,
      // italic: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      fontSize: 18,
      backgroundColorHex: "#3A6DB2",
      fontColorHex: '#ffffff',
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Helvetica_Neue),
      rotation: 0,
    );

    Data cell = sheet.cell(CellIndex.indexByString("A1"));
    cell.value = exam?.title;
    cell.cellStyle = cellStyle;

    return sheet;
  }

  Sheet sheetDesc(Exam? exam, Sheet sheet) {
    // CellStyle titleStyle = CellStyle(
    //   // bold: true,
    //   // italic: true,
    //   horizontalAlign: HorizontalAlign.Left,
    //   verticalAlign: VerticalAlign.Center,
    //   fontSize: 10,
    //   bold: true,
    //   textWrapping: TextWrapping.WrapText,
    //   fontFamily: getFontFamily(FontFamily.Helvetica_Neue),
    //   rotation: 0,
    // );

    // CellStyle descStyle = CellStyle(
    //   // bold: true,
    //   // italic: true,
    //   horizontalAlign: HorizontalAlign.Left,
    //   verticalAlign: VerticalAlign.Center,
    //   fontSize: 10,
    //   textWrapping: TextWrapping.WrapText,
    //   fontFamily: getFontFamily(FontFamily.Helvetica_Neue),
    //   rotation: 0,
    // );

    sheet.merge(
      CellIndex.indexByString("A5"),
      CellIndex.indexByString("B5"),
    );
    Data cellTitle = sheet.cell(CellIndex.indexByString("A5"));
    cellTitle.value = "Lớp";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C5"),
      CellIndex.indexByString("F5"),
    );
    Data cellDecs = sheet.cell(CellIndex.indexByString("C5"));
    cellDecs.value = exam?.myClass?.name;
    // cellDecs.cellStyle = descStyle;

    sheet.merge(
      CellIndex.indexByString("A6"),
      CellIndex.indexByString("B6"),
    );
    cellTitle = sheet.cell(CellIndex.indexByString("A6"));
    cellTitle.value = "Số câu hỏi";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C6"),
      CellIndex.indexByString("F6"),
    );
    cellDecs = sheet.cell(CellIndex.indexByString("C6"));
    cellDecs.value = exam?.question.toString();
    // cellDecs.cellStyle = descStyle;

    sheet.merge(
      CellIndex.indexByString("A7"),
      CellIndex.indexByString("B7"),
    );
    cellTitle = sheet.cell(CellIndex.indexByString("A7"));
    cellTitle.value = "Thang điểm";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C7"),
      CellIndex.indexByString("F7"),
    );
    cellDecs = sheet.cell(CellIndex.indexByString("C7"));
    cellDecs.value = exam?.maxPoint?.toStringAsFixed(2);
    // cellDecs.cellStyle = descStyle;

    sheet.merge(
      CellIndex.indexByString("A8"),
      CellIndex.indexByString("B8"),
    );
    cellTitle = sheet.cell(CellIndex.indexByString("A8"));
    cellTitle.value = "Mẫu đề thi";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C8"),
      CellIndex.indexByString("F8"),
    );
    cellDecs = sheet.cell(CellIndex.indexByString("C8"));
    cellDecs.value = exam?.template?.titleDisplay;
    // cellDecs.cellStyle = descStyle;

    sheet.merge(
      CellIndex.indexByString("A9"),
      CellIndex.indexByString("B9"),
    );
    cellTitle = sheet.cell(CellIndex.indexByString("A9"));
    cellTitle.value = "Thời gian bắt đầu";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C9"),
      CellIndex.indexByString("F9"),
    );
    cellDecs = sheet.cell(CellIndex.indexByString("C9"));
    cellDecs.value = Utils.dateToStr(exam?.startAt, pattern: Utils.DMYHM);
    // cellDecs.cellStyle = descStyle;

    sheet.merge(
      CellIndex.indexByString("A10"),
      CellIndex.indexByString("B10"),
    );
    cellTitle = sheet.cell(CellIndex.indexByString("A10"));
    cellTitle.value = "Thời gian thi";
    // cellTitle.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByString("C10"),
      CellIndex.indexByString("F10"),
    );
    cellDecs = sheet.cell(CellIndex.indexByString("C10"));
    cellDecs.value = exam?.minutesText;
    // cellDecs.cellStyle = descStyle;

    return sheet;
  }

  Sheet sheetDetail(Exam? exam, Sheet sheet) {
    List<Result>? result = exam?.result;
    result?.sort((a, b) => (b.point.compareTo(a.point)));
    for (int i = 0; i <= (result?.length ?? 0); i++) {
      int j = 15 + i;

      // sheet.merge(
      //   CellIndex.indexByString("B$j"),
      //   CellIndex.indexByString("C$j"),
      // );

      // sheet.merge(
      //   CellIndex.indexByString("C$j"),
      //   CellIndex.indexByString("DC$j"),
      // );

      Data cellTitleA = sheet.cell(CellIndex.indexByString("A$j"));
      Data cellTitleB = sheet.cell(CellIndex.indexByString("B$j"));
      Data cellTitleC = sheet.cell(CellIndex.indexByString("C$j"));
      Data cellTitleD = sheet.cell(CellIndex.indexByString("D$j"));

      if (j == 15) {
        cellTitleA.value = "Số thứ tự";
        cellTitleB.value = "Mã số sinh viên";
        cellTitleC.value = "Mã đề";
        cellTitleD.value = "Điểm";
      } else {
        cellTitleA.value = i.toString();
        cellTitleB.value = result?[i - 1].studentCode.toString();
        cellTitleC.value = result?[i - 1].examCode.toString();
        cellTitleD.value = result?[i - 1].point.toStringAsFixed(2);
      }
    }

    return sheet;
  }
}
