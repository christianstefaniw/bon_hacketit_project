import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SideNavDrawer.dart';
import 'QRCodeReaderPage.dart';
import 'Checkout.dart';
import 'RoundedBorderedContainer.dart';

class ProcessOrder extends StatefulWidget {
  List orderedItems = [];
  double totalCost = 0;

  ProcessOrder(this.orderedItems, this.totalCost);

  @override
  _ProcessOrderState createState() => _ProcessOrderState();
}

class _ProcessOrderState extends State<ProcessOrder> {
  var numOrdersUpdated;
  var run = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        run = true;
      });
    });
    if (map["Restaurant's"][cameraScanResult[1]]["NumOrders"] == null) {
      FirebaseDatabase.instance
          .reference()
          .child("Restaurant's/" + cameraScanResult[1] + '/NumOrders')
          .set({
        'NumOrders': numOrders,
      });
      FirebaseDatabase.instance
          .reference()
          .child("Restaurant's/" +
              cameraScanResult[1] +
              '/orders/' +
              numOrders.toString())
          .set({
        'tableNum': tableNum,
        'items': selectedItems,
      });
    } else {
      numOrdersUpdated = map["Restaurant's"][cameraScanResult[1]]["NumOrders"]
              ['NumOrders'] +
          1;
      FirebaseDatabase.instance
          .reference()
          .child("Restaurant's/" + cameraScanResult[1] + '/NumOrders')
          .set({
        'NumOrders': numOrdersUpdated,
      });
      FirebaseDatabase.instance
          .reference()
          .child("Restaurant's/" +
              cameraScanResult[1] +
              '/orders/' +
              numOrdersUpdated.toString())
          .set({
        'tableNum': tableNum,
        'items': selectedItems,
      });
    }
    if (numOrdersUpdated == null){
      numOrdersUpdated = numOrders;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ordered Items',
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !run ? Center(child: CircularProgressIndicator()) : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                height: MediaQuery.of(context).size.width / 1.2,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: selectedMenuItemsCost?.length,
                    itemBuilder: (context, index) {
                      return widget.orderedItems[index];
                    }),
              ),
            ),
            Container(
              child: Text(
                'There ${numOrdersUpdated-1 == 1 ? 'is' : 'are'} ${numOrdersUpdated - 1} order${numOrdersUpdated-1 == 1 ? '' : 's'} ahead of you',
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                  textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
                ),
              ),
            ),
            RoundedContainer(
              elevation: 7,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text('Total: '),
                trailing: Text('\$' + widget.totalCost.toString()),
                //title: Text('Total: \$' + totalCost.toString(), textAlign: TextAlign.center,),
              ),
            ),
            RoundedContainer(
              elevation: 7,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text('Status:'),
                trailing: Text(
                  'PAID',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ));
  }
}
