import 'dart:async';import 'package:get/get.dart';import 'package:google_maps_flutter/google_maps_flutter.dart';class MapViewController extends GetxController{  bool isPolyline =false;  Completer<GoogleMapController> mapController = Completer();  dynamic locationsList;  void onMapCreated(GoogleMapController controller) {    if (!mapController.isCompleted) {      mapController.complete(controller);    }    update();  }}