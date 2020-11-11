import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sponsor_volunteering/components/need_list_title.dart';
import 'package:sponsor_volunteering/sponsoree_details_page.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/need_list_item.dart';
import 'model/need.dart';
import 'model/sponsoree.dart';

class LoadSponsoreePage extends StatefulWidget {
  final Sponsoree initialSponsoree;
  final Function afterLeaving;

  const LoadSponsoreePage({this.initialSponsoree, this.afterLeaving});

  @override
  _LoadSponsoreePageState createState() {
    return _LoadSponsoreePageState();
  }
}

class _LoadSponsoreePageState extends State<LoadSponsoreePage> {
  final _formKey = GlobalKey<FormState>();
  double _pad = 20; // !!!!
  String _name;
  LocationResult _location;
  String _description;

  List<Need> _needList;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _name = widget.initialSponsoree?.name;
      _nameController.text = widget.initialSponsoree?.name != null
          ? widget.initialSponsoree.name
          : '';

      _location = widget.initialSponsoree == null
          ? null
          : widget.initialSponsoree.buildLocationResult();

      _description = widget.initialSponsoree?.description;
      _descriptionController.text = widget.initialSponsoree?.description != null
          ? widget.initialSponsoree.description
          : '';

      _needList = widget.initialSponsoree == null
          ? []
          : widget.initialSponsoree.needList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Sponsoree')),
      body: Stack(
        children: <Widget>[
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        padding: EdgeInsets.only(left: 28, top: 20, right: 28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTitle(),
              _buildInputAddress(),
              _buildInputName(),
              _buildInputDescription(),
              _buildNeedListTitle(),
              _buildNeedList(),
              _buildSaveSponsoreeButton(),
            ],
          ),
        ));
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: Text('Complete with the information of your sponsoree'),
    );
  }

  Widget _buildInputAddress() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text('Location'),
          IconButton(
            icon: Icon(Icons.add_location),
            onPressed: () async {
              LocationResult result = await showLocationPicker(
                context, 'apikey',
                initialCenter: _location == null
                    ? LatLng(-34.605930, -58.434540)
                    : _location.latLng,
                myLocationButtonEnabled: true,
                desiredAccuracy: LocationAccuracy.high,
                // layersButtonEnabled: true,
                // automaticallyAnimateToCurrentLocation: true,
                // mapStylePath: 'assets/mapStyle.json',
                // requiredGPS: true,
                // resultCardAlignment: Alignment.bottomCenter,
              );

              // If no new location was selected, keep the previous one.
              if (result == null && _location != null) {
                return;
              }

              setState(() => _location = result);
            },
          ),
          Flexible(child: Text(_location != null ? _location.address : '')),
        ],
      ),
    );
  }

  Widget _buildInputName() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: TextFormField(
        controller: _nameController,
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

  Widget _buildInputDescription() {
    return Container(
      padding: EdgeInsets.only(bottom: _pad),
      child: TextFormField(
        controller: _descriptionController,
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

  Widget _buildNeedListTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        NeedListTitle(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.add_circle),
            iconSize: 30,
            onPressed: _showNewNeedlistTileDialog,
          ),
        )
      ]),
    );
  }

  Widget _buildNeedList() {
    Widget needListItems = Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Text('Add needs to your sponsoree'));

    if (_needList.isNotEmpty) {
      needListItems = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _needList.length,
        itemBuilder: (context, i) {
          return _buildNeedListTile(i, _needList[i]);
        },
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: 5),
      height: 300,
      child: needListItems,
    );
  }

  Widget _buildNeedListTile(int index, Need need) {
    return NeedListItem(need: need, index: index, onClick: (_, index) => _showDeleteNeedDialog(index));
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: CheckboxListTile(
        title: Text(need.text),
        secondary: Icon(Icons.help),
        controlAffinity: ListTileControlAffinity.platform,
        value: need.checked,
        onChanged: (bool value) {
          _showDeleteNeedDialog(index);
        },
        activeColor: Colors.green,
        checkColor: Colors.black,
      ),
    );
  }

  Widget _buildSaveSponsoreeButton() {
    return Container(
        padding: EdgeInsets.only(bottom: 25),
        child: SizedBox(
          height: 50.0,
          width: 300,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.teal,
            child: Text(
                widget.initialSponsoree == null
                    ? 'Register Sponsoree'
                    : 'Save Changes',
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
          title: Text('New Need-List Item'),
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
                        String newNeedText = textController.text.toString();

                        if (newNeedText.isEmpty) {
                          return;
                        }

                        Need newNeed = Need(text: newNeedText, checked: false);
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
          title: Text('Are you sure you want to delete this need?'),
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

  void _showRegisterError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please fill all the form\'s fields!'),
          actions: <Widget>[
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('OK',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black)),
                      onPressed: () => Navigator.pop(context),
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

    // TODO limit name with n characters
    // TODO not allow empty needlist
    if (_name == null ||
        _name.isEmpty ||
        _location == null ||
        _location.address == null ||
        _location.address.isEmpty ||
        _description == null ||
        _description.isEmpty) {
      _showRegisterError();
      return;
    }

    Sponsoree sponsoree = Sponsoree(
        name: _name,
        address: _location.address,
        description: _description,
        location:
            GeoPoint(_location.latLng.latitude, _location.latLng.longitude),
        needList: _needList);

    if (widget.initialSponsoree == null) {
      sponsoreeRepository.save(sponsoree);
    } else {
      sponsoreeRepository.update(widget.initialSponsoree.id, sponsoree);
    }

    // Workaround to update Details page after making changes on the sponsoree.
    widget.afterLeaving();
    Navigator.pop(context);
  }
}
