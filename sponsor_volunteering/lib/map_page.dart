import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sponsor_volunteering/components/sponsoree_map.dart';

import 'load_sponsoree_page.dart';
import 'model/sponsoree.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  Future _onAddSponsoreeButton() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoadSponsoreePage(initialSponsoree: null, afterLeaving: () => null)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AYUD.AR')),
      body: SponsoreeMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddSponsoreeButton,
        tooltip: "Add Sponsoree",
        child: Icon(Icons.add),
      ),
    );
  }
}
