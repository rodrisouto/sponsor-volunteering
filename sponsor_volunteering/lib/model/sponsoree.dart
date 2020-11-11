import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Sponsoree {
  String id;
  final String name;
  final String address;
  final String description;
  final GeoPoint location;

  Sponsoree(this.name, this.address, this.description, this.location);

  Sponsoree.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot.documentID != null),
        assert(snapshot.data['name'] != null),
        assert(snapshot.data['address'] != null),
        assert(snapshot.data['description'] != null),
        assert(snapshot.data['location'] != null),
        id = snapshot.documentID,
        name = snapshot.data['name'],
        address = snapshot.data['address'],
        description = snapshot.data['description'],
        location = snapshot.data['location'];

  LocationResult buildLocationResult() {
    return LocationResult(
        latLng: LatLng(location.latitude, location.longitude),
        address: address,
        placeId: '');
  }
}
