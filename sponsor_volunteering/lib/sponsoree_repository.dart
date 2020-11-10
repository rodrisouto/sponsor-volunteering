import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/sponsoree.dart';

class SponsoreeRepository {

  Stream<List<Sponsoree>> getAll() {
    return Firestore.instance.collection('sponsoree').snapshots()
        .map((event) {
          return event.documents.map((document) => Sponsoree.fromSnapshot(document));
    });
  }

  void save(Sponsoree sponsoree) {
    Firestore.instance.collection('sponsoree').add({
      'name': sponsoree.name,
      'address': sponsoree.address,
      'description': sponsoree.description,
    })
    .then((docRef) {
      print('\n\n\n\n!!!! Document written with ID: ${docRef.documentID}');
    })
    .catchError((error) {
      print('\n\n\n\n!!!! Error adding document: ${error}');
    });
  }
}

final sponsoreeRepository = SponsoreeRepository();
