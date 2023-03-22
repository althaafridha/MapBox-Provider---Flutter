import 'package:flutter/material.dart';

class Vehicle {
  final String vehicleName;
  final IconData vehicleIcon;
  final String descriptionDistance;
  final String descriptionTime;
  bool? isChoosen;

  Vehicle(
    this.vehicleIcon,
    this.vehicleName,
    this.descriptionDistance,
    this.descriptionTime,
    this.isChoosen,
  );
}
