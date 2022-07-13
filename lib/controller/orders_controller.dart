import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OrdersController extends GetxController {
  String selectedFilter = "Pending";
  bool isdragDrop = false;
  bool ordersFilter = true;
  bool isSlider = true;
  bool start = true;
  bool findingRoute = true;
  bool isBounded = false;
  List selectedOrderList = [];
  String startDateVendor = "";
  String endDateVendor = "";
  LatLng sourceLocation = const LatLng(21.1591425, 72.6822094);
  LatLng destination = const LatLng(21.1452, 72.7572);
  Completer<GoogleMapController> completer = Completer();
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};
  dynamic destinationIcon;

  List filters = [
    {
      "icon": Icons.pending_actions,
      "label": "Pending",
      "isActive": true,
    },
    {
      "icon": Icons.running_with_errors,
      "label": "Running",
      "isActive": false,
    },
    {
      "icon": Icons.fact_check_outlined,
      "label": "Complete",
      "isActive": false,
    },
    {
      "icon": Icons.cancel,
      "label": "Cancelled",
      "isActive": false,
    }
  ];

  void onMapCreated(GoogleMapController controller) {
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
    update();
  }

  getBackToSource() {
    if (start) {
      completer.future.then((value) {
        value.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: sourceLocation, zoom: 16),
          ),
        );
      });
    } else {
      _getBoundedView();
    }
    start = !start;
    update();
  }

  Set<Marker> getmarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.fromBytes(destinationIcon),
      ),
    );
    getPolyPoint();
    return markers;
  }

  getCurrentLocation() async {
    Location location = Location();
    location.changeSettings(accuracy: LocationAccuracy.high);
    location.getLocation().then((location) {
      sourceLocation = LatLng(location.latitude!, location.longitude!);
      findingRoute = false;
      getmarkers();
      update();
    });
    destinationIcon = await _getBytesFromAsset(imageAssets.destination, 130);
    location.onLocationChanged.listen((location) {
      sourceLocation = LatLng(location.latitude!, location.longitude!);
      markers.forEach((element) {
        if (element.markerId == const MarkerId('pickup')) {
          setLocation(element.position);
        }
      });
      getPolyPoint();
      update();
    });
  }

  setLocation(LatLng position) {
    position = sourceLocation;
  }

  getPolyPoint() async {
    List<LatLng> _polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAIS-paIxOHBldW5OqArB0mmXSJQxW7zog",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => _polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      polylineCoordinates = _polylineCoordinates;
      update();
      if (!isBounded) {
        isBounded = true;
        update();
        _getBoundedView();
      }
    }
  }

  _getBoundedView() {
    completer.future.then((value) {
      value.animateCamera(CameraUpdate.newLatLngBounds(_boundsFromLatLngList(polylineCoordinates), 50));
    });
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  onRecord(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = selectedOrderList[0].removeAt(oldIndex);
    selectedOrderList[0].insert(newIndex, item);
    update();
  }

  @override
  void onInit() {
    onOrdersApiCalling();
    super.onInit();
  }

  onChange(int i) {
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilter = filters[a]["label"];
      } else {
        filters[a]["isActive"] = false;
      }
    }
    onOrdersApiCalling();
    update();
  }

  onOrdersApiCalling() async {
    if (filters[0]['isActive'] == true) {
      await fatchOrders("Pending");
    }
    if (filters[1]['isActive'] == true) {
      await fatchOrders("Running");
    }
    if (filters[2]['isActive'] == true) {
      await fatchOrders("Complete");
    }
    if (filters[3]['isActive'] == true) {
      await fatchOrders("Cancelled");
    }
    update();
  }

  onRefresh() {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        startDateVendor = "";
        endDateVendor = "";
        update();
      },
    );
  }

  onDetailsTap(dynamic data) {
    Get.toNamed(AppRoutes.ordersDetailsScreen, arguments: data);
    update();
  }

  onMap() {
    Get.toNamed(AppRoutes.ordersLocationMap);
    update();
  }

  onBack() {
    isdragDrop = false;
    Get.back();
    isdragDrop = !isdragDrop;
    update();
  }

  void openEditDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit orders details'),
        actions: [
          ListTile(
            title: const Text("Edit"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.editOrdersScreen);
              update();
            },
          ),
          ListTile(
            title: const Text("Drag And Drop"),
            onTap: () {
              isdragDrop = !isdragDrop;
              update();
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Send To Driver"),
            onTap: () async {
              String link = "https://wa.me/916357017016";
              // ignore: deprecated_member_use
              await launch(link);
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Add New"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.newOrdersScreen);
              update();
            },
          ),
        ],
      ),
    );
  }

  fatchOrders(type) async {
    try {
      var resData = await apis.call(
        apiMethods.orders,
        {
          "page": 1,
          "limit": 10,
          "search": "",
          "type": type,
          "fromDate": startDateVendor.split("T").first,
          "toDate": endDateVendor.split("T").first,
          "searchFilter": "3",
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        selectedOrderList = resData.data["orders"]["docs"];
      }
    } catch (e) {
      log("Error orders not faound");
    }
    update();
  }

  onDatePickerVendor() async {
    ordersFilter = true;
    update();
    await dateVendorTimeRangePicker(Get.context!);
  }

  dateVendorTimeRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select a Date or Date-Range',
      initialDateRange: DateTimeRange(
        end: DateTime.now(),
        start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      ),
    );

    if (picked != null) {
      startDateVendor = picked.start.toIso8601String();
      endDateVendor = picked.end.toIso8601String();
      update();
    }
  }
}
