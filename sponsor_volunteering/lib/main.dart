import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sponsor_volunteering/map_page.dart';
import 'package:sponsor_volunteering/xyz.dart';

import 'load_sponsoree.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: LoadSponsoree(),
    );
  }
}
