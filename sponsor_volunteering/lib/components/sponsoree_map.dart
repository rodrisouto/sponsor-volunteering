import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sponsor_volunteering/model/sponsoree.dart';
import 'package:sponsor_volunteering/sponsoree_repository.dart';

class SponsoreeMap extends StatefulWidget {
  @override
  _SponsoreeMapState createState() => _SponsoreeMapState();
}

class _SponsoreeMapState extends State<SponsoreeMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

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
        zoomControlsEnabled: false
    );
  }

  Map<String, Marker> _mapMarkers(List<Sponsoree> sponsorees) {
    Map<String, Marker> markers = {};
    for (Sponsoree sponsoree in sponsorees) {
      print(sponsoree);
      Marker marker = Marker(
        markerId: MarkerId(sponsoree.id),
        position: LatLng(sponsoree.location.latitude, sponsoree.location.longitude),
        infoWindow: InfoWindow(
          title: sponsoree.name,
          snippet: sponsoree.description,
        ),
      );
      markers[sponsoree.id] = marker;
    }
    return markers;
  }

  Widget _map(){
    return StreamBuilder(
        stream: _getSponsorees(),
        builder: (context, snapshotStream) {
          if (snapshotStream.hasError) {
            return Text("MyOrders: Error ${snapshotStream.error}");
          }
          List<Sponsoree> sponsorees = snapshotStream.data;
          return _mapDrawer(context, _mapMarkers(sponsorees));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _map();
  }
}
