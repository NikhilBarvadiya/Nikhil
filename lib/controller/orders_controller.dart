import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fw_manager/common/config.dart';
import 'package:fw_manager/controller/home_controller.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/configuration/app_routes.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/model/api_data_class.dart';
import 'package:fw_manager/networking/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersController extends GetxController {
  String selectedFilter = "Pending";
  TextEditingController txtSearchController = TextEditingController();
  HomeController homeController = Get.put(HomeController());
  bool isdragDrop = true;
  bool ordersFilter = true;
  bool start = true;
  bool findingRoute = true;
  bool isBounded = false;
  bool isContainsKey = false;
  bool isLoading = false;
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
  dynamic selectedOrders = [];
  dynamic orderDetailsList = [];

  @override
  void onInit() {
    isdragDrop = true;
    onOrdersApiCalling("");
    fatchbusinessCategories();
    super.onInit();
  }

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
      for (var element in markers) {
        if (element.markerId == const MarkerId('pickup')) {
          setLocation(element.position);
        }
      }
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
      for (var point in result.points) {
        _polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
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

  onRecord(int oldIndex, int newIndex, dynamic data) {
    var locations = data["locations"];
    if (oldIndex == 0) {
      Get.rawSnackbar(
        title: null,
        messageText: const Text(
          "pickup point cannot be changed!",
          style: TextStyle(color: Colors.black),
        ),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(0),
        backgroundColor: Colors.amber,
      );
    } else {
      Get.defaultDialog(
        radius: 4,
        barrierDismissible: false,
        title: "",
        content: const Text(
          "Do you really want to re-arrange the location?",
          textAlign: TextAlign.center,
        ),
        confirm: TextButton(
          onPressed: () async {
            if (newIndex == 0) {
              newIndex = 1;
            }
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = locations.removeAt(oldIndex);
            locations.insert(newIndex, item);
            data["locations"] = locations;
            update();
            Get.back();
          },
          child: const Text("Yes"),
        ),
        cancel: TextButton(
          onPressed: () {
            final item = locations.removeAt(newIndex);
            locations.insert(oldIndex, item);
            data["locations"] = locations;
            update();
            Get.back();
          },
          child: const Text("No"),
        ),
      );
    }
    update();
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
        selectedOrders = [];
        onOrdersApiCalling("");
        update();
      },
    );
  }

  onDetailsTap(dynamic data) {
    selectedOrders = data;
    Get.toNamed(AppRoutes.ordersDetailsScreen, arguments: data)!.then((value) {
      onOrdersApiCalling("");
    });
    update();
  }

  onMap() {
    Get.toNamed(AppRoutes.ordersLocationMap);
    update();
  }

  onBack() {
    if (isdragDrop == true) {
      Get.back();
      update();
    }
  }

  onBackDrop() {
    if (isdragDrop == false) {
      isdragDrop = true;
    }
    update();
  }

  onWillPopScope() {
    onBack();
    onBackDrop();
  }

  onWillPopScopeNewOrders() {
    isNewAdd ? onOrderBack() : onRepair();
  }

  openEditDialog(dynamic data, index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit orders details'),
        actions: [
          // ListTile(
          //   title: const Text("Edit"),
          //   onTap: () {
          //     Get.back();
          //     Get.toNamed(AppRoutes.editOrdersScreen, arguments: data);
          //     update();
          //   },
          // ),
          ListTile(
            title: const Text("Drag & drop"),
            onTap: () {
              isdragDrop = false;
              update();
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Send to driver"),
            onTap: () async {
              String link = "https://wa.me/${data["driver"]["driverPhone"]}";
              // ignore: deprecated_member_use
              await launch(link);
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Add New"),
            onTap: () async {
              Get.toNamed(AppRoutes.newOrdersScreen);
              update();
            },
          ),
          ListTile(
            title: const Text("Delete"),
            onTap: () {
              Get.back();
              Get.defaultDialog(
                radius: 4,
                title: "",
                content: const Text(
                  "Do you really want to delete this location?",
                  textAlign: TextAlign.center,
                ),
                confirm: TextButton(
                  onPressed: () async {
                    Get.back();
                    await shiftVendorOrderLocationsToPending(selectedOrders["_id"], index);
                    update();
                  },
                  child: const Text("Yes"),
                ),
                cancel: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("No"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  fatchOrders(type, search) async {
    try {
      isLoading = true;
      update();
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
      isLoading = false;
      update();
      if (resData.isSuccess == true && resData.data != 0) {
        selectedOrderList = resData.data["orders"]["docs"];
      }
    } catch (e) {
      log("Error orders not faound");
    } finally {
      isLoading = false;
      update();
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

  orderDataUpdate(orderDetails) async {
    try {
      isLoading = true;
      update();
      orderDetailsList = orderDetails;
      var request = {"selectedOrder": orderDetails};
      APIDataClass response = await apis.call(
        apiMethods.orderDataUpdate,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        orderDetails = response.data;
        update();
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  shiftVendorOrderLocationsToPending(vendorOrderStatusIds, index) async {
    try {
      isLoading = true;
      update();
      var request = {
        "vendorOrderStatusIds": vendorOrderStatusIds,
      };
      APIDataClass response = await apis.call(
        apiMethods.shiftVendorOrderLocationsToPending,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        selectedOrders["locations"].removeAt(index);
        await orderDataUpdate(selectedOrders);
        await onOrdersApiCalling("");
        update();
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  /// New Orders Controller ///
  String selectedOrder = "B2B Order";
  bool isSlider = false;
  bool isOpenTap = false;
  bool isOpenOrder = false;
  bool isNewOrder = false;
  bool isNewAdd = true;
  List selectedOrderTrueList = [];
  List selectedNewAddOrderTrueList = [];
  List businessCategories = [];
  List getVendorsList = [];
  List fetchVendorByBusinessCategoryList = [];
  List vendorOrderMergeByBusinessCategoryIdList = [];
  List getAllGlobalAddressByRouteList = [];
  List getRoutesDetailsList = [];
  List getVendorLastorderList = [];
  List addNewLocationDetailsInVendorStatusList = [];
  String isBusinessSelectedId = "";
  String isBusinessSelected = "";
  String isVendorsSelected = "";
  String isVendorsSelectedId = "";
  String isRouteSelectedId = "";
  String isRouteSelected = "";
  int locationIndex = 0;

  onClearAll() {
    Get.defaultDialog(
      radius: 4,
      barrierDismissible: false,
      title: "",
      content: const Text(
        "Do you really want to clear all the location?",
        textAlign: TextAlign.center,
      ),
      cancel: TextButton(
        onPressed: () {
          selectedOrderTrueList.clear();
          selectedNewAddOrderTrueList.clear();
          _autoSelector();
          _autoNewAddSelector();
          Get.back();
        },
        child: const Text("Yes"),
      ),
      confirm: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("No"),
      ),
    );
  }

  onOpenTap() {
    onClear();
    isOpenTap = !isOpenTap;
    update();
  }

  onCloseTap() {
    isOpenOrder = !isOpenOrder;
    update();
  }

  onNewSelectedOrders() {
    if (selectedOrderTrueList.isNotEmpty) {
      Get.toNamed(AppRoutes.newSelectedOrdersScreen);
    } else {
      Get.rawSnackbar(
        title: null,
        messageText: const Text(
          "order address not selected!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
    }
    update();
  }

  onChangeOrder(int i) {
    for (int a = 0; a < order.length; a++) {
      if (a == i) {
        order[a]["isActive"] = true;
        selectedOrder = order[a]["title"];
      } else {
        order[a]["isActive"] = false;
      }
      onClear();
    }
    fatchbusinessCategories();
    update();
  }

  onClear() {
    isBusinessSelected = "";
    isBusinessSelectedId = "";
    isVendorsSelected = "";
    isVendorsSelectedId = "";
    isRouteSelected = "";
    isRouteSelectedId = "";
    selectedOrderTrueList.clear();
    selectedNewAddOrderTrueList.clear();
    getAllGlobalAddressByRouteList.clear();
    update();
  }

  onOrderBack() {
    if (isRouteSelected != "") {
      onNewAdd();
    } else {
      if (isBusinessSelected != "" && isBusinessSelectedId != "" && isVendorsSelected != "" && isVendorsSelectedId != "") {
        onClear();
        isNewAdd = true;
        isOpenOrder = false;
        update();
      } else {
        isNewAdd = true;
        selectedOrderTrueList.clear();
        selectedNewAddOrderTrueList.clear();
        Get.back();
      }
    }
    update();
  }

  onRepair() {
    if (isBusinessSelected != "" && isBusinessSelectedId != "" && isVendorsSelected != "" && isVendorsSelectedId != "" && isRouteSelected != "") {
      onNewAdd();
    } else {
      isNewAdd = true;
    }
    update();
  }

  List order = [
    {
      "title": "B2B Orders",
      "isActive": true,
    },
    {
      "title": "B2C Orders",
      "isActive": false,
    },
  ];

  fatchbusinessCategories() async {
    try {
      var resData = await apis.call(
        apiMethods.businessCategories,
        {},
        ApiType.post,
      );
      businessCategories = resData.data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    update();
  }

  onBusinessSelected(String id, String name) async {
    isBusinessSelectedId = id;
    isBusinessSelected = name;
    isNewAdd ? await fetchVendorByBusinessCategoryId("") : await getVendors("");
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

  fetchVendorByBusinessCategoryId(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.fetchVendorByBusinessCategoryId,
        {
          "businessCategoryId": isBusinessSelectedId,
          "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        fetchVendorByBusinessCategoryList = resData.data;
      }
      update();
    } catch (e) {
      return null;
    }
    update();
  }

  getVendors(String search) async {
    try {
      var resData = await apis.call(
        apiMethods.getVendors,
        {
          "businessCategoryId": isBusinessSelectedId,
          "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
        },
        ApiType.post,
      );
      if (resData.isSuccess == true && resData.data != 0) {
        getVendorsList = resData.data;
      }
      update();
    } catch (e) {
      return null;
    }
    update();
  }

  onVendorsSelected(String name, String id) async {
    isVendorsSelected = name;
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

  onNewAdd() {
    onClear();
    selectedOrderTrueList.clear();
    selectedNewAddOrderTrueList.clear();
    isOpenOrder = false;
    isNewAdd = false;
    update();
  }

  /// Peanding Apicalling......///

  vendorOrderMergeByBusinessCategoryId() async {
    try {
      isLoading = true;
      update();
      var request = {
        "businessCategoryId": isBusinessSelectedId,
        "vendorId": isVendorsSelected,
        "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
      };
      APIDataClass response = await apis.call(
        apiMethods.vendorOrderMergeByBusinessCategoryId,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        vendorOrderMergeByBusinessCategoryIdList = response.data;
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  onOpenOrder() async {
    if (isBusinessSelected != "" && isVendorsSelected != "") {
      if (isNewAdd == false) {
        isNewOrder = true;
        await getRoutesDetails();
        if (isRouteSelected != "") {
          isOpenOrder = true;
          await getAllGlobalAddressByRoute();
        }
      } else {
        isOpenOrder = true;
        await vendorOrderMergeByBusinessCategoryId();
      }
      _autoSelector();
    } else {
      isOpenOrder = false;
    }
  }

  addToSelectedList(item) {
    if (item != null) {
      var index = selectedOrderTrueList.indexOf(item);
      if (index == -1) {
        selectedOrderTrueList.add(item);
        update();
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
    for (int i = 0; i < vendorOrderMergeByBusinessCategoryIdList.length; i++) {
      var data = selectedOrderTrueList.where((element) => element['_id'] == vendorOrderMergeByBusinessCategoryIdList[i]['_id']);
      if (data.isNotEmpty) {
        vendorOrderMergeByBusinessCategoryIdList[i]['selected'] = true;
      } else {
        vendorOrderMergeByBusinessCategoryIdList[i]['selected'] = false;
      }
      update();
    }
  }

  /// Add New ApiCalling.......///

  onRouteSelected(String id, String name) async {
    isRouteSelectedId = id;
    isRouteSelected = name;
    getAllGlobalAddressByRoute();
    if (isRouteSelectedId != "") {
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

  getRoutesDetails() async {
    try {
      isLoading = true;
      update();
      APIDataClass response = await apis.call(
        apiMethods.getRoutesDetails,
        {},
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        getRoutesDetailsList = response.data;
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  getAllGlobalAddressByRoute() async {
    try {
      isLoading = true;
      update();
      var request = {
        "routeId": isRouteSelectedId,
      };
      APIDataClass response = await apis.call(
        apiMethods.getAllGlobalAddressByRoute,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        getAllGlobalAddressByRouteList = response.data;
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  newAddToSelectedList(item) {
    if (item != null) {
      var index = selectedNewAddOrderTrueList.indexOf(item);
      if (index == -1) {
        addItem(item);
        update();
      }
      _autoNewAddSelector();
    }
  }

  newRemoveToSelectedList(item) {
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
                selectedNewAddOrderTrueList.remove(item);
                _autoNewAddSelector();
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

  _autoNewAddSelector() {
    for (int i = 0; i < getAllGlobalAddressByRouteList.length; i++) {
      var data = selectedNewAddOrderTrueList.where((element) => element['_id'] == getAllGlobalAddressByRouteList[i]['_id']);
      if (data.isNotEmpty) {
        getAllGlobalAddressByRouteList[i]['selected'] = true;
      } else {
        getAllGlobalAddressByRouteList[i]['selected'] = false;
      }
      update();
    }
  }

  onNewAddSelectedOrders() {
    if (getAllGlobalAddressByRouteList.isNotEmpty) {
      Get.toNamed(AppRoutes.newSelectedOrdersScreen);
    } else {
      Get.rawSnackbar(
        title: null,
        messageText: const Text(
          "order address not selected!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
    }
    update();
  }

  addItem(address) {
    int found = selectedNewAddOrderTrueList.where((element) => ["_id"] == address["_id"]).toList().length;
    if (found == 0) {
      selectedNewAddOrderTrueList.add({
        "_id": address["_id"],
        "name": address["name"],
        "person": address["person"],
        "flatFloorBuilding": address["flatFloorBuilding"],
        "address": address["address"],
        "areaId": address["routeId"]["areaId"]["_id"],
        "nOfPackages": "1",
        "routeId": address["routeId"],
        "mobile": address["mobile"],
        "shortNo": address["shortNo"],
      });
      getAllGlobalAddressByRouteList[getAllGlobalAddressByRouteList.indexOf(address)]["isAdded"] = true;
    } else {
      Get.rawSnackbar(
        title: null,
        messageText: const Text(
          "Already Added!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
    }
    onChangeLP();
  }

  dynamic tLocations = 0;
  dynamic tPackages = 0;

  onChangeLP() {
    tLocations = selectedNewAddOrderTrueList.length;
    tPackages = 0;
    for (var element in selectedNewAddOrderTrueList) {
      var pack = element["nOfPackages"] == "" ? 0 : element["nOfPackages"];
      tPackages = tPackages + num.parse(pack.toString());
    }
  }

  getVendorLastorder() async {
    try {
      isLoading = true;
      update();
      var request = {
        "vendorId": isVendorsSelected,
        "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
      };
      APIDataClass response = await apis.call(
        apiMethods.getVendorLastorder,
        request,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        getVendorLastorderList = response.data;
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  addNewLocationDetailsInVendorStatus() async {
    try {
      isLoading = true;
      update();
      addNewLocationDetailsInVendorStatusList = [];
      await getVendorLastorder();
      List orderData = [];
      for (var lastOrder in getVendorLastorderList) {
        for (var element in selectedNewAddOrderTrueList) {
          dynamic data = {
            "nOfPackages": element["nOfPackages"],
            "status": "running",
            "addressId": element,
            "routeId": element["routeId"]["_id"],
            "areaId": element["areaId"],
            "cash": element["cash"] != "" ? 0 : element["cash"].toString(),
            "cashReceived": element["cashReceived"] != "" ? 0 : element["cashReceived"].toString(),
            "vendorOrderId": lastOrder["_id"],
            "businessCategoryId": isBusinessSelectedId,
            "orderType": order[0]['isActive'] == true ? 'b2b' : 'b2c',
          };
          orderData.add(data);
        }
      }
      APIDataClass response = await apis.call(
        apiMethods.addNewLocationDetailsInVendorStatus,
        orderData,
        ApiType.post,
      );
      if (response.isSuccess && response.data != 0) {
        addNewLocationDetailsInVendorStatusList = response.data;
        isSlider = false;
        isOpenTap = false;
        isOpenOrder = false;
        isNewOrder = false;
        isNewAdd = true;
        isBusinessSelected = "";
        isBusinessSelectedId = "";
        isVendorsSelected = "";
        isVendorsSelectedId = "";
        isRouteSelected = "";
        isRouteSelectedId = "";
        onChangeOrder(0);
        Get.offNamed(AppRoutes.home);
        update();
      }
    } catch (e) {
      Get.rawSnackbar(
        title: null,
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        borderRadius: 0,
        margin: const EdgeInsets.all(0),
      );
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  List finalOrderLocations = [];

  onPendingProcced() async {
    dynamic itemList = [];
    for (var element in addNewLocationDetailsInVendorStatusList) {
      itemList = [];
      if (element["isAdded"] != true) {
        dynamic itemObject = {
          "name": "${element["vendorOrderId"]?["vendorId"]?["name"]}_${element["nOfPackages"]}",
          "quantity": element["nOfPackages"],
          "weight": 100,
          "weightType": 'GM',
          "vendorData": {
            "vendorId": element["vendorOrderId"]?["vendorId"]?["_id"],
            "vendorOrderId": element["vendorOrderId"]?["_id"],
            "itemId": element["_id"],
            "addressId": element["addressId"]["_id"],
            "routeId": element["routeId"],
            "cash": 0,
            "cashReceive": 0,
          }
        };
        itemList.add(itemObject);
        for (var ele in addNewLocationDetailsInVendorStatusList) {
          if (ele["addressId"] != null) {
            if (ele["addressId"]["_id"] == ele["addressId"]["_id"] && ele["_id"] != ele["_id"]) {
              dynamic boxes = ele["nOfBoxes"] != "" ? ele["nOfBoxes"] : 0;
              dynamic itemObject2 = {
                "name": "${element["vendorOrderId"]["vendorId"]["name"]}_${element["nOfPackages"] + boxes}",
                "mobile": element["vendorOrderId"]["vendorId"]["mobile"],
                "quantity": element["nOfPackages"] + boxes,
                "loose": element["nOfPackages"],
                "boxes": boxes,
                "weight": 100,
                "weightType": 'GM',
                "vendorData": {
                  "vendorId": element["vendorOrderId"]["vendorId"]["_id"],
                  "vendorOrderId": element["vendorOrderId"]["_id"],
                  "itemId": element["_id"],
                  "addressId": element["addressId"]["_id"],
                  "routeId": element["routeId"],
                  "cash": element["cash"],
                  "cashReceive": 0,
                }
              };
              ele["isAdded"] = true;
              itemList.add(itemObject2);
              itemList = itemList.where((element, i) => element["vendorData"]["itemId"] == addNewLocationDetailsInVendorStatusList[i]["vendorData"]["itemId"]);
            }
          } else {
            if (ele["name"] == element["name"] && num.parse(ele["latLong"].split(',')[0].trim()) == num.parse(element["latLong"].split(',')[0].trim()) && num.parse(ele["latLong"].split(',')[1].trim()) == num.parse(element["latLong"].split(',')[1].trim())) {
              dynamic boxes = ele["nOfBoxes"] != "" ? ele["nOfBoxes"] : 0;
              dynamic itemObject2 = {
                "name": "${ele["vendorOrderId"]["vendorId"]["name"]}_${ele["nOfPackages"] + boxes}",
                "mobile": ele["vendorOrderId"]["vendorId"]["mobile"],
                "quantity": ele["nOfPackages"] + boxes,
                "loose": ele["nOfPackages"],
                "boxes": boxes,
                "weight": 100,
                "weightType": 'GM',
                "vendorData": {
                  "vendorId": ele["vendorOrderId"]["vendorId"]["_id"],
                  "vendorOrderId": ele["vendorOrderId"]["_id"],
                  "itemId": ele["_id"],
                  "addressId": ele["addressId"]["_id"],
                  "routeId": ele["routeId"],
                  "cash": ele["cash"],
                  "cashReceive": 0,
                }
              };
              ele["isAdded"] = true;
              itemList.push(itemObject2);
              itemList = itemList.where((element, i) => element["vendorData"]["itemId"] == addNewLocationDetailsInVendorStatusList[i]["vendorData"]["itemId"]);
            }
          }
        }
        dynamic location = {
          "package": {
            "contentList": [],
            "images": [],
            "laborCharges": 0,
            "laborQty": 0,
            "laborType": 'hr',
            "isFragile": false,
            "fragileCharges": 0,
            "isInsurance": false,
            "totalPackageCharges": 0,
            "insuranceCharges": 0,
            "payAtPickup": null,
            "invoice": "",
            "signature": null,
            "invoiceSign": null,
            "itemTotalWeight": itemList.map((element) => element["weight"]).reduce((prev, curr) => prev + curr),
            "total": 0,
            "anyNote": element["anyNote"] != "" ? element["anyNote"] : "Location by admin",
            "itemList": itemList,
          },
          "type": selectedNewAddOrderTrueList.indexOf(element) == selectedNewAddOrderTrueList.length - 1 ? 'Drop' : 'Stop',
          "instructionAudio": "",
          "otp": "1234",
          "isReached": false,
          "reachedTime": null,
          "packageType": null,
          "location": element["addressId"] != null
              ? {
                  "name": element["addressId"]["name"],
                  "address": element["addressId"]["address"],
                  "lat": element["addressId"]["lat"],
                  "lng": element["addressId"]["lng"],
                  "flatFloorBuilding": element["addressId"]["flatFloorBuilding"],
                  "person": element["addressId"]["person"],
                  "mobile": element["addressId"]["mobile"],
                }
              : {
                  "name": element["name"],
                  "address": element["address"],
                  "flatFloorBuilding": '',
                  "person": '',
                  "lat": num.parse(element["latLong"].split(',')[0].trim()),
                  "lng": num.parse(element["latLong"].split(',')[1].trim()),
                  "mobile": element["mobile"],
                },
          "dropPackage": [],
        };
        finalOrderLocations.add(location);
      }
    }
    for (int i = 0; i < selectedOrders["locations"].length; i++) {
      if (i == 0) {
        itemList.forEach((item) {
          selectedOrders["locations"][i]["package"]["itemList"].insert(
            selectedOrders["locations"][i]["package"]["itemList"].length,
            item,
          );
        });
        if (i == locationIndex && selectedOrders["locations"][i]["type"] == "Drop") {
          selectedOrders["locations"][i]["type"] = "Stop";
        }
      }
    }
    for (int index = 0; index < finalOrderLocations.length; index++) {
      selectedOrders["locations"].insert(
        locationIndex + 1,
        finalOrderLocations[finalOrderLocations.length - 1 - index],
      );
    }
  }

  onSubmit() async {
    try {
      var result = await orderDataUpdate(selectedOrders);
      update();
      if (result.IsSuccess) {
        update();
      }
    } catch (err) {
      return err;
    }
  }

  vendorOrderUpdate() async {
    try {
      final MultiOrdersController multiOrdersController = Get.find();
      var result = await multiOrdersController.saveOrders();
      multiOrdersController.update();
      if (result.IsSuccess) {
        Get.snackbar(
          'Locations Added Successful',
          'success',
        );
      }
    } catch (err) {
      return err;
    }
  }

  resetAll() {
    Get.offNamed(AppRoutes.home);
  }

  placeInOrder() async {
    try {
      await addNewLocationDetailsInVendorStatus();
      onPendingProcced();
      print(selectedOrders['locations'].length);
      // await onSubmit();
      resetAll();
      update();
    } catch (err) {
      return err;
    }
  }

  placeInOrderPending() async {
    try {
      isSlider = false;
      isOpenTap = false;
      isOpenOrder = false;
      isNewOrder = false;
      isNewAdd = true;
      isBusinessSelected = "";
      isBusinessSelectedId = "";
      isVendorsSelected = "";
      isVendorsSelectedId = "";
      isRouteSelected = "";
      isRouteSelectedId = "";
      onChangeOrder(0);
      Get.offNamed(AppRoutes.home);
      onPendingProcced();
      await onSubmit();
      resetAll();
      update();
    } catch (err) {
      return err;
    }
  }
}
