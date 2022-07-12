// ignore_for_file: equal_keys_in_map, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/networking/api_type.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MultiOrdersController extends GetxController {
  TextEditingController shortNumberController = TextEditingController();
  final amountController = TextEditingController(text: "0");
  final itemsNameController = TextEditingController();
  final itemsController = TextEditingController();
  String shortNumber = "";
  bool isOpenTap = false;
  bool isOpenOrder = false;
  bool isOpenB2COrder = false;
  bool isPolyline = false;
  bool isb2cPolyline = false;
  List selectedOrderTrueList = [];
  String selectedOrder = "B2B Order";
  List order = [
    {
      "order": "B2B Order",
      "isActive": true,
    },
    {
      "order": "B2C Order",
      "isActive": false,
    },
  ];

  @override
  void onInit() {
    fatchbusinessCategories();
    fatchArea("");
    getGlobalAddressBySearch("");
    _autoSelector();
    isBusinessSelected = "";
    isVendorsSelectedId = "";
    isAreaSelected = "";
    isRouteSelectedId = "";
    super.onInit();
  }

  Completer<GoogleMapController> mapController = Completer();
  dynamic locationsList;

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    update();
  }

  onShortNumberUpdate(int index) {
    selectedOrderTrueList[index]['addressId']['shortNo'] = shortNumberController.text.toString();
    update();
    Get.back();
  }

  onChange(int i) {
    for (int a = 0; a < order.length; a++) {
      if (a == i) {
        order[a]["isActive"] = true;
        isBusinessSelected = "";
        isVendorsSelectedId = "";
        isAreaSelected = "";
        isRouteSelectedId = "";
        isb2cRouteSelectedId = "";
        isB2CVendorsSelectedId = "";
        selectedOrder = order[a]["order"];
      } else {
        order[a]["isActive"] = false;
      }
    }
    update();
  }

  onOpenTap() {
    isBusinessSelected = "";
    isVendorsSelectedId = "";
    isAreaSelected = "";
    isRouteSelectedId = "";
    isb2cRouteSelectedId = "";
    isB2CVendorsSelectedId = "";
    isOpenTap = !isOpenTap;
    _autoSelector();
    update();
  }

  onOpenOrder() async {
    if (isRouteSelectedId != "" && isBusinessSelected != "" && isAreaSelected != "") {
      isOpenOrder = true;
      await fatchVendorOrders();
      _autoSelector();
    } else {
      isOpenOrder = false;
    }
  }

  onB2COpen() async {
    if (isb2cRouteSelectedId != "" && isBusinessSelected != "" && isb2cRouteSelected != "") {
      isOpenB2COrder = true;
      await fatchB2CVendorOrders();
      _autoB2CSelector();
    } else {
      isOpenB2COrder = false;
    }
  }

  toggleOpenOrder() {
    isOpenOrder = !isOpenOrder;
    update();
  }

  toggleOpenB2COrder() {
    isOpenB2COrder = !isOpenB2COrder;
    update();
  }

  onRouteSelected(String name, String id) async {
    isRouteSelected = name;
    isRouteSelectedId = id;
    if (isRouteSelectedId != "" && isAreaSelected != "") {
      Get.back();
      onOpenOrder();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      Get.back();
    }
    update();
  }

  onBusinessSelected(String id, String name) async {
    isBusinessSelectedId = id;
    isBusinessSelected = name;
    isVendorsSelectedId = "";
    isAreaSelected = "";
    isRouteSelectedId = "";
    isb2cRouteSelectedId = "";
    isB2CVendorsSelectedId = "";
    if (order[0]['isActive'] == true) {
      fatchVendor("");
    }
    if (order[1]['isActive'] == true) {
      fatchB2CVendor("");
    }
    if (isBusinessSelected != "") {
      onOpenOrder();
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  onVendorsSelected(String name, String id) async {
    isVendorsSelected = name;
    isAreaSelected = "";
    isRouteSelectedId = "";
    if (isBusinessSelected != "") {
      isVendorsSelectedId = id;
      Get.back();
      onOpenOrder();
    } else {
      Get.snackbar(
        "Error",
        "Please select business categories ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  onAreaSelected(String id, String name) async {
    isAreaSelected = name;
    isAreaSelectedId = id;
    isRouteSelectedId = "";
    fatchArea("");
    fatchRoute("");
    if (isAreaSelected != "") {
      Get.back();
      onOpenOrder();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  onSelectedLocation() {
    Get.toNamed(AppRoutes.selectedLocation);
    update();
  }

  List pickupItemsList = [];
  List selectedLocations = [];

  String isPickupSelectedId = "";
  String isPickupSelected = "";

  onPickupItemsList(String id, String name) async {
    if (id != "") {
      isPickupSelectedId = id;
      isPickupSelected = name;
      getGlobalAddress.forEach(
        (element) {
          if (element['_id'] == id) {
            isPickupSelected = element['name'];
            selectedPickupPoint = element;
          }
        },
      );
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  dynamic getGlobalAddress;
  dynamic selectedPickupPoint;

  getGlobalAddressBySearch(search) async {
    try {
      var resData = await apis.call(
        apiMethods.getGlobalAddressBySearch,
        {
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        getGlobalAddress = resData.data;
      }
      update();
      return getGlobalAddress;
    } catch (e) {
      return [];
    }
  }

  dynamic vehiclesNames;
  String isVehiclesSelectedId = "";
  String isVehiclesSelected = "";

  onSelectedVehiclesList(String id, String name) async {
    isVehiclesSelectedId = id;
    isVehiclesSelected = name;
    if (isVehiclesSelected != "") {
      fatchDriversByVehicleName();
      Get.back();
    } else {
      Get.snackbar(
        "Sorry",
        "No data found ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  fatchVehiclesNames(search) async {
    try {
      var resData = await apis.call(
        apiMethods.vehiclesNames,
        {
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        vehiclesNames = resData.data;
      }
      update();
      return vehiclesNames;
    } catch (e) {
      return null;
    }
  }

  dynamic driversByVehicleName;
  String isDriversSelectedId = "";
  String isDriversSelected = "";

  onBack() {
    isVehiclesSelected = "";
    isDriversSelected = "";
    isPickupSelected = "";
    amountController.clear();
    Get.back();
    update();
  }

  onSelectedDriverVehiclesList(String id, String name) async {
    isDriversSelectedId = id;
    isDriversSelected = name;
    if (isDriversSelected != "") {
      fatchDriversByVehicleName();
      Get.back();
    } else {
      Get.snackbar(
        "Sorry",
        "No data found ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  fatchDriversByVehicleName() async {
    try {
      var resData = await apis.call(
        apiMethods.driversByVehicleName,
        {
          "requestedVehicle": isVehiclesSelected,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        driversByVehicleName = resData.data;
      }
      update();
      return driversByVehicleName;
    } catch (e) {
      return null;
    }
  }

  List selectedIds = [];
  List selectedOrderStatusIds = [];

  //TESTED
  onMerge() {
    List location = [];
    selectedIds = [];
    selectedOrderStatusIds = [];
    for (var e in selectedOrderTrueList) {
      e["vendorOrderId"] == null ? selectedIds.add(e["vendorOrderId"]) : selectedIds.add(e["vendorOrderId"]["_id"]);
      selectedOrderStatusIds.add(e['_id']);
      dynamic data;
      if (e['addressId'] != null) {
        data = location.where((loc) => loc['_id'] == e['addressId']['_id']).toList();
      }
      var vendorName = e['vendorOrderId']['vendorId']['name'];
      var nOfPackages = e['nOfPackages'];
      String itemName = "${vendorName}_$nOfPackages";
      if (e['notes'] != null) {
        itemName = "$itemName ${e['notes']}";
      }
      var item = {
        "itemName": itemName,
        "quantity": nOfPackages,
        "vendorData": {
          "vendorId": e['vendorOrderId']['vendorId']['_id'],
          "vendorOrderId": e['vendorOrderId']['_id'],
          "itemId": e['_id'],
          "notes": e['notes'] ?? '',
          "addressId": e['addressId'] == null ? '' : e['addressId']['_id'],
          "routeId": e['addressId'] == null ? '' : e['addressId']['routeId'],
          "cash": e['cash'],
          "cashReceive": e['cashReceived'] ?? 0,
        }
      };
      pickupItemsList.add(item);
      if (data != null && data.length > 0) {
        var locIndex = location.indexOf(data[0]);
        location[locIndex]['itemList'].add(item);
      } else {
        dynamic loc;
        if (e['addressId'] != null) {
          loc = {
            ...e['addressId'],
            "itemList": [item],
            "vendorAnyNote": e['anyNote'] ?? '',
          };
        } else {
          var splitLatLong = e['latLong'].split(',');
          loc = {
            "address": "${e['flatFloorBuilding']}${e['address']}",
            "businessCategoryId": e['businessCategoryId'],
            "flatFloorBuilding": '',
            "isDeleted": false,
            "lat": double.parse(splitLatLong[0].trim()),
            "lng": double.parse(splitLatLong[1].trim()),
            "mobile": e['mobile'],
            "name": e['name'],
            "person": '',
            "routeId": '',
            "shortNo": e['shortNo'],
            "vendorAnyNote": e['anyNote'] ?? '',
            "itemList": [item],
          };
        }
        location.add(loc);
      }
    }
    selectedLocations = location;
    if (selectedLocations.isNotEmpty) {
      Get.toNamed(AppRoutes.merge);
    }
    update();
  }

  List finalLocations = [];
  onPlacingOrderClicked() {
    finalLocations = [];
    if (selectedPickupPoint != null && isVehiclesSelected != '' && isDriversSelected != '') {
      finalLocations = selectedLocations;
      finalLocations.insert(0, selectedPickupPoint);
      finalLocations[0]['itemList'] = pickupItemsList;
      onPlacingOrder(finalLocations);
    } else {
      Get.snackbar(
        "* Fields are Mandatory",
        "Info",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  dynamic finalOrder;
  onPlacingOrder(List selectedLocation) async {
    bool orderPreview = true;
    dynamic orders = {
      "driver": {
        "driverId": isDriversSelected == '' ? null : driversByVehicleName[0]["_id"],
        "driverName": isDriversSelected == '' ? null : driversByVehicleName[0]["name"],
        "driverPhone": isDriversSelected == '' ? null : driversByVehicleName[0]["mobile"],
        "driverPhoto": isDriversSelected == '' ? null : driversByVehicleName[0]["mobile"],
        "driverRating": 0,
        "vehicleNo": isDriversSelected == '' ? null : driversByVehicleName[0]["vehicleNo"],
        "vehiclePhoto": isDriversSelected == '' ? null : driversByVehicleName[0]["vehicleId"],
      },
      "date": DateTime.now().toIso8601String().split("T").first,
      "dateType": 'Now',
      "requestedVehicle": isVehiclesSelected,
      "deliveryCharges": 0,
      "convenienceCharges": 0,
      "totalLaborCharges": 0,
      "totalFragileCharges": 0,
      "totalInsuranceCharges": 0,
      "totalPayableAmount": 0,
      "driverAmount": 0,
      "adminAmount": 0,
      "gstAmount": 0,
      "roundOff": 0,
      "distance": '',
      "distanceValue": 0,
      "orderNo": '',
      "paymentMode": 'Wallet',
      "paymentReceived": false,
      "paymentId": '',
      "walletPoint": 0,
      "rejectedBy": [],
      "requestStatus": isDriversSelected == '' ? 'Pending' : 'Accepted',
      "rideStatus": 'Pending',
      'isPaid': false,
      "driverRating": 0,
      "customerRating": 0,
      "orderStatus": [
        {
          "date": DateTime.now().toIso8601String().split("T").first,
          "status": isDriversSelected == '' ? 'Pending' : 'Accepted',
          "images": [],
        },
      ],
      "customerId": '',
    };
    dynamic locations = [];
    for (int i = 0; i < selectedLocation.length; i++) {
      var data = selectedLocation[i];
      dynamic outObjects = {};
      outObjects["type"] = (i == 0)
          ? 'Pickup'
          : (i == selectedLocation.length - 1)
              ? 'Drop'
              : 'Stop';
      var lItems = [];
      var weight = 0;
      data['itemList'].forEach((item) {
        lItems.add({
          "name": item["itemName"],
          "quantity": item["quantity"],
          "vendorData": item["vendorData"],
          "weight": 100,
          "weightType": 'GM',
        });
        weight += 100;
      });
      var lPackage = {
        "contentList": outObjects["type"] != 'Drop' ? [] : [],
        "images": outObjects["type"] != 'Drop' ? [] : [],
        "laborCharges": outObjects["type"] != 'Drop' ? 0 : null,
        "laborQty": outObjects["type"] != 'Drop' ? 0 : null,
        "laborType": outObjects["type"] != 'Drop' ? 'hr' : null,
        "isFragile": outObjects["type"] != 'Drop' ? false : null,
        "fragileCharges": outObjects["type"] != 'Drop' ? 0 : null,
        "isInsurance": outObjects["type"] != 'Drop' ? false : null,
        "totalPackageCharges": outObjects["type"] != 'Drop' ? 0 : null,
        "insuranceCharges": outObjects["type"] != 'Drop' ? 0 : null,
        "payAtPickup": outObjects["type"] != 'Drop' ? null : null,
        "invoice": outObjects["type"] != 'Drop' ? '' : null,
        "itemTotalWeight": outObjects["type"] != 'Drop' ? weight : null,
        "total": outObjects["type"] != 'Drop' ? 0 : null,
        "anyNote": "",
        "itemList": lItems,
      };
      outObjects["package"] = lPackage;
      outObjects["instructionAudio"] = '';
      outObjects["otp"] = '1234';
      outObjects["location"] = {
        "name": data["name"],
        "address": data["address"],
        "lat": data["lat"],
        "lng": data["lng"],
        "flatFloorBuilding": data["flatFloorBuilding"],
        "person": data["person"],
        "mobile": data["mobile"],
      };
      locations.add(outObjects);
    }
    orders["locations"] = locations;
    var vehicleId = '';
    for (var e in vehiclesNames) {
      if (e["name"] == isVehiclesSelected) {
        vehicleId = e["_id"];
        break;
      }
    }
    dynamic ordersData = {
      "pick": null,
      "drop": null,
      "stops": [],
      "vehicleId": vehicleId,
      "isWallet": false,
      "walletAvailableAmount": 0,
    };
    for (var i = 0; i < orders['locations'].length; i++) {
      if (i == 0) {
        ordersData["pick"] = orders['locations'][i];
      }
      if (i != 0 && i != orders['locations'].length - 1) {
        ordersData["stops"].add(orders['locations'][i]);
      }
      if (i == orders['locations'].length - 1) {
        ordersData["drop"] = orders['locations'][i];
      }
    }
    try {
      var resData = await apis.call(
        apiMethods.calculateOrder,
        {
          "orderData": ordersData,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true) {
        dynamic calulations = resData.data;
        orders["adminAmount"] = calulations["adminCharges"];
        orders["driverAmount"] = amountController.text;
        orders["totalFragileCharges"] = calulations["fragileCharges"];
        orders["gstAmount"] = calulations["gstCharges"];
        orders["totalInsuranceCharges"] = calulations["insuranceCharges"];
        orders["totalLaborCharges"] = calulations["laborCharges"];
        orders["roundOff"] = calulations["roundOff"];
        orders["totalPayableAmount"] = calulations["total"];
        orders["convenienceCharges"] = calulations["totalConvenienceCharges"];
        orders["deliveryCharges"] = calulations["totalDeliveryCharges"];
        orders["distance"] = calulations["totalDistance"];
        orders["distanceValue"] = calulations["totalDistance"];
        orders["totalKm"] = calulations["totalDistance"];
        orders["walletPoint"] = calulations["walletAmount"];
        finalOrder = orders;
        await saveOrders();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error finalOrder");
      }
    }
    update();
  }

  saveOrders() async {
    try {
      print("finalOrder================$finalOrder");
      print("orderIds" + selectedIds.toSet().toList().toString());
      print("orderStatusIds" + selectedOrderStatusIds.toSet().toList().toString());
      var resData = await apis.call(
        ApiMethods().saveAdminOrder,
        {
          // "orderData": finalOrder,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        try {
          var updateData = await apis.call(
            ApiMethods().updateVendorOrders,
            {
              // "orderIds": selectedIds.toSet().toList(),
              // "orderStatusIds": selectedOrderStatusIds.toSet().toList(),
              // "orderHaveDriver": isDriversSelected != "" ? true : false,
            },
            ApiType.post,
          );
          if (updateData.isSuccess == true && updateData.data != 0) {
            // LoadingAnimationWidget.flickr(
            //   leftDotColor: const Color(0xFF0063DC),
            //   rightDotColor: const Color(0xFFFF0084),
            //   size: 25,
            // );
            Get.defaultDialog(
              title: "Success",
              middleText: "Successfully orders save",
              radius: 2,
              actions: [
                TextButton(
                  onPressed: () {
                    isBusinessSelected = "";
                    isVendorsSelectedId = "";
                    isAreaSelected = "";
                    isRouteSelectedId = "";
                    isb2cRouteSelectedId = "";
                    isB2CVendorsSelectedId = "";
                    isVehiclesSelected = "";
                    isDriversSelected = "";
                    isPickupSelected = "";
                    isOpenTap = false;
                    isOpenOrder = false;
                    isOpenB2COrder = false;
                    amountController.clear();
                    selectedOrderTrueList.clear();
                    selectedB2COrderTrueList.clear();
                    vendorOrdersList.clear();
                    Get.offNamedUntil(AppRoutes.home, (Route<dynamic> route) => true);
                    update();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          }
        } catch (e) {
          Get.defaultDialog(
            title: "Success",
            middleText: "Successfully update",
            radius: 2,
          );
        }
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Success",
        middleText: "Successfully orders place",
        radius: 2,
      );
    }
  }

  onAssignDriver() {
    fatchVehiclesNames("");
    if (isPickupSelected != "") {
      Get.toNamed(AppRoutes.assignDriver);
    } else {
      Get.snackbar(
        "Alert",
        "Please select pickup point.....",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  List pickupB2CItemsList = [];
  List selectedB2CLocations = [];

  onB2CMerge() {
    List selectedIds = [];
    List selectedOrderStatusIds = [];
    List location = [];
    for (var e in selectedB2COrderTrueList) {
      e["vendorOrderId"] == null ? selectedIds.add(e["vendorOrderId"]) : selectedIds.add(e["vendorOrderId"]["_id"]);
      selectedOrderStatusIds.add(e['_id']);
      dynamic data;
      if (e['addressId'] != null) {
        data = location.where((loc) => loc['_id'] == e['addressId']['_id']).toList();
      }
      var vendorName = e['vendorOrderId']['vendorId']['name'];
      var nOfPackages = e['nOfPackages'];
      String itemName = "${vendorName}_$nOfPackages";
      if (e['notes'] != null) {
        itemName = "$itemName ${e['notes']}";
      }
      var item = {
        "itemName": itemName,
        "quantity": nOfPackages,
        "vendorData": {
          "vendorId": e['vendorOrderId']['vendorId']['_id'],
          "vendorOrderId": e['vendorOrderId']['_id'],
          "itemId": e['_id'],
          "notes": e['notes'] ?? '',
          "addressId": e['addressId'] == null ? '' : e['addressId']['_id'],
          "routeId": e['addressId'] == null ? '' : e['addressId']['routeId'],
          "cash": e['cash'],
          "cashReceive": e['cashReceived'] ?? 0,
        }
      };
      pickupItemsList.add(item);
      if (data != null && data.length > 0) {
        var locIndex = location.indexOf(data[0]);
        location[locIndex]['itemList'].add(item);
      } else {
        dynamic loc;
        if (e['addressId'] != null) {
          loc = {
            ...e['addressId'],
            "itemList": [item],
            "vendorAnyNote": e['anyNote'] ?? '',
          };
        } else {
          var splitLatLong = e['latLong'].split(',');
          loc = {
            "address": "${e['flatFloorBuilding']}${e['address']}",
            "businessCategoryId": e['businessCategoryId'],
            "flatFloorBuilding": '',
            "isDeleted": false,
            "lat": double.parse(splitLatLong[0].trim()),
            "lng": double.parse(splitLatLong[1].trim()),
            "mobile": e['mobile'],
            "name": e['name'],
            "person": '',
            "routeId": '',
            "shortNo": e['shortNo'],
            "vendorAnyNote": e['anyNote'] ?? '',
            "itemList": [item],
          };
        }
        location.add(loc);
      }
    }
    selectedB2CLocations = location;
    if (selectedB2CLocations.isNotEmpty) {
      Get.toNamed(AppRoutes.merge);
    }
    update();
  }

  onMap() {
    Get.toNamed(AppRoutes.mapView);
    update();
  }

  onPolyline() {
    if (order[0]['isActive'] == true) {
      isPolyline = !isPolyline;
      update();
    } else {
      isb2cPolyline = !isb2cPolyline;
      update();
    }
  }

  List businessCategories = [];
  String isBusinessSelected = "";
  String isBusinessSelectedId = "";

  fatchbusinessCategories() async {
    try {
      var resData = await apis.call(apiMethods.businessCategories, {}, ApiType.post);
      businessCategories = resData.data;
      businessCategories.map((element) {
        if (element['_id'] == isBusinessSelectedId) {
          isBusinessSelected = element['title'];
        }
      });
    } catch (e) {
      return null;
    }
    update();
  }

  List getVendorsList = [];
  String isVendorsSelected = "";
  String isVendorsSelectedId = "";

  fatchVendor(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.getVendors,
        {
          "businessCategoryId": isBusinessSelectedId,
          "_id": isVendorsSelectedId,
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        getVendorsList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  List areaList = [];
  String isAreaSelected = "";
  String isAreaSelectedId = "";

  fatchArea(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.area,
        {
          "search": search,
        },
        ApiType.post,
      );
      areaList = resData.data;
      areaList.map((element) {
        if (element['_id'] == isAreaSelectedId) {
          isAreaSelected = element['name'];
        }
      });
    } catch (e) {
      return null;
    }
    update();
  }

  List routeList = [];
  String isRouteSelected = "";
  String isRouteSelectedId = "";

  fatchRoute(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.route,
        {
          "areaId": isAreaSelectedId,
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        routeList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  List vendorOrdersList = [];
  String isVendorSelected = "";
  String isVendorSelectedId = "";

  fatchVendorOrders() async {
    try {
      var resData = await apis.call(
        apiMethods.vendorOrders,
        {
          "orderType": isBusinessSelectedId,
          "routeId": isRouteSelected,
          "status": "pending",
          "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        vendorOrdersList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  addToSelectedList(item) {
    if (item != null) {
      var index = selectedOrderTrueList.indexOf(item);
      if (index == -1) {
        selectedOrderTrueList.add(item);
      }
      _autoSelector();
    }
  }

  removeToSelectedList(item) {
    if (item != null) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Remove',
            style: AppCss.h1,
          ),
          content: Text(
            'Do you remove this location?',
            style: AppCss.h3,
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                selectedOrderTrueList.remove(item);
                _autoSelector();
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  _autoSelector() {
    for (int i = 0; i < vendorOrdersList.length; i++) {
      int finder = 0;
      for (int j = 0; j < selectedOrderTrueList.length; j++) {
        if (vendorOrdersList[i]['_id'] == selectedOrderTrueList[j]['_id']) {
          vendorOrdersList[i]['selected'] = true;
          finder++;
        }
      }
      if (finder == 0) {
        vendorOrdersList[i]['selected'] = false;
      }
    }
    update();
  }

  List getB2CVendorsList = [];
  String isB2CVendorsSelected = "";
  String isB2CVendorsSelectedId = "";

  fatchB2CVendor(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.getVendorInB2C,
        {
          "businessCategoryId": isBusinessSelectedId,
          "_id": isB2CVendorsSelectedId,
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        getB2CVendorsList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  onB2CVendorsSelected(String name, String id) async {
    isB2CVendorsSelected = name;
    isb2cRouteSelectedId = "";
    fatchB2CRoute("");
    if (isBusinessSelected != "") {
      isB2CVendorsSelectedId = id;
      Get.back();
      onOpenOrder();
    } else {
      Get.snackbar(
        "Error",
        "Please select business categories ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
    update();
  }

  List b2cRouteList = [];
  String isb2cRouteSelected = "";
  String isb2cRouteSelectedId = "";

  fatchB2CRoute(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.b2bRoute,
        {
          "vendorId": isB2CVendorsSelected,
          "search": search,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        b2cRouteList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  onB2CRouteSelected(String name, String id) async {
    isb2cRouteSelected = name;
    isb2cRouteSelectedId = id;
    if (isb2cRouteSelectedId != "" && isB2CVendorsSelected != "") {
      Get.back();
      onB2COpen();
    } else {
      Get.snackbar(
        "Error",
        "Please try again ?",
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      Get.back();
    }
    update();
  }

  dynamic vendorB2COrdersList;

  fatchB2CVendorOrders() async {
    try {
      var resData = await apis.call(
        apiMethods.getVendorB2COrders,
        {
          "businessCategoryId": isBusinessSelectedId,
          "routeId": isb2cRouteSelected,
          "vendorId": isB2CVendorsSelected,
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        vendorB2COrdersList = resData.data;
      }
    } catch (e) {
      return null;
    }
    update();
  }

  List selectedB2COrderTrueList = [];

  addB2CToSelectedList(item) {
    if (item != null) {
      var index = selectedB2COrderTrueList.indexOf(item);
      if (index == -1) {
        selectedB2COrderTrueList.add(item);
      }
      _autoB2CSelector();
    }
  }

  removeB2CToSelectedList(item) {
    if (item != null) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Remove',
            style: AppCss.h1,
          ),
          content: Text(
            'Do you remove this location?',
            style: AppCss.h3,
          ),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                selectedB2COrderTrueList.remove(item);
                _autoB2CSelector();
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  _autoB2CSelector() {
    for (int i = 0; i < vendorB2COrdersList.length; i++) {
      int finder = 0;
      for (int j = 0; j < selectedB2COrderTrueList.length; j++) {
        if (vendorB2COrdersList[i]['_id'] == selectedB2COrderTrueList[j]['_id']) {
          vendorB2COrdersList[i]['selected'] = true;
          finder++;
        }
      }
      if (finder == 0) {
        vendorB2COrdersList[i]['selected'] = false;
      }
    }
    update();
  }
}
