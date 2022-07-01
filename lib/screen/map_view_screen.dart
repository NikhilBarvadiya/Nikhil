// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/map_view_controller.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/widgets/common_widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final mapController = Get.put(MapViewController());
  final multiOrdersController = Get.put(MultiOrdersController());
  final Set<Marker> markers = Set();
  final Set<Polyline> _polyline = {};
  final Set<Polyline> closePolyline = {};
  List<LatLng> lating = [];
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white,
        title: const Text("Map Sorting"),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                multiOrdersController.onPolyline();
              });
            },
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 15),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline,
                color: multiOrdersController.isPolyline ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<MapViewController>(
        builder: (_) => Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        multiOrdersController.selectedOrderTrueList[0]['addressId']["lat"],
                        multiOrdersController.selectedOrderTrueList[0]['addressId']["lng"],
                      ),
                      zoom: 11,
                      tilt: 0,
                      bearing: 0,
                    ),
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: mapController.onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    trafficEnabled: false,
                    indoorViewEnabled: false,
                    mapType: MapType.normal,
                    markers: getmarkers(),
                    polylines: mapController.isPolyline ? _polyline : closePolyline,
                  ),
                ],
              ),
            ),
            CustomButton(
              width: Get.width * 0.4,
              height: 35.0,
              text: "Back",
              buttonColor: Colors.white,
              iconColor: Colors.white,
              icon: Icons.arrow_back_outlined,
              context: context,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    for (var i = 0; i < multiOrdersController.selectedOrderTrueList[0]['addressId'].length; i++) {
      markers
          .addLabelMarker(
        LabelMarker(
          label: "${i + 1}",
          markerId: MarkerId('marker$i'),
          position: LatLng(
            multiOrdersController.selectedOrderTrueList[0]['addressId']["lat"],
            multiOrdersController.selectedOrderTrueList[0]['addressId']["lng"],
          ),
          backgroundColor: Colors.redAccent,
          onTap: () {
            showInModel(i);
          },
          textStyle: const TextStyle(
            fontSize: 35,
          ),
        ),
      )
          .then(
        (value) {
          // setState(() {});
        },
      );
      lating.add(
        LatLng(
          multiOrdersController.selectedOrderTrueList[0]['addressId']["lat"],
          multiOrdersController.selectedOrderTrueList[0]['addressId']["lng"],
        ),
      );
    }
    _polyline.add(
      Polyline(
        polylineId: const PolylineId('1'),
        points: lating,
        color: Colors.black.withOpacity(0.2),
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        width: 2,
      ),
    );
    return markers;
  }

  showInModel(int i) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Location Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      // controller: multiOrdersController.numberController[0],
                      onEditingComplete: () => Get.back(),
                      showCursor: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const Text(
              "Person",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: Text("${multiOrdersController.selectedOrderTrueList[0]["addressId"]["person"]}"),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const Text(
              "Shop Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shop, color: Colors.black),
              title: Text("${multiOrdersController.selectedOrderTrueList[0]["addressId"]["name"]}"),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const Text(
              "Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_city, color: Colors.black),
              title: Text("${multiOrdersController.selectedOrderTrueList[0]["addressId"]["address"]}"),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            const Text(
              "Mobile Number",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.black),
              title: Text("${multiOrdersController.selectedOrderTrueList[0]["addressId"]["mobile"]}"),
            ),
          ],
        );
      },
    );
  }
}
