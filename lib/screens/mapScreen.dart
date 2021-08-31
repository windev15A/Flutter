import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
 List<Marker> myMarkers = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      myMarkers.add(
        Marker(
          markerId: MarkerId("paris"),
          position:LatLng(48.866667,  2.333333),
          icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "Paris")
        )
      );
      myMarkers.add(
          Marker(
            markerId: MarkerId("Versailles"),
            position:LatLng(48.8035403,  2.1266886),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "Versailles")
          )
      );
      myMarkers.add(
          Marker(
            markerId: MarkerId("Nanterre"),
            position:LatLng(48.8924273,  2.2071267),
            icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: "Nanterre")
          )
      );
      myMarkers.add(
          Marker(
            markerId: MarkerId("Pontoise"),
            position:LatLng(49.0508845,  2.1008067),
            icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: "Pontoise")
          )
      );
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.866667,2.333333),
    zoom: 11.15,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(48.866667,2.333333),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        // myLocationButtonEnabled: false,
        // zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: myMarkers.toSet(),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}