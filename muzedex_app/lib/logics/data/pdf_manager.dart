import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// coverage:ignore-file

class PdfManager {
  PdfManager._internal();
  static final PdfManager _instance = PdfManager._internal();
  factory PdfManager() => _instance;

  Future<String> getDiplomaPath() async {
    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/diplome.pdf';
    } else {
      if (!await Permission.manageExternalStorage.isGranted) {
        await Permission.manageExternalStorage.request();
      }

      if (await Permission.manageExternalStorage.isGranted) {
        return '/storage/emulated/0/Download/diplome.pdf';
      } else {
        throw Exception("Permission de stockage refusée !");
      }
    }
  }

  String formatTime(Duration duration) {
    final units = {
      "jour": duration.inDays,
      "heure": duration.inHours % 24,
      "minute": duration.inMinutes % 60,
      "seconde": duration.inSeconds % 60
    };

    return units.entries
        .where((entry) => entry.value > 0)
        .map((entry) =>
            "${entry.value} ${entry.value == 1 ? entry.key : '${entry.key}s'}")
        .join(", ");
  }

  Future<void> copyPdfTemplate() async {
    final diplomaPath = await getDiplomaPath();
    final byteData = await rootBundle.load('assets/pdf/template_diplome.pdf');

    final file = File(diplomaPath);
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
  }

  void modifyPdf(
    String value,
    double left,
    double top,
    double width,
    double height,
    double fontSize,
  ) async {
    final diplomaPath = await getDiplomaPath();

    if (!File(diplomaPath).existsSync()) {
      await copyPdfTemplate();
    }

    final file = File(diplomaPath);
    final bytes = file.readAsBytesSync();
    final document = PdfDocument(inputBytes: bytes);

    document.pages[0].graphics.drawString(
      value,
      PdfStandardFont(PdfFontFamily.helvetica, fontSize),
      bounds: Rect.fromLTWH(left, top, width, height),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
        wordWrap: PdfWordWrapType.word,
      ),
    );

    final modifiedBytes = await document.save();
    file.writeAsBytesSync(modifiedBytes);
    document.dispose();
  }

  void modifyDiploma() async {
    await initializeDateFormatting('fr_FR', null);

    final fileManager = FileManager();
    final gameData = await fileManager.readGameDataJsonFile();
    final playerName = gameData?['name'] ?? '';

    final completionDate =
        DateFormat('EEEE d MMMM y', 'fr_FR').format(DateTime.now());

    final startTimestamp = await fileManager.getStartTimestamp();
    if (startTimestamp == null) {
      throw Exception("Start timestamp is null");
    }
    final completionTime = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch - startTimestamp,
    );

    final diplomaData = [
      {
        "text": playerName,
        "left": 360,
        "top": 190,
        "width": 110,
        "height": 40,
        "fontSize": 22
      },
      {
        "text": completionDate,
        "left": 420,
        "top": 240,
        "width": 175,
        "height": 30,
        "fontSize": 16
      },
      {
        "text": "Muséum d'Histoires Naturelles de La Rochelle",
        "left": 225,
        "top": 310,
        "width": 380,
        "height": 30,
        "fontSize": 14
      },
      {
        "text": formatTime(completionTime),
        "left": 235,
        "top": 385,
        "width": 380,
        "height": 30,
        "fontSize": 14
      },
    ];

    for (var item in diplomaData) {
      modifyPdf(
        item["text"],
        item["left"].toDouble(),
        item["top"].toDouble(),
        item["width"].toDouble(),
        item["height"].toDouble(),
        item["fontSize"].toDouble(),
      );
    }
  }

  Future<void> downloadDiploma() async {
    try {
      String diplomaPath = await getDiplomaPath();
      File file = File(diplomaPath);

      if (!await file.exists()) {
        throw Exception("Le diplôme n'existe pas.");
      }

      final params = SaveFileDialogParams(sourceFilePath: file.path);
      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      Exception("Erreur lors de l'enregistrement du PDF : ${e.toString()}");
    }
  }
}
