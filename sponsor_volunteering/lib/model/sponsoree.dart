import 'package:cloud_firestore/cloud_firestore.dart';

class Sponsoree {
  String id;
  final String name;
  final String address;
  final String description;

  Sponsoree(this.name, this.address, this.description);

  Sponsoree.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['address'] != null),
        assert(map['description'] != null),
        id = map['id'],
        name = map['name'],
        address = map['address'],
        description = map['description'];

  Sponsoree.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}