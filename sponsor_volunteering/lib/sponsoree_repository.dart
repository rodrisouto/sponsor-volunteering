import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/sponsoree.dart';

class SponsoreeRepository {
  Stream<List<Sponsoree>> getAll() {
    return Firestore.instance.collection('sponsoree').snapshots().map((event) {
      return event.documents
          .map((document) => Sponsoree.fromSnapshot(document))
          .toList();
    });
  }

  void save(Sponsoree sponsoree) {
    Firestore.instance.collection('sponsoree').add({
      'name': sponsoree.name,
      'address': sponsoree.address,
      'description': sponsoree.description,
      'location': sponsoree.location,
      'needList': sponsoree.needList
          .map((need) => {'text': need.text, 'checked': need.checked})
          .toList()
    }).then((docRef) {
      print('\n\n\n\n!!!! Document written with ID: ${docRef.documentID}');
    }).catchError((error) {
      print('\n\n\n\n!!!! Error adding document: ${error}');
    });
  }

  void update(String id, Sponsoree sponsoree) {
    Firestore.instance.collection('sponsoree').document(id).updateData({
      'name': sponsoree.name,
      'address': sponsoree.address,
      'description': sponsoree.description,
      'location': sponsoree.location,
    }).then((_) {
      print('\n\n\n\n!!!! Document updated with ID: $id');
    }).catchError((error) {
      print('\n\n\n\n!!!! Error updating document with ID $id: ${error}');
    });
  }
}

final sponsoreeRepository = SponsoreeRepository();
