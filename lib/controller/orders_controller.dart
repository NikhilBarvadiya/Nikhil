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
  TextEditingController txtSearchController = TextEditingController();
  bool isdragDrop = false;
  bool ordersFilter = true;
  bool isSlider = true;
  bool start = true;
  bool findingRoute = true;
  bool isBounded = false;
  bool isContainsKey = false;
  List selectedOrderList = [];
  String startDateVendor = "";
  String endDateVendor = "";
  String searchFilterName = "";
  String searchFilterId = "";
  LatLng sourceLocation = const LatLng(21.1591425, 72.6822094);
  LatLng destination = const LatLng(21.1452, 72.7572);
  Completer<GoogleMapController> completer = Completer();
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};
  dynamic locationStatus;
  dynamic destinationIcon;

  List filters = [
    {
      "icon": Icons.pending_actions,
      "label": "Pending",
      "isActive": true,
    },
    {
      "icon": Icons.running_with_errors,
      "label": "Accpeted",
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

  List searchFilter = [
    {
      "name": "Driver Name",
      "_id": "0",
      "isActive": false,
    },
    {
      "name": "Location Name",
      "_id": "1",
      "isActive": false,
    },
    {
      "name": "Route No",
      "_id": "2",
      "isActive": false,
    },
    {
      "name": "Order No",
      "_id": "3",
      "isActive": false,
    },
    {
      "name": "Customer Name",
      "_id": "4",
      "isActive": false,
    },
  ];

  onSearchFilter(items) {
    for (int a = 0; a < searchFilter.length; a++) {
      if (a == items) {
        searchFilter[a]["isActive"] = true;
        searchFilterName = searchFilter[a]["name"];
        searchFilterId = searchFilter[a]["_id"];
      } else {
        searchFilter[a]["isActive"] = false;
      }
    }
    onOrdersApiCalling("");
    update();
    Get.back();
  }

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
    onOrdersApiCalling("");
    super.onInit();
  }

  onChange(int i) {
    searchFilterName = "";
    searchFilterId = "";
    txtSearchController.clear();
    for (int a = 0; a < filters.length; a++) {
      if (a == i) {
        filters[a]["isActive"] = true;
        selectedFilter = filters[a]["label"];
      } else {
        filters[a]["isActive"] = false;
      }
    }
    onOrdersApiCalling("");
    update();
  }

  onOrdersApiCalling(search) async {
    if (filters[0]['isActive'] == true) {
      await fatchOrders("Pending", search);
    }
    if (filters[1]['isActive'] == true) {
      await fatchOrders("Accepted", search);
    }
    if (filters[2]['isActive'] == true) {
      await fatchOrders("Completed", search);
    }
    if (filters[3]['isActive'] == true) {
      await fatchOrders("Cancelled", search);
    }
    update();
  }

  onRefresh() {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        startDateVendor = "";
        endDateVendor = "";
        searchFilterName = "";
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

  void openEditDialog(dynamic data) {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit orders details'),
        actions: [
          ListTile(
            title: const Text("Edit"),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.editOrdersScreen, arguments: data);
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
          ListTile(
            title: const Text("Delete"),
            onTap: () {
              Get.back();
              update();
            },
          ),
        ],
      ),
    );
  }

  fatchOrders(type, search) async {
    try {
      var resData = await apis.call(
        apiMethods.orders,
        {
          "page": 1,
          "limit": 20,
          "search": search,
          "type": type,
          "fromDate": startDateVendor.split("T").first,
          "toDate": endDateVendor.split("T").first,
          "searchFilter": searchFilterId,
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

  bool hasVendorData(items) {
    bool hasKey = false;
    for (int i = 0; i < items.length; i++) {
      if (items[i]["vendorData"] != null) {
        hasKey = true;
      }
    }
    return hasKey;
  }

  String getTotalCashAndReceiveCash(items, String show) {
    double receivedCash = 0;
    double cashToBeRecieved = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i]["vendorData"] != null) {
        if (items[i]["vendorData"]["cash"] != null) {
          cashToBeRecieved += double.parse(items[i]["vendorData"]["cash"].toString()).toPrecision(2);
        }

        if (items[i]["vendorData"]["cashReceive"] != null) {
          receivedCash += double.parse(items[i]["vendorData"]["cashReceive"].toString()).toPrecision(2);
        }
      }
    }

    return show == "cash" ? cashToBeRecieved.toString() : receivedCash.toString();
  }
}
