import 'package:flutter/material.dart';
import 'package:latihan_provider_mapbox/utils/utils.dart';

class VehicleItems extends StatefulWidget {
  final String vehicleName;
  final IconData vehicleIcon;
  final String descriptionDistance;
  final String descriptionTime;
  bool? isChoosen;

  VehicleItems(
      {super.key, required this.vehicleName,
      required this.descriptionDistance,
      required this.descriptionTime,
      this.isChoosen,
      required this.vehicleIcon});

  @override
  State<VehicleItems> createState() => _VehicleItemsState();
}

class _VehicleItemsState extends State<VehicleItems> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isChoosen = !widget.isChoosen!;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.isChoosen! ? lightGreen : white,
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: green,
              ),
              child: Center(
                child: Icon(
                  widget.vehicleIcon,
                  color: white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.descriptionDistance,
                  style: TextStyle(
                    fontSize: 14,
                    color: grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.descriptionTime,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
