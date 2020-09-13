import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ProcessOrder.dart';
import 'QRCodeReaderPage.dart';
import 'SideNavDrawer.dart';
import 'RoundedBorderedContainer.dart';

var numOrders = 0;

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> newSelectedMenu = selectedMenu;
    newSelectedMenu.removeAt(0);
    newSelectedMenu.removeAt(0);
    double totalCost = 0;
    var fill = '';
    for (int i = 0; i < selectedMenuItemsCost.length; i++) {
      totalCost = totalCost + selectedMenuItemsCost[i];
    }
    if (tableNum == null || tableNum == '') {
      fill = 'NO TABLE NUMBER ENTERED';
    } else if (tableNum != null || tableNum != '') {
      fill = 'Table #' + tableNum;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
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
            selectedMenu.insert(
                0,
                TextField(
                  textAlign: TextAlign.center,
                  controller: textControllerTableNum,
                  decoration: InputDecoration(
                    hintText: "Enter your table number",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ));
            selectedMenu.insert(
                1,
                RaisedButton(
                  child: Text('Checkout'),
                  onPressed: () {
                    tableNum = textControllerTableNum.text;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Checkout()));
                  },
                ));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QRCodeReaderPage()));
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
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
                    return Container(
                      child: newSelectedMenu[index],
                    );
                  }),
            ),
          ),
          RoundedContainer(
            elevation: 7,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Text(fill),
              trailing: Text('Total: \$' + totalCost.toString()),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: RoundedContainer(
              elevation: 7,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  numOrders++;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProcessOrder(newSelectedMenu, totalCost)));
                },
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.paypal,
                    color: Colors.indigo,
                  ),
                  title: Text("Paypal"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
