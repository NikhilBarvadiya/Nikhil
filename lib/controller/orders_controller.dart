import 'package:flutter/material.dart';import 'package:get/get.dart';class OrdersController extends GetxController {  String selectedFilter = "Pending";  List filters = [    {      "icon": Icons.pending_actions,      "label": "Pending",      "isActive": true,    },    {      "icon": Icons.running_with_errors,      "label": "Running",      "isActive": false,    },    {      "icon": Icons.fact_check_outlined,      "label": "Complete",      "isActive": false,    },    {      "icon": Icons.cancel,      "label": "Cancelled",      "isActive": false,    }  ];  List<dynamic> selectedOrders = [    for (int i = 1; i < 11; i++)      {        "orderNo": "#ORD-00507$i",        "orderDateTime": "Jun 10, 2022, 10:19:52 AM",        "customerName": "Fastwhistle : ",        "customerNumber": " +91 6357017016",        "pickupStop": "5 Stops",        "amount": "₹253",        "status": " Pending",        "requestedVehicle": "CHAUHAN RAHUL KANAHAIYA",        "_id": i,      },  ];  onChange(int i) {    for (int a = 0; a < filters.length; a++) {      if (a == i) {        filters[a]["isActive"] = true;        selectedFilter = filters[a]["label"];      } else {        filters[a]["isActive"] = false;      }    }    update();  }  onRefresh() {    return Future.delayed(      const Duration(seconds: 1),()=>selectedOrders.addAll(selectedOrders[0]),    );  }}