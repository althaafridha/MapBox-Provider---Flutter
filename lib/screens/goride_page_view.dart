import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/vehicleMenu.dart';
import '../utils/utils.dart';
import '../widgets/ride_list.dart';

const mapboxAccessToken =
    "pk.eyJ1IjoiZHppa3J1bDE2MTYiLCJhIjoiY2xleWJ6aTdlMGc0ODQxcXZsaDZlaDhwciJ9.Nz95V3UL1b8AfExigWUllA";

class GoRidePageView extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoRidePageView(
      {super.key, required this.latitude, required this.longitude});

  static const routeGoRide = '/goride';

  @override
  State<GoRidePageView> createState() => _GoRidePageViewState();
}

class _GoRidePageViewState extends State<GoRidePageView> {
  String fromLocation = "";
  String dataFrom = "";
  String subLocal = "";

  String selectedTheme = 'streets-v12';
  List<LatLng> routeCoords = [];
  bool isRouteShown = false;
  double distance = 0.0;

  String duration = "";

  String destinationName = "";

  @override
  void initState() {
    super.initState();
    getAddressFromLongLat();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleMenu(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Flutter Map widget
              SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: StreamBuilder(
                    stream: Geolocator.getPositionStream(),
                    builder: (context, snapshot) {
                      // final position = snapshot.data as Position;
                      final markerPosition =
                          LatLng(widget.latitude, widget.longitude);
                      return FlutterMap(
                        options: MapOptions(
                            center: markerPosition,
                            zoom: 18.0,
                            minZoom: 5,
                            maxZoom: 25,
                            onTap: (as, LatLng? latlng) {
                              if (routeCoords.isNotEmpty) {
                                setState(() {
                                  isRouteShown = false;
                                  routeCoords.clear();
                                  distance = 0.0;
                                });
                              }
                              _getRoute(markerPosition, latlng!);
                            }),
                        nonRotatedChildren: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accestoken}',
                            additionalOptions: {
                              'accestoken': mapboxAccessToken,
                              'id': 'mapbox/$selectedTheme',
                            },
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: markerPosition,
                                builder: (context) => Icon(
                                  Icons.location_on,
                                  color: red,
                                  size: 60,
                                ),
                              ),
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: routeCoords.isNotEmpty
                                    ? routeCoords.last
                                    : markerPosition,
                                builder: (context) => Icon(
                                  Icons.location_on,
                                  color: green,
                                  size: 60,
                                ),
                              ),
                            ],
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: routeCoords,
                                color: green,
                                strokeWidth: 5.0,
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
              // Container on top of the map
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.place, color: red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: lightGrey,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  fromLocation == ""
                                      ? "Your Current Location"
                                      : fromLocation,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.place, color: green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: lightGrey,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  destinationName == ""
                                      ? subLocal == ""
                                          ? "Where to"
                                          : subLocal
                                      : destinationName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: destinationName == ""
                                        ? subLocal == ""
                                            ? grey
                                            : black
                                        : black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height *
                    0.7, // menentukan tinggi DraggableScrollableSheet
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.2,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, -3), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: grey,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                              child: RideList(
                                  distance: distance.toString(),
                                  durations: duration)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          width: double.infinity,
          color: white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: green, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "Book Now",
                    style: TextStyle(
                        color: green,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  )),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const WaitingPage(),
                  //   ),
                  // );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "Search a Driver",
                    style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getRoute(LatLng origin, LatLng destination) async {
    final url =
        "https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?alternatives=true&exclude=toll&geometries=geojson&language=en&overview=simplified&steps=true&access_token=$mapboxAccessToken";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    final route = data['routes'][0]['geometry']['coordinates'];
    final legs = data['routes'][0]['legs'][0];
    final duration = legs['duration'] ~/ 60;

    final destinationName = legs['summary'].split(',').last;
    setState(() {
      routeCoords = route
          .map((point) => LatLng(point[1], point[0]))
          .toList()
          .cast<LatLng>();
      distance = data['routes'][0]['distance'] / 1000.0;

      if (distance < 1) {
        setState(() {
          distance = (distance * 1000).roundToDouble();
        });
      } else {
        distance = distance;
      }

      this.duration = "$duration min";
      this.destinationName = destinationName;
    });
  }

  Future<void> getAddressFromLongLat() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(widget.latitude, widget.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      dataFrom = "${place.street}";
      subLocal = "${place.subLocality}";
    });
  }
}
