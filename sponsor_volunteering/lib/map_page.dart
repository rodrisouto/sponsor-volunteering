import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sponsor_volunteering/components/sponsoree_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Dummy Title')),
      body: SponsoreeMap(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
    );
  }
}
