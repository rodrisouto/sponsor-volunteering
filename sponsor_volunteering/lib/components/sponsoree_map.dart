import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sponsor_volunteering/model/sponsoree.dart';
import 'package:sponsor_volunteering/sponsoree_details_page.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';

class SponsoreeMap extends StatefulWidget {
  @override
  _SponsoreeMapState createState() => _SponsoreeMapState();
}

class _SponsoreeMapState extends State<SponsoreeMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(-34.605930, -58.434540);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Stream<List<Sponsoree>> _getSponsorees() {
    return sponsoreeRepository.getAll();
  }

  GoogleMap _mapDrawer(BuildContext context, Map<String, Marker> markers) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0
      ),
      mapType: MapType.normal,
      markers: markers.values.toSet(),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onTap: (_) => print('Tap out'),
    );
  }

  Map<String, Marker> _mapMarkers(List<Sponsoree> sponsorees, sponsoreesStream) {
    Map<String, Marker> markers = {};
    for (Sponsoree sponsoree in sponsorees) {
      print(sponsoree);
      Marker marker = Marker(
        markerId: MarkerId(sponsoree.id),
        position: LatLng(
            sponsoree.location.latitude, sponsoree.location.longitude),
        infoWindow: InfoWindow(
          title: sponsoree.name,
          snippet: sponsoree.description,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SponsoreeDetailsPage(sponsoree)));
        },
      );
      markers[sponsoree.id] = marker;
    }
    return markers;
  }

  Widget _map() {
    final sponsoreesStream = _getSponsorees();

    return StreamBuilder(
        stream: sponsoreesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("MyOrders: Error ${snapshot.error}");
          }

          List<Sponsoree> sponsorees = snapshot.data;
          return _mapDrawer(context, _mapMarkers(sponsorees, sponsoreesStream));
        }
    );
  }

  /*
  Widget _trying(Stream<List<Sponsoree>> sponsoreesStream, int index) {
    Stream<Sponsoree> sponsoreeStream = sponsoreesStream.map((event) {
      print('\n\n\n\n !!!! event $event');
      final x = event[index];
      print('\n\n\n\n !!!! $x');
      return x;
    });

    return StreamBuilder(
        stream: sponsoreeStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("MyOrders: Error ${snapshot.error}");
          }

          if (!snapshot.hasData) {
            return Text('al;jfdkla;jfkla;jla;d');
          }
          
          print('hasData: ${snapshot.data}');
          
          Sponsoree sponsoree = snapshot.data;
          return SponsoreeDetailsPage(sponsoree);
        }
    );
  }


   */
  @override
  Widget build(BuildContext context) {
    return _map();
  }
}
