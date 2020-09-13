import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:sprintf/sprintf.dart';

import 'RoundedBorderedContainer.dart';
import 'QRCodeReaderPage.dart';

class SideNavDrawer extends StatefulWidget {
  final total;

  SideNavDrawer({Key key, this.total});

  @override
  SideNavDrawerState createState() => SideNavDrawerState();
}

List<Widget> selectedMenu = [];
List<String> selectedItems = [];
List selectedMenuItemsCost = [];
var strippedSelected;

class SideNavDrawerState extends State<SideNavDrawer> {
  var currVal = '';
  int oddEven = 0;
  Color oddEvenColor;
  String selected;
  List menuItemsDisplayed = [];
  var sum = 0;

  @override
  Widget build(BuildContext context) {
    menuItemsDisplayed.clear();
    for (int i = 1;
        i <= map["Restaurant's"][cameraScanResult[1]]['value']['value'];
        i++) {
      menuItemsDisplayed.add(
        sprintf('Item: %s             Cost: \$%s',
            [widget.total['item$i'], widget.total['cost$i']]),
      );
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Add to Order',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          SearchableDropdown.single(
            items: menuItemsDisplayed.map(
              (e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              },
            ).toList(),
            value: selected,
            hint: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Select any"),
            ),
            searchHint: "Select any",
            onChanged: (value) {
              setState(() {
                selected = value;
              });
            },
            isExpanded: true,
          ),
          RaisedButton(
            child: Text('Add to Order'),
            onPressed: () {
              var regexpInt = selected.replaceAll(RegExp(r'[^0-9, .]'), '');
              selectedMenuItemsCost.add(double.parse(regexpInt));
              strippedSelected = selected.replaceAll('0', '');
              strippedSelected = strippedSelected.replaceAll('1', '');
              strippedSelected = strippedSelected.replaceAll('2', '');
              strippedSelected = strippedSelected.replaceAll('3', '');
              strippedSelected = strippedSelected.replaceAll('4', '');
              strippedSelected = strippedSelected.replaceAll('5', '');
              strippedSelected = strippedSelected.replaceAll('6', '');
              strippedSelected = strippedSelected.replaceAll('7', '');
              strippedSelected = strippedSelected.replaceAll('8', '');
              strippedSelected = strippedSelected.replaceAll('9', '');
              strippedSelected = strippedSelected.replaceAll('Item: ', '');
              strippedSelected = strippedSelected.replaceAll('Cost: ', '');
              strippedSelected = strippedSelected.replaceAll('             ', '');
              strippedSelected = strippedSelected.replaceAll('\$', '');
              selectedItems.add(strippedSelected);
              if (oddEven % 2 == 1) {
                oddEvenColor = Color(0xffF8F8F8);
              } else {
                oddEvenColor = Colors.white;
              }
              selectedMenu.add(
                Container(
                  decoration: BoxDecoration(
                    color: oddEvenColor,
                  ),
                  padding: EdgeInsets.only(top: 25, bottom: 25),
                  child: Text(selected),
                ),
              );
              oddEven++;
            },
          )
        ],
      ),
    );
  }
}
