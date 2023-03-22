import 'package:flutter/material.dart';

import '../model/vehicle.dart';

class VehicleMenu extends ChangeNotifier {

  List<Vehicle> motorItems = [
    Vehicle(
      Icons.motorcycle, 
      'GoRide', 
      "0.5 km", 
      "5 min", 
      false
    ),
    Vehicle(
      Icons.motorcycle, 
      'GoRide - Plus', 
      "0.5 km", 
      "5 min", 
      false
    ),
  ];

  List<Vehicle> get getRideItems => motorItems;

  List<Vehicle> carItems = [
    Vehicle(
      Icons.directions_car, 
      'GoCar', 
      "0.5 km", 
      "5 min", 
      false
    ),
    Vehicle(
      Icons.directions_car, 
      'GoCar - Plus', 
      "0.5 km", 
      "5 min", 
      false
    )
  ];

  List<Vehicle> get getCarItems => carItems;
}
