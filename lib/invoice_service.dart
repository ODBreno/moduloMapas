import 'dart:typed_data';
import 'dart:io';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdf_invoice_generator_flutter/model/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomRow {
  final String name;
  final String descricao;
  final String id;
  CustomRow(this.name, this.descricao, this.id);
}

class PdfInvoiceService {
  Future<Uint8List> createPDF(var e) {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  e["name"],
                  style: const pw.TextStyle(fontSize: 20),
                ),
                pw.SizedBox(height: 10),
                pw.BarcodeWidget(
                  data: e["id"].toString(),
                  barcode: pw.Barcode.qrCode(
                      typeNumber: 2,
                      errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                  width: 150,
                  height: 150,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  e["descricao"],
                  textAlign: pw.TextAlign.center,
                ),
              ]),
        ));
      },
    ));
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }
}
