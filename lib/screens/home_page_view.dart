import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/utils.dart';
import 'goride_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String user = "Althaaf";
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _getGeoLocationPosition();
    getLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 20,
                          color: grey,
                        ),
                      ),
                      Text(
                        "$user!",
                        style: TextStyle(
                          fontSize: 24,
                          color: black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100.0),
                        )),
                    child: Icon(
                      Icons.person,
                      color: white,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://katalogpromosi.com/wp-content/uploads/2022/12/promo-gopay-payday-25012023-01.jpg"),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GoRidePageView(latitude: latitude, longitude: longitude,))),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: green,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                          child: Icon(
                            Icons.motorcycle,
                            color: white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "GoRide",
                          style: TextStyle(
                            fontSize: 14,
                            color: black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: green,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                          child: Icon(
                            Icons.directions_car,
                            color: white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "GoCar",
                          style: TextStyle(
                            fontSize: 14,
                            color: black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: maroon,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Icon(
                          Icons.restaurant,
                          color: white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "GoFood",
                        style: TextStyle(
                          fontSize: 14,
                          color: black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: purple,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Icon(
                          Icons.local_shipping,
                          color: white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "GoSend",
                        style: TextStyle(
                          fontSize: 14,
                          color: black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  //getLongLAT
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  getLatLong() async {
    Position position = await _getGeoLocationPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }
}
