import 'package:cloud_firestore/cloud_firestore.dart';

class Need {
  final String text;
  bool checked;

  Need({this.text, this.checked});

  Need.fromMap(Map map)
      : assert(map['text'] != null),
        assert(map['checked'] != null),
        text = map['text'],
        checked = map['checked'];

  @override
  String toString() {
    return 'Need{text: $text, checked: $checked}';
  }
}
