import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/extensions/datetime_ext.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';

class PreviewPdfScreen extends StatefulWidget {
  const PreviewPdfScreen({super.key, required this.order});

  final OrderModel order;

  @override
  State<PreviewPdfScreen> createState() => _PreviewPdfScreenState();
}

class _PreviewPdfScreenState extends State<PreviewPdfScreen> {
  Future<String> generateOrderPdf(OrderModel order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 32),
              pw.Text('Produk Dipesan:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              ...order.products!.map(
                (product) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('- ${product.name} (${product.quantity})',
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text(
                          (product.price! * product.quantity!).currencyFormatRp,
                          style: const pw.TextStyle(fontSize: 16)),
                    ]),
              ),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Harga',
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        (widget.order.priceTotal! - widget.order.biayaAdmin!)
                            .currencyFormatRp,
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ]),
              pw.SizedBox(height: 16),
              pw.Text('Detail Pesanan',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(children: [
                pw.Expanded(
                    flex: 6,
                    child: pw.Text('Waktu Order',
                        style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text(':', style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                        textAlign: pw.TextAlign.end,
                        order.createdAt!.toDate().toFormattedDateWithDay(),
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold))),
              ]),
              pw.Row(children: [
                pw.Expanded(
                    flex: 6,
                    child: pw.Text('Status Pembayaran',
                        style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text(':', style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                        textAlign: pw.TextAlign.end,
                        order.orderStatus!,
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold))),
              ]),
              pw.Row(children: [
                pw.Expanded(
                    flex: 6,
                    child: pw.Text('Metode Pembayaran',
                        style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text(':', style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                        textAlign: pw.TextAlign.end,
                        order.paymentMethod!,
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold))),
              ]),
              pw.Row(children: [
                pw.Expanded(
                    flex: 6,
                    child: pw.Text('Biaya Admin',
                        style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text(':', style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                        textAlign: pw.TextAlign.end,
                        order.biayaAdmin!.currencyFormatRp,
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold))),
              ]),
              pw.Row(children: [
                pw.Expanded(
                    flex: 6,
                    child: pw.Text('Total Harga',
                        style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text(':', style: const pw.TextStyle(fontSize: 16))),
                pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                        textAlign: pw.TextAlign.end,
                        order.priceTotal!.currencyFormatRp,
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold))),
              ]),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/order_${order.orderId}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  String? pdfPath;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    final path = await generateOrderPdf(widget.order);
    setState(() {
      pdfPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 24,
          ),
        ),
        title: Text(
          'Preview PDF',
          style: appTheme.textTheme.titleSmall,
        ),
      ),
      body: pdfPath == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.primary),
              ),
            )
          : PDFView(
              filePath: pdfPath!,
            ),
    );
  }
}
