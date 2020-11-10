import 'package:flutter/material.dart';
import 'package:sponsor_volunteering/load_sponsoree_page.dart';
import 'package:sponsor_volunteering/model/sponsoree.dart';

import 'model/need.dart';

class SponsoreeDetailsPage extends StatefulWidget {
  final Sponsoree sponsoree;

  SponsoreeDetailsPage(this.sponsoree);

  @override
  State<StatefulWidget> createState() {
    return _SponsoreeDetailsPageState();
  }
}

class _SponsoreeDetailsPageState extends State<SponsoreeDetailsPage> {
  List<Need> _needList = [Need('Food', false), Need('Shoes', false)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('!!!!')),
        body: Stack(
          children: <Widget>[
            _buildBody(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoadSponsoreePage(widget.sponsoree))),
            tooltip: 'Edit',
            child: Icon(Icons.edit)));
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              widget.sponsoree.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                fontSize: 18.0,
              ),
            ),
          ),
          _field('Address', widget.sponsoree.address),
          _field('Description', widget.sponsoree.description),
          _buildNeedListTitle(),
          _buildNeedList(),
        ],
      ),
    );
  }

  Container _field(String title, String text) {
    return Container(
        color: Colors.white24,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              // TODO note this for the future: without this t
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$title:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildNeedListTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text('Need-List'),
        ],
      ),
    );
  }

  Widget _buildNeedList() {
    return Container(
        padding: EdgeInsets.only(bottom: 5),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _needList.length,
          itemBuilder: (context, i) {
            return _buildNeedListTile(i, _needList[i]);
          },
        ));
  }

  Widget _buildNeedListTile(int index, Need need) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: CheckboxListTile(
        title: Text(need.text),
        secondary: Icon(Icons.beach_access),
        controlAffinity: ListTileControlAffinity.platform,
        value: need.checked,
        onChanged: (bool value) {
          if (value) {
            setState(() => need.checked = true);
          }
        },
        activeColor: Colors.green,
        checkColor: Colors.black,
      ),
    );
  }
}
