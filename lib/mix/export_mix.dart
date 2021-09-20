import 'dart:io';

import 'package:camera_marker/model/exam.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

mixin ExportMix {
  Future<String> filePath({Exam? exam}) async {
    String classCode = exam?.myClass?.code ?? "";
    String examName = (exam?.title ?? "").replaceAll(" ", "_");
    String fileName = "$classCode-$examName.xlsx";
    String root = await _localPath() + Platform.pathSeparator;
    String path = root + fileName;

    Excel excel = initExcel(exam: exam);

    //stopwatch.reset();
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }

    return path;
  }

  Future<void> deletefile(String path) async {
    File file = File(path);
    try {
      await file.delete();
      print("delete====SUCCESS===>$path");
    } catch (e) {
      print(e);
    }
  }

  Future<String> _localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  Excel initExcel({Exam? exam}) {
    var excel = Excel.createExcel();

    CellStyle cellStyle = CellStyle(
      // bold: true,
      // italic: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: '#6691cd',
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
      rotation: 0,
    );

    var sheet = excel["Sheet1"];

    sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("B1"));

    var cell = sheet.cell(CellIndex.indexByString("A1"));
    cell.value = "Kihaso";
    cell.cellStyle = cellStyle;

    return excel;
  }
}
