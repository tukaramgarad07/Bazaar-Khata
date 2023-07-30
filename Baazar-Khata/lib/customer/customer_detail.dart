import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_bazaar_khata/customer/edit_bill.dart';
import 'package:new_bazaar_khata/customer/edit_customer.dart';
import 'package:new_bazaar_khata/customer/new_bill.dart';
import 'package:new_bazaar_khata/customer/record_payment.dart';
import 'package:new_bazaar_khata/models/note.dart';
import 'package:new_bazaar_khata/pdf/pdf_api.dart';
import 'package:new_bazaar_khata/pdf/pdf_invoice_api.dart';
import 'package:new_bazaar_khata/util/database_helper.dart';
import 'package:new_bazaar_khata/util/image_saver.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetail extends StatefulWidget {
  final String id;
  final String customerName;
  final String customerDesc;
  final String money;
  final String customerEmail;
  const CustomerDetail(
      {Key? key,
      required this.id,
      required this.customerEmail,
      required this.customerName,
      required this.customerDesc,
      required this.money})
      : super(key: key);

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<dynamic> noteList = [];
  int count = 0;
  // ignore: avoid_init_to_null
  var imagefromPrefDetail = null;

  Future loadImageDetail(key) async {
    Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPrefDetail =
            Utility.imageFromBase64StringCustomerDetail(value);
      });
    });
  }

  Widget getImageDetail(photoUrlDetail) {
    if (null == imagefromPrefDetail) {
      loadImageDetail(photoUrlDetail);
    }
    if (imagefromPrefDetail != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            image: imagefromPrefDetail,
          ));
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Image(
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            image: AssetImage('images/shop.jpeg')));
  }

  TableRow billrow(String row) {
    List result = row.split(',');
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              result[0] ?? "None",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              result[1] ?? "None",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              result[2] ?? "None",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              result[3] ?? "None",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> billTable(String bill) {
    List result = bill.split('*');
    var bil = result.toList();
    int items = bil.length;

    var row = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ];
    int i = 0;
    while (i < items) {
      var row2 = billrow(result[i]);
      row.add(row2);
      i = i + 1;
    }
    return row;
  }

  Widget paymentlogo(String method) {
    var i = method;
    if (i == 'paid') {
      return const Image(image: AssetImage('images/paid.png'), height: 50);
    }
    if (i == 'borrow') {
      return const Image(image: AssetImage('images/borrow.jpg'), height: 50);
    }
    if (i == 'cash') {
      return const Image(
          image: AssetImage('images/moneytransfer.png'), height: 50);
    }
    return Container();
  }

  Widget totalMoney(String money) {
    var i = money;
    if (i == 'paid') {
      return RichText(
        text: TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '85',
                //text: bill[i].money,
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    }
    if (i == 'borrow') {
      return RichText(
        text: const TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '85',
                //text: bill[i].money,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    }
    if (i == 'cash') {
      return RichText(
        text: const TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '85',
                //text: bill[i].money,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    }
    return Container();
  }

  Future editNavigation(id, bill, sum, String shop, String customer,
      String customerPrice, String method, String billDesc) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditBill(
                customerEmail: widget.customerEmail,
                id: id,
                bill: bill,
                sum: sum,
                shopName: shop,
                customerName: customer,
                customerId: widget.id,
                billdesc: billDesc,
                money: customerPrice,
                method: method)));
  }

  InvoiceItem shareBill(bill) {
    List result = bill.split(',');
    return InvoiceItem(
      description: '${result[0]}',
      date: '${result[1]}',
      quantity: '${result[2]}',
      vat: '${result[0]}',
      unitPrice: '${result[3]}',
    );
  }

  Widget _billGenerationState(
      String customerName, String customerDesc, String customerPrice) {
    if (count == 0) {
      return const Center(
        child: Text("No Recent bills"),
      );
    }
    return ListView.builder(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 65),
      itemCount: count,
      itemBuilder: (buildcontext, position) => Card(
        child: Container(
          color: Colors.white,
          child: ExpansionTile(
            leading: getImageDetail(currentuser!.uid),
            title: AbsorbPointer(
              child: ExpandableText(
                noteList[position].shopName,
                expandText: '',
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: Text(
              noteList[position].dateTime,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            trailing: RichText(
              text: TextSpan(
                  text: '\u{20B9} ',
                  style: TextStyle(
                    color: color('${noteList[position].method}'),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      text: noteList[position].amount,
                      style: TextStyle(
                        color: color('${noteList[position].method}'),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
            ),
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: ExpandableText(
                    noteList[position].description,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 2,
                    linkColor: Colors.blue,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: noteList[position].method == 'cash'
                    ? Text('${noteList[position].bill}')
                    : Table(
                        border: TableBorder.all(),
                        columnWidths: const {},
                        children: billTable(noteList[position].bill),
                      ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: paymentlogo(noteList[position].method)),
                Row(children: [
                  noteList[position].method == 'cash'
                      ? const Text('')
                      : IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue[400]),
                          tooltip: 'Edit a Bill',
                          onPressed: () async {
                            await editNavigation(
                                noteList[position].id,
                                noteList[position].bill,
                                noteList[position].amount,
                                noteList[position].shopName,
                                noteList[position].customerName,
                                customerPrice,
                                noteList[position].method,
                                noteList[position].description);

                            updateListViewNew(widget.id);
                          }),
                  noteList[position].method == 'cash'
                      ? const Text('')
                      : IconButton(
                          icon: Icon(Icons.share, color: Colors.blueGrey[400]),
                          tooltip: 'Share a Bill',
                          onPressed: () async {
                            var bill = noteList[position].bill;
                            List result1 = bill.split('*');
                            var bil = result1.toList();
                            int items = bil.length;
                            final date = DateTime.now();
                            // ignore: unused_local_variable
                            final dueDate = date.add(const Duration(days: 7));
                            final invoice = Invoice(
                                supplier: Supplier(
                                  name: customerName,
                                  address: customerDesc,
                                ),
                                customer: Customer(
                                    name: currentuser!.photoURL ?? "Shop Name",
                                    address: currentuser!.displayName ??
                                        "Shop Owner Name"),
                                info: InvoiceInfo(
                                    date: '${noteList[position].dateTime}',
                                    dueDate: '${noteList[position].amount}',
                                    description: noteList[position].description,
                                    number: '${noteList[position].dateTime}'),
                                // '${DateTime.now().year}-9999'),
                                items: [
                                  for (var i = 0; i < items; i++) ...[
                                    shareBill(result1[i])
                                  ]
                                ]);

                            final pdfFile =
                                await PdfInvoiceApi.generate(invoice);
                            PdfApi.openFile(pdfFile);
                            // Share.shareFiles(
                            //     File(pdfFile));
                          }),
                  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400]),
                      tooltip: 'Delete a Bill',
                      onPressed: () {
                        _delete(context, noteList[position]);
                        updateListViewNew(widget.id);
                      }),
                ]),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Color? color(method) {
    if (method == 'paid') {
      return Colors.grey[700];
    }
    if (method == 'payment') {
      return Colors.red[700];
    }
    if (method == 'cash') {
      return Colors.red[700];
    }
    if (method == 'save') {
      return Colors.blueGrey[700];
    }
    return Colors.green[700];
  }

  Future loadImage(key) async {
    await Utility.getImageFromPreferences(key).then((value) {
      if (null == value) {
        return;
      }
      setState(() {
        imagefromPref = Utility.imageFromBase64StringCustomerDetail(value);
      });
    });
  }

  Widget money(String money) {
    int k = money.length;
    if (int.parse(money) > 0) {
      return RichText(
        text: TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: colorCode(money),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: money,
                style: TextStyle(
                  color: colorCode(money),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    } else if (int.parse(money) < 0) {
      return RichText(
        text: TextSpan(
            text: '\u{20B9} ',
            style: TextStyle(
              color: colorCode(money),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: money.substring(1, k),
                style: TextStyle(
                  color: colorCode(money),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      );
    }
    return RichText(
      text: TextSpan(
          text: '\u{20B9} ',
          style: TextStyle(
            color: colorCode(money),
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: money,
              style: TextStyle(
                color: colorCode(money),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
    );
  }

  Color colorCode(String money) {
    int price = int.parse(money);
    if (price > 0) {
      return Colors.green;
    } else if (price < 0) {
      return Colors.red;
    }
    return Colors.grey;
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      // _showSnackBar(context, 'Bill Deleted Successfully');
      updateListViewNew(widget.id);
    }
  }

  descriptionManage(desc) {
    return desc;
  }

  InvoiceItem shareMonthlyBill(bill) {
    return InvoiceItem(
      description: '${bill.dateTime}',
      date: '${descriptionManage(bill.description)}',
      quantity: '${bill.method}',
      vat: '',
      unitPrice: '${bill.amount}',
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var imagefromPref;
  bool refresh = false;
  Widget customerImage(gender) {
    if (imagefromPref == null) {
      loadImage(widget.id);
    }
    if (imagefromPref != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            image: imagefromPref,
          ));
    } else if (gender == '0') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Image(
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            image: AssetImage('images/maleAvatar.jpg')),
      );
    } else if (gender == '1') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const Image(
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            image: AssetImage('images/femaleavatar (2).jpg')),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: const Image(
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          image: AssetImage('images/avatar.png')),
    );
  }

  final currentuser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (imagefromPref == null) {
      loadImageDetail(currentuser!.uid);
      loadImage(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty && refresh == false) {
      refresh = true;
      noteList = [];
      updateListViewNew(widget.id);
    }

    var id1 = widget.id.toString();
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    Future<void> deleteUser(String id) {
      return customers.doc(id).delete().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Customer removed Successfully')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text('Please try again')));
      });
    }

    Future choiceAction(String choices) async {
      if (choices == Contraints1.recordPayment) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPayment(
                      shopName: currentuser!.photoURL ?? "Shop Name",
                      customerName: widget.customerName,
                      customerEmail: widget.customerEmail,
                      customerId: widget.id,
                      money: widget.money,
                    )));
        updateListViewNew(widget.id);
      }
      if (choices == Contraints1.monthlyStatement) {
        final date = DateTime.now();
        final DateFormat formatter = DateFormat('dd/MM/yyyy ');
        String formattedDate = formatter.format(date);
        final dueDate = date.subtract(const Duration(days: 31));
        String formattedDueDate = formatter.format(dueDate);
        final invoice = Invoice(
            supplier: Supplier(
              name: widget.customerName,
              address: widget.customerDesc,
            ),
            customer: Customer(
              name: currentuser!.photoURL ?? "Shop Name",
              address: currentuser!.displayName ?? "Shop Owner Name",
            ),
            info: InvoiceInfo(
                date: formattedDate,
                dueDate: formattedDueDate,
                description: '',
                number: ''),
            items: [
              for (var i = 0; i < count; i++) ...[shareMonthlyBill(noteList[i])]
            ]);

        final pdfFile = await PdfMonthStatementApi.generate(invoice);
        PdfApi.openFile(pdfFile);
      }
      if (choices == Contraints1.sendRemainder) {
        final Email email = Email(
          body:
              'Hi ${widget.customerName},<br>Please, pay your owes at ${currentuser!.photoURL} <br> <br> Thanks and Regards, <br> Bazaarkhata App',
          subject: 'Payment Reminder',
          recipients: [(widget.customerEmail)],
          // cc: ['bazaarkhata@gmail.com'],
          // bcc: ['bcc@example.com'],
          // attachmentPaths: ['/path/to/attachment.zip'],
          isHTML: true,
        );
        await FlutterEmailSender.send(email);
      }
      if (choices == Contraints1.removeUser) {
        bool hasInternet = await InternetConnectionChecker().hasConnection;
        if (hasInternet == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text('No Internet Connection',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center)));
          return;
        }
        deleteUser(widget.id);
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(id1).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[600],
              title: const Text('Baazar Khata'),
              titleSpacing: 0.0,
              actions: [
                IconButton(
                    icon: const Icon(Icons.message_rounded),
                    onPressed: () async {
                      String _urlsms = 'sms://+91${data["phone"]}';
                      await canLaunch(_urlsms)
                          ? await launch(_urlsms)
                          : throw 'Could not launch $_urlsms';
                    }),
                IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () async {
                      String _urltel = 'tel://+91${data["phone"]}';
                      await canLaunch(_urltel)
                          ? await launch(_urltel)
                          : throw 'Could not launch $_urltel';
                    }),
                PopupMenuButton(
                  enabled: true,
                  padding: const EdgeInsets.all(0),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Contraints1.choices.map((
                      String choices,
                    ) {
                      return PopupMenuItem(
                          value: choices, child: Text(choices));
                    }).toList();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: const Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFE0E0E0)))),
                  child: ListTile(
                      leading: customerImage('${data["gender"]}'),
                      title: ExpandableText('${data["name"]}',
                          expandText: "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 19)),
                      subtitle: ExpandableText(
                        '${data["desc"]}',
                        expandText: "",
                        maxLines: 1,
                      ),
                      trailing: money(data["price"]),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditCustomer(
                                    id: id1,
                                    name: data["name"],
                                    desc: data["desc"],
                                    gender: data["gender"],
                                    phone: data["phone"],
                                    email: data["email"])));
                        Navigator.pop(context);
                      }),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: Text(
                    'Recent Bills',
                    style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                    child: _billGenerationState(
                        data["name"], data["desc"], data["price"])),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.orange[600],
                icon: const Icon(Icons.add),
                label: const Text('Add New Bill'),
                onPressed: () async {
                  await navigation(context, '${data["name"]}', data["email"],
                      widget.id, data["price"]);
                  updateListViewNew(widget.id);
                }),
          );
        }

        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[600],
              title: const Text('Baazar Khata'),
              titleSpacing: 0.0,
              actions: [
                IconButton(
                    icon: const Icon(Icons.message_rounded), onPressed: () {}),
                IconButton(icon: const Icon(Icons.call), onPressed: () {}),
                PopupMenuButton(
                  enabled: true,
                  padding: const EdgeInsets.all(0),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Contraints1.choices.map((String choices) {
                      return PopupMenuItem(
                          value: choices, child: Text(choices));
                    }).toList();
                  },
                )
              ],
            ),
            body: const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<bool> navigation(context, String customerName, String customerEmail,
      String customerId, String money) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewBill(
                  shopName: currentuser!.photoURL ?? "Shop Name",
                  customerName: customerName,
                  customerEmail: customerEmail,
                  customerId: customerId,
                  money: money,
                )));
    return true;
  }

  void updateListViewNew(customerid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List> noteListFuture =
          databaseHelper.getNoteListNew("Mayur", customerid);
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}

class Contraints1 {
  static const String recordPayment = 'Record a Payment';
  static const String monthlyStatement = 'Monthly Statement';
  static const String sendRemainder = 'Send Reminder';
  static const String removeUser = 'Remove User';
  static const List<String> choices = <String>[
    recordPayment,
    monthlyStatement,
    sendRemainder,
    removeUser
  ];
}
