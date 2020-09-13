import 'package:flutter/material.dart';


import 'RestaurantOrCustomer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      home: RestaurantOrCustomer(),
    );
  }
}