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

class OrderPreviewPage extends StatefulWidget {
  const OrderPreviewPage({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderPreviewPage> createState() => _OrderPreviewPageState();
}

class _OrderPreviewPageState extends State<OrderPreviewPage> {
  Future<String> generateOrderPdf(OrderModel order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Column(
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
              pw.SizedBox(height: 16),
              pw.Text('Detail Pesanan',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text(
                  'Waktu Order: ${order.createdAt!.toDate().toFormattedDateWithDay()}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.Text('Status Pembayaran: ${order.orderStatus}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.Text('Metode Pembayaran: ${order.paymentMethod}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.Text('Biaya Admin: ${order.biayaAdmin}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.Text('Total Harga: ${order.priceTotal}',
                  style: const pw.TextStyle(fontSize: 16)),
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
