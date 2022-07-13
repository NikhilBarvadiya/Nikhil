import 'package:flutter/material.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersLocationMap extends StatefulWidget {
  const OrdersLocationMap({Key? key}) : super(key: key);

  @override
  State<OrdersLocationMap> createState() => _OrdersLocationMapState();
}

class _OrdersLocationMapState extends State<OrdersLocationMap> {
  OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Navigation"),
        actions: [
          MaterialButton(
            onPressed: () {
              ordersController.getBackToSource();
            },
            child: Row(
              children: [
                ordersController.start
                    ? const Icon(
                        Icons.my_location_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.location_searching,
                        color: Colors.white,
                      ),
                const SizedBox(width: 5),
                Text(
                  ordersController.start ? "Start" : 'Full view',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: ordersController.sourceLocation,
              zoom: 11,
            ),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: ordersController.onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            markers: ordersController.markers,
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: ordersController.polylineCoordinates,
                color: Colors.blue,
                width: 4,
              ),
            },
          ),
        ],
      ),
    );
  }
}
