import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadSponsoree extends StatefulWidget {
  @override
  _LoadSponsoreeState createState() {
    return _LoadSponsoreeState();
  }
}

class _LoadSponsoreeState extends State<LoadSponsoree> {
  final _formKey = GlobalKey<FormState>();
  double pad = 20; // !!!!
  String address;
  String sponsoreeName;
  String _description;

  // !!!!
  bool _checked = false;
  List<String> needList = [];

  List<Widget> _formFields;

  @override
  void initState() {
    super.initState();
    setState(() {
      _formFields = <Widget>[
        Text("Address"),
        Text("Name"),
        Text("Description"),
        _showInputDescription(),
      ];
    });
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
              //_showNeedListTile(),
              _showAddNewListTileButton(),
              // _showInputNewNeedListTile(),
            ],
          ),
        ));
  }

  Widget _showTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: pad),
      child: Text('Complete with the information of your sponsoree'),
    );
  }

  Widget _showInputAddress() {
    return Container(
      padding: EdgeInsets.only(bottom: pad),
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Address',
        ),
        onSaved: (value) => setState(() {
          address = value.trim();
        }),
      ),
    );
  }

  Widget _showInputSponsoreeName() {
    return Container(
      padding: EdgeInsets.only(bottom: pad),
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Name',
        ),
        onSaved: (value) => setState(() {
          sponsoreeName = value.trim();
        }),
      ),
    );
  }

  Widget _showInputDescription() {
    return Container(
      padding: EdgeInsets.only(bottom: pad),
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
          itemCount: needList.length,
          itemBuilder: (context, i) {
            return _showNeedListTile(i, needList[i]);
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

  Widget _showInputNewNeedListTile() {
    return Container(
      padding: EdgeInsets.only(bottom: pad),
      child: Row(
        children: [
          Icon(Icons.beach_access),
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Need Item',
            ),
            onSaved: (value) => setState(() {
              _description = value.trim();
            }),
          ),
        ],
      ),
    );
  }

  Widget _showAddNewListTileButton() {
    return Container(
        padding: EdgeInsets.only(bottom: pad),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.teal,
            child: Text('Register Sponsoree',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _showNewNeedlistTileDialog,
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
                          needList.add(newNeed);
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
                          needList.removeAt(index);
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
}
