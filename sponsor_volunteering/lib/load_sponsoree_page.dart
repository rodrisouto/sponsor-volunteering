import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';

import 'model/sponsoree.dart';

class LoadSponsoreePage extends StatefulWidget {
  @override
  _LoadSponsoreePageState createState() {
    return _LoadSponsoreePageState();
  }
}

class _LoadSponsoreePageState extends State<LoadSponsoreePage> {
  final _formKey = GlobalKey<FormState>();
  double _pad = 20; // !!!!
  String _address;
  String _name;
  String _description;

  List<String> _needList = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('!!!!')),
        body: Stack(
          children: <Widget>[
            _showBody(),
          ],
        ));
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.only(left: 28, top: 20, right: 28),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showTitle(),
              _showInputAddress(),
              _showInputSponsoreeName(),
              _showInputDescription(),
              _showInputNeedListTitle(),
              _showInputNeedList(),
              _showAddNewListTileButton(),
            ],
          ),
        ));
  }

  Widget _showTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: Text('Complete with the information of your sponsoree'),
    );
  }

  Widget _showInputAddress() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Address',
        ),
        onSaved: (value) {
          print(value);
          setState(() {
            _address = value.trim();
          });
        },
      ),
    );
  }

  Widget _showInputSponsoreeName() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Name',
        ),
        onSaved: (value) => setState(() {
          _name = value.trim();
        }),
      ),
    );
  }

  Widget _showInputDescription() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Description',
        ),
        onSaved: (value) => setState(() {
          _description = value.trim();
        }),
      ),
    );
  }

  Widget _showInputNeedListTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text('Need-List'),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              _showNewNeedlistTileDialog();
            },
          )
        ],
      ),
    );
  }

  Widget _showInputNeedList() {
    return Container(
        padding: EdgeInsets.only(bottom: 5),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _needList.length,
          itemBuilder: (context, i) {
            return _showNeedListTile(i, _needList[i]);
          },
        ));
  }

  Widget _showNeedListTile(int index, String need) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: CheckboxListTile(
        title: Text(need),
        secondary: Icon(Icons.beach_access),
        controlAffinity: ListTileControlAffinity.platform,
        value: false,
        onChanged: (bool value) {
          _showDeleteNeedDialog(index);
        },
        activeColor: Colors.green,
        checkColor: Colors.black,
      ),
    );
  }

  Widget _showAddNewListTileButton() {
    return Container(
        padding: EdgeInsets.only(bottom: _pad),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.teal,
            child: Text('Register Sponsoree',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () => _saveSponsoree(),
          ),
        ));
  }

  void _showNewNeedlistTileDialog() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Need-List Item"),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('CANCEL',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black38)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text('SUBMIT',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black)),
                      onPressed: () {
                        String newNeed = textController.text.toString();

                        if (newNeed.isEmpty) {
                          return;
                        }

                        setState(() {
                          _needList.add(newNeed);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }

  void _showDeleteNeedDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this need?"),
          actions: <Widget>[
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('CANCEL',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black38)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text('DELETE',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black)),
                      onPressed: () {
                        setState(() {
                          _needList.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }

  void _saveSponsoree() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    }

    print('\n\n\n\n!!!! $_name $_address $_description');
    if (_name == null ||
        _name.isEmpty ||
        _address == null ||
        _address.isEmpty ||
        _description == null ||
        _description.isEmpty) {
      print('\n\n\n\n!!!! Can\'t create sponsoree with empty fields.');
      return;
    }

    // TODO: Remove hardcoded LatLng
    Sponsoree sponsoree = Sponsoree(_name, _address, _description, GeoPoint(45.521563, -122.677433));
    sponsoreeRepository.save(sponsoree);
  }
}
