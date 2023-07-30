import 'dart:io';
import 'package:intl/intl.dart';
import 'package:new_bazaar_khata/pdf/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class Supplier {
  final String name;
  final String address;
  // final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
  });
}

class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
}

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final String date;
  final String dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final String date;
  final String quantity;
  final String vat;
  final String unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice),
        buildHeader(invoice),
        buildDesc(invoice),
        SizedBox(height: 15),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
        politeRequest(),
      ],
    ));

    return PdfApi.saveDocument(name: 'Bill.pdf', pdf: pdf);
  }

  static Widget politeRequest() {
    return Container(
        alignment: Alignment.center,
        child: Column(children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
              'We are glad that you visited us for getting best services. Thank You !'),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Container(height: 1, color: PdfColors.grey400),
        ]));
  }

  static Widget buildDesc(Invoice invoice) =>
      Container(child: Text(invoice.info.description));

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invoice.customer.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(invoice.customer.address),
            SizedBox(height: 0.8 * PdfPageFormat.cm),
          ],
        ),
        Container(child: Text(invoice.info.date))
      ]);

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Items', 'Quantity', 'Price', 'Total'];
    final data = invoice.items.map((item) {
      return [
        item.description,
        item.date,
        (item.quantity),
        (item.unitPrice),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                buildText(
                  title: 'Total amount ',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: " ${invoice.info.dueDate}  Rupees",
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      required TextStyle titleStyle,
      bool unite = false}) {
    final style = titleStyle;

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class PdfMonthStatementApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildMonthlyTitle(invoice),
        buildTitle(invoice),
        buildHeader(invoice),
        buildDesc(invoice),
        SizedBox(height: 15),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
        politeRequest(),
      ],
    ));

    return PdfApi.saveDocument(name: 'MonthlyStatement.pdf', pdf: pdf);
  }

  static Widget buildDesc(Invoice invoice) =>
      Container(child: Text(invoice.info.description));

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invoice.customer.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(invoice.customer.address),
            SizedBox(height: 0.8 * PdfPageFormat.cm),
          ],
        ),
        Container(child: Text(invoice.info.date))
      ]);

  static Widget buildMonthlyTitle(Invoice invoice) => Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Monthly Statement From ${invoice.info.dueDate} - ${invoice.info.date}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Container(height: 1, color: PdfColors.grey400),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      ));

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Date', 'Description', 'Method', 'Bill Amount'];
    final data = invoice.items.map((item) {
      // return [
      //   '11/08/2021',
      //   "This is a bill at Your's Shop",
      //   'Borrow',
      //   '70',
      // ];
      return [
        item.description,
        item.date,
        (item.quantity),
        (item.unitPrice),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                buildText(
                  title: 'Total Monthly Amount ',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '0',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      required TextStyle titleStyle,
      bool unite = false}) {
    final style = titleStyle;

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget politeRequest() {
    return Container(
        alignment: Alignment.center,
        child: Column(children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
              'We are glad that you visited us for getting best services. Thank You !'),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Container(height: 1, color: PdfColors.grey400),
        ]));
  }
}
