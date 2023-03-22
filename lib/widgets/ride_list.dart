import 'package:flutter/material.dart';
import 'package:latihan_provider_mapbox/providers/vehicleMenu.dart';
import 'package:latihan_provider_mapbox/widgets/vehicle_items.dart';
import 'package:provider/provider.dart';

class RideList extends StatelessWidget {
  final String durations;
  final String distance;

  const RideList({
    super.key, required this.durations, required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleData = Provider.of<VehicleMenu>(context);
    final vehicle = vehicleData.getRideItems;

    return ListView.builder(
      itemCount: vehicle.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return VehicleItems(
          vehicleName: vehicle[index].vehicleName,
          descriptionDistance: distance,
          descriptionTime: durations,
          isChoosen: vehicle[index].isChoosen,
          vehicleIcon: vehicle[index].vehicleIcon,
        );
      },
    );
  }
}
