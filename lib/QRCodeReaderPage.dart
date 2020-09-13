import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'RestaurantOrCustomer.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SideNavDrawer.dart';
import 'Checkout.dart';
import 'RestaurantOrCustomer.dart';

var map;
dynamic cameraScanResult;
int runOnce = 0;
var tableNum;
List<String> itemsVal = [];
List<String> costsVal = [];
Map total = {};
TextEditingController textControllerTableNum = new TextEditingController();

class QRCodeReaderPage extends StatefulWidget {
  final list;

  QRCodeReaderPage({Key key, this.list});

  @override
  QRCodeReaderPageState createState() => QRCodeReaderPageState();
}

class QRCodeReaderPageState extends State<QRCodeReaderPage> {
  dynamic scanResult = '';
  bool isNull = true;

  Future scanQRCode() async {
    cameraScanResult = await scanner.scan();
    cameraScanResult = cameraScanResult.replaceAll("[", '');
    cameraScanResult = cameraScanResult.replaceAll("]", '');
    cameraScanResult = cameraScanResult.replaceAll(",", '');
    cameraScanResult = cameraScanResult.split(' ').toList();

    DataSnapshot response = await FirebaseDatabase.instance.reference().once();
    map = new Map<String, dynamic>.from(response.value);
    for (int i = 1;
        i <= map["Restaurant's"][cameraScanResult[1]]['value']['value'];
        i++) {
      itemsVal
          .add(map["Restaurant's"][cameraScanResult[1]]['item$i']['product']);
    }
    for (int i = 1;
        i <= map["Restaurant's"][cameraScanResult[1]]['value']['value'];
        i++) {
      costsVal.add(map["Restaurant's"][cameraScanResult[1]]['item$i']['cost']);
    }

    for (int i = 0; i < costsVal.length; i++) {
      total['item${i + 1}'] = itemsVal[i];
      total['cost${i + 1}'] = costsVal[i];
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewMenu(cameraScanResult, total)),
    );
    setState(() {
      scanResult = cameraScanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    isNull = false;
    if (textControllerTableNum.text == '') {
      isNull = true;
    }

    try {
      print(selectedMenu[0]);
    } catch (e) {
      selectedMenu.add(TextField(
        textAlign: TextAlign.center,
        onChanged: (text) {
          setState(() {
            isNull = false;
          });
        },
        controller: textControllerTableNum,
        decoration: InputDecoration(
          hintText: "Enter your table number",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ));
      selectedMenu.add(RaisedButton(
        child: Text('Checkout'),
        onPressed: () {
          tableNum = textControllerTableNum.text;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Checkout()));
        },
      ));
    }
    if (selectedMenu[0].runtimeType != TextField ||
        selectedMenu[1].runtimeType != RaisedButton) {
      selectedMenu.add(TextField(
        textAlign: TextAlign.center,
        onChanged: (text) {
          setState(() {
            isNull = false;
          });
        },
        controller: textControllerTableNum,
        decoration: InputDecoration(
          hintText: "Enter your table number",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ));
      selectedMenu.add(RaisedButton(
        child: Text('Checkout'),
        onPressed: () {
          tableNum = textControllerTableNum.text;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Checkout()));
        },
      ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'eMenu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => RestaurantOrCustomer())),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 195.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 40.0)],
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 40)),
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/MenuIcon.png",
                    width: 230,
                    height: 185,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                  Container(
                    width: 130,
                    child: Text(
                      'Scan the QR Code on your table.',
                      style: GoogleFonts.sourceSansPro(
                          textStyle: TextStyle(fontSize: 20),
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 175,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 14.0)],
              color: Colors.white,
            ),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: selectedMenu?.length,
                itemBuilder: (context, index) {
                  if (index == 1) {
                    return Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: selectedMenu[index],
                    );
                  } else {
                    return Container(
                      child: selectedMenu[index],
                    );
                  }
                }),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: RaisedButton(
              color: Colors.blue,
              child: Text(
                'Click To Scan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: isNull ? null : () => scanQRCode(),
            ),
          )
        ],
      ),
    );
  }
}

class ViewMenu extends StatefulWidget {
  final List fileURL;
  final total;

  ViewMenu(this.fileURL, this.total);

  @override
  _ViewMenuState createState() => _ViewMenuState();
}

class _ViewMenuState extends State<ViewMenu> {
  bool loading = true;
  PDFDocument document;
  var num = 0;

  getPDF() async {
    setState(() {
      loading = true;
    });
    document = await PDFDocument.fromURL(widget.fileURL[0]);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (num == 0) {
      getPDF();
      num++;
    }
    return Scaffold(
      endDrawer: SideNavDrawer(
        total: widget.total,
      ),
      appBar: AppBar(
        title: Text(
          'Menu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => QRCodeReaderPage()))),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.border_color,
                  color: Colors.black,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      //body:  loading ? null : PDFViewer(document: document,),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: document,
            ),
    );
  }
}
