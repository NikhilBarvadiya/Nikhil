import 'package:flutter/material.dart';
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
  final multiOrdersController = Get.put(MultiOrdersController());
  final Set<Marker> b2bMarkers = {};
  final Set<Polyline> _b2bPolyline = {};
  final Set<Polyline> b2bClosePolyline = {};
  final Set<Marker> b2cMarkers = {};
  final Set<Polyline> _b2cPolyline = {};
  final Set<Polyline> b2cClosePolyline = {};
  List<LatLng> b2bLating = [];
  List<LatLng> b2cLating = [];
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
                color: multiOrdersController.order[0]['isActive'] == true
                    ? multiOrdersController.isPolyline
                        ? Colors.white
                        : Theme.of(context).primaryColor
                    : multiOrdersController.isb2cPolyline
                        ? Colors.white
                        : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<MultiOrdersController>(
        builder: (_) => Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: multiOrdersController.selectedOrderTrueList.isNotEmpty
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: multiOrdersController.order[0]['isActive'] == true
                                  ? LatLng(
                                      multiOrdersController.selectedOrderTrueList[0]['addressId']["lat"],
                                      multiOrdersController.selectedOrderTrueList[0]['addressId']["lng"],
                                    )
                                  : LatLng(
                                      multiOrdersController.selectedB2COrderTrueList[0]['lat'],
                                      multiOrdersController.selectedB2COrderTrueList[0]['lng'],
                                    ),
                              zoom: 18,
                            ),
                            compassEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            onMapCreated: multiOrdersController.onMapCreated,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            trafficEnabled: false,
                            indoorViewEnabled: false,
                            mapType: MapType.normal,
                            markers: multiOrdersController.order[0]['isActive'] == true ? getB2BMarkers() : getB2CMarkers(),
                            polylines: multiOrdersController.order[0]['isActive'] == true
                                ? multiOrdersController.isPolyline
                                    ? _b2bPolyline
                                    : b2bClosePolyline
                                : multiOrdersController.isb2cPolyline
                                    ? _b2cPolyline
                                    : b2cClosePolyline,
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
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

  Set<Marker> getB2BMarkers() {
    for (var i = 0; i < multiOrdersController.selectedOrderTrueList.length; i++) {
      b2bMarkers
          .addLabelMarker(
            LabelMarker(
              label: "${i + 1}",
              markerId: MarkerId('marker$i'),
              position: LatLng(
                multiOrdersController.selectedOrderTrueList[i]['addressId']["lat"],
                multiOrdersController.selectedOrderTrueList[i]['addressId']["lng"],
              ),
              backgroundColor: Colors.redAccent,
              onTap: () {
                showB2BInModel(i);
              },
              textStyle: const TextStyle(
                fontSize: 35,
              ),
            ),
          )
          .then(
            (value) {},
          );
      b2bLating.add(
        LatLng(
          multiOrdersController.selectedOrderTrueList[i]['addressId']["lat"],
          multiOrdersController.selectedOrderTrueList[i]['addressId']["lng"],
        ),
      );
    }
    _b2bPolyline.add(
      Polyline(
        polylineId: const PolylineId('1'),
        points: b2bLating,
        color: Colors.black.withOpacity(0.2),
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        width: 2,
      ),
    );
    return b2bMarkers;
  }

  showB2BInModel(int i) {
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
                      readOnly: true,
                      onEditingComplete: () => Get.back(),
                      showCursor: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "${i + 1}",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
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
              title: Text("${multiOrdersController.selectedOrderTrueList[i]["addressId"]["person"]}"),
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
              title: Text("${multiOrdersController.selectedOrderTrueList[i]["addressId"]["name"]}"),
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
              title: Text("${multiOrdersController.selectedOrderTrueList[i]["addressId"]["address"]}"),
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
              title: Text("${multiOrdersController.selectedOrderTrueList[i]["addressId"]["mobile"]}"),
            ),
          ],
        );
      },
    );
  }

  Set<Marker> getB2CMarkers() {
    for (var i = 0; i < multiOrdersController.selectedB2COrderTrueList.length; i++) {
      dynamic latLong = multiOrdersController.selectedB2COrderTrueList[i]["latLong"].split(",");
      if (latLong != null) {
        multiOrdersController.selectedB2COrderTrueList[i]['lat'] = double.parse(latLong[0].toString().trim());
        multiOrdersController.selectedB2COrderTrueList[i]['lng'] = double.parse(latLong[1].toString().trim());
      }
      b2cMarkers
          .addLabelMarker(
            LabelMarker(
              label: "${i + 1}",
              markerId: MarkerId('marker$i'),
              position: LatLng(
                multiOrdersController.selectedB2COrderTrueList[i]['lat'],
                multiOrdersController.selectedB2COrderTrueList[i]['lng'],
              ),
              backgroundColor: Colors.redAccent,
              onTap: () {
                showB2CInModel(i);
              },
              textStyle: const TextStyle(
                fontSize: 35,
              ),
            ),
          )
          .then(
            (value) {},
          );
      b2cLating.add(
        LatLng(
          multiOrdersController.selectedB2COrderTrueList[i]['lat'],
          multiOrdersController.selectedB2COrderTrueList[i]['lng'],
        ),
      );
    }
    _b2cPolyline.add(
      Polyline(
        polylineId: const PolylineId('1'),
        points: b2cLating,
        color: Colors.black.withOpacity(0.2),
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        width: 2,
      ),
    );
    return b2cMarkers;
  }

  showB2CInModel(int i) {
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
                      readOnly: true,
                      onEditingComplete: () => Get.back(),
                      showCursor: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "${i + 1}",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
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
              title: Text("${multiOrdersController.selectedB2COrderTrueList[i]["name"]}"),
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
              title: Text("${multiOrdersController.selectedB2COrderTrueList[i]["name"]}"),
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
              title: Text("${multiOrdersController.selectedB2COrderTrueList[i]["address"]}"),
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
              title: Text("${multiOrdersController.selectedB2COrderTrueList[i]["mobile"]}"),
            ),
          ],
        );
      },
    );
  }
}
