import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'RestaurantMainPage.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

dynamic cameraScanResultO;
List tables = [];
List items = [];
bool onceG = true;

class _OrdersState extends State<Orders> {
  dynamic scanResult = '';
  var mapO;
  var vals;

  Future QRScan() async {
    cameraScanResultO = await scanner.scan();
    cameraScanResultO = cameraScanResultO.replaceAll("[", '');
    cameraScanResultO = cameraScanResultO.replaceAll("]", '');
    cameraScanResultO = cameraScanResultO.replaceAll(",", '');
    cameraScanResultO = cameraScanResultO.split(' ').toList();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewOrders(cameraScanResultO)),
    );
    setState(() {
      scanResult = cameraScanResultO;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onceG) {
      QRScan();
      onceG = false;
    }
    return RestaurantMainPage();
  }
}

class ViewOrders extends StatefulWidget {
  final cameraScanResultO;

  ViewOrders(this.cameraScanResultO);

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  Map orders = {};
  List<Widget> orderListWidgets = [];
  List<Widget> tableListWidgets = [];
  List<Widget> allWidgets = [];
  Map tables = {};
  var mapO;
  int odd = 0;
  Color color;
  var onceUpdate = false;

  Future refreshFirebase() async {
    DataSnapshot response = await FirebaseDatabase.instance.reference().once();
    mapO = new Map<String, dynamic>.from(response.value);
    onceUpdate = true;
    setState(() {
      orderListWidgets?.clear();
      tableListWidgets?.clear();
      allWidgets?.clear();
      odd = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!onceUpdate) {
      refreshFirebase();
    }
    odd = 0;
    Timer.periodic(Duration(seconds: 10), (timer) {
      refreshFirebase();
    });
    if (mapO["Restaurant's"][cameraScanResultO[1]]['NumOrders'] != null) {
      var numberOfOrders =
      mapO["Restaurant's"][cameraScanResultO[1]]['NumOrders']['NumOrders'];
      for (int i = 1; i < (numberOfOrders + 1); i++) {
        orders[i] =
        mapO["Restaurant's"][cameraScanResultO[1]]['orders'][i]['items'];
        tables[i] =
        mapO["Restaurant's"][cameraScanResultO[1]]['orders'][i]['tableNum'];
      }

      for (int i = 1; i < (orders.length + 1); i++) {
        orders[i] = orders[i].toString().replaceAll('[', '');
        orders[i] = orders[i].toString().replaceAll(']', '');
        orderListWidgets.add(Text('Items: ' + orders[i].toString()));
        tableListWidgets.add(Text('Table: ' + tables[i].toString()));
      }
    } else {

    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Orders',
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
              onPressed: () {
                onceG = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantMainPage()));
              })),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            height: MediaQuery.of(context).size.height - 80,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: orderListWidgets?.length,
                itemBuilder: (context, index) {
                  odd++;
                  if (odd % 2 == 0) {
                    color = Colors.white;
                  } else {
                    color = Color(0xffF0F0F0);
                  }
                  return Container(
                    padding: EdgeInsets.only(top: 25, bottom: 25),
                    color: color,
                    child: Column(
                      children: [
                        tableListWidgets[index],
                        orderListWidgets[index]
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
