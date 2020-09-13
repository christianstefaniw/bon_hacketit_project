import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'QRCodeReaderPage.dart';
import 'RestaurantMainPage.dart';
import 'SideNavDrawer.dart';


class RestaurantOrCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    selectedMenu.clear();
    selectedItems.clear();
    selectedMenuItemsCost.clear();
    textControllerTableNum.clear();
    itemsVal.clear();
    costsVal.clear();
    textControllerName.text = '';
    numItems = 1;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Customer',
              style: GoogleFonts.sourceSansPro(
                textStyle:
                TextStyle(color: Colors.black, fontSize:30, fontWeight: FontWeight.w300),
              ),
            ),
            CircleAvatar(
              backgroundImage: ExactAssetImage('assets/images/order.png'),
              radius: 70,
              child: FlatButton(
                child: null,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRCodeReaderPage())),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              'Restaurant',
              style: GoogleFonts.sourceSansPro(
                textStyle:
                TextStyle(color: Colors.black, fontSize:30, fontWeight: FontWeight.w300),
              ),
            ),
            CircleAvatar(
              backgroundImage: ExactAssetImage('assets/images/restaurant.png'),
                radius: 70,
                child: FlatButton(
                  child: null,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantMainPage())),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
