import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sponsor_volunteering/model/need.dart';

class NeedListItem extends StatelessWidget {
  final Need need;
  final int index;
  final Function onClick;

  NeedListItem({this.need, this.index, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: CheckboxListTile(
        title: Text(need.text),
        secondary: Icon(Icons.star_border),
        controlAffinity: ListTileControlAffinity.platform,
        value: need.checked,
        onChanged: (bool value, ) {
          onClick(value, index);
        },
        activeColor: Colors.green,
        checkColor: Colors.black,
      ),
    );
  }
}