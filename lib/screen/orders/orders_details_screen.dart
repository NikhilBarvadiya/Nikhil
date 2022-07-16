// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/pickup_orders_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:fw_manager/env.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersDetailsScreen extends StatefulWidget {
  const OrdersDetailsScreen({Key? key}) : super(key: key);
  @override
  State<OrdersDetailsScreen> createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  OrdersController ordersController = Get.put(OrdersController());
  final CommonController _commonController = Get.find();
  dynamic data;

  @override
  void initState() {
    data = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return ordersController.onWillPopScope();
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              foregroundColor: Colors.white,
              backgroundColor: ordersController.isdragDrop != false ? AppController().appTheme.primary : Colors.orange,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ordersController.isdragDrop != false ? data["orderNo"] ?? "Orders Details" : "Drag & drop"),
                  if (ordersController.isdragDrop != false)
                    Text(
                      data["updatedAt"] != null ? data["updatedAt"].split("T").first.toString() : "",
                      style: AppCss.h2.copyWith(fontSize: 13),
                    ),
                ],
              ),
              leading: IconButton(
                onPressed: () => ordersController.isdragDrop ? ordersController.onBack() : ordersController.onBackDrop(),
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ordersController.locationStatus != null
                        ? commonBottomSheet(
                            context: context,
                            height: MediaQuery.of(context).size.height * 0.7,
                            widget: ListView.builder(
                              reverse: true,
                              itemCount: data["locations"].length,
                              itemBuilder: (BuildContext context, index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(vertical: 0),
                                  title: Text(
                                    ordersController.locationStatus != null ? data["locations"][index]["locationStatus"]["status"].toString() : "",
                                  ),
                                );
                              },
                            ),
                          )
                        : Get.rawSnackbar(
                            title: null,
                            messageText: const Text(
                              "No status available!",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 0,
                            margin: const EdgeInsets.all(0),
                          );
                  },
                  icon: const Icon(Icons.wheelchair_pickup),
                ),
                if (!ordersController.isdragDrop)
                  MaterialButton(
                    onPressed: () async {
                      await ordersController.orderDataUpdate(data);
                    },
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                // IconButton(
                //   onPressed: () => ordersController.onMap(),
                //   icon: const Icon(FontAwesomeIcons.mapLocationDot),
                // ),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: data["locations"].length,
                        buildDefaultDragHandles: ordersController.isdragDrop ? false : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          ordersController.locationStatus = data["locations"][index]["locationStatus"];
                          return Container(
                            key: Key("$index"),
                            child: data["locations"] != null
                                ? PickupOrdersCard(
                                    header: index == 0
                                        ? data["locations"][index]["type"].toString().toUpperCase().capitalizeFirst
                                        : index == data["locations"].length - 1
                                            ? "Drop"
                                            : "Stop",
                                    // time: ordersController.locationStatus["date"] != "" ? ordersController.locationStatus["date"] : "0",
                                    shopName: data["locations"][index]["location"]["name"].toString().toUpperCase().capitalizeFirst,
                                    personName: data["locations"][index]["location"]["person"].toString() != "" ? data["locations"][index]["location"]["person"].toString().toUpperCase().capitalizeFirst : "PersonName",
                                    callIcon: Icons.call,
                                    number: data["locations"][index]["location"]["mobile"].toString().toUpperCase().capitalizeFirst,
                                    textClick: () async {
                                      String link = "tel: ${data["locations"][index]["location"]["mobile"]}";
                                      await launch(link);
                                    },
                                    itemClick: () {
                                      showItemModel(
                                        context,
                                        data["locations"][index]["package"]["itemList"],
                                      );
                                    },
                                    isRequestStatus: data["requestStatus"] == "Accepted" ? true : false,
                                    isEditable: ordersController.isdragDrop == false ? false : true,
                                    editClick: () {
                                      ordersController.openEditDialog(data);
                                    },
                                    address: data["locations"][index]["location"]["address"].toString().toUpperCase().capitalizeFirst,
                                    otp: data["locations"][index]["otp"],
                                    index: index.toInt(),
                                    note: data["locations"][index]["package"]["anyNote"] != null && data["locations"][index]["package"]["anyNote"] != '' ? "Notes: " + data["locations"][index]["package"]["anyNote"].toString().toUpperCase().capitalizeFirst.toString() : "Notes : NA",
                                    itemList: data["locations"][index]["package"]["itemList"].length.toString(),
                                    status: ordersController.locationStatus != null ? ordersController.locationStatus["status"].toString() : "Pending",
                                    accpeted: ordersController.locationStatus != null && ordersController.filters[1]["label"] == "Accepted" ? "Accepted" : "",
                                    items: ordersController.hasVendorData(data["locations"][index]["package"]["itemList"])
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (double.parse(ordersController.getTotalCashAndReceiveCash(data["locations"][index]["package"]["itemList"], "cash")) > 0)
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Cash : ",
                                                      style: AppCss.h3,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                                      margin: const EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.redAccent,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        ordersController.getTotalCashAndReceiveCash(data["locations"][index]["package"]["itemList"], "cash"),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                                      margin: const EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                        color: ordersController.getTotalCashAndReceiveCash(data["locations"][index]["package"]["itemList"], "cash") ==
                                                                ordersController.getTotalCashAndReceiveCash(
                                                                  data["locations"][index]["package"]["itemList"],
                                                                  "cashReceive",
                                                                )
                                                            ? Colors.green
                                                            : Colors.red,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        ordersController.getTotalCashAndReceiveCash(data["locations"][index]["package"]["itemList"], "cashReceive"),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ).paddingOnly(left: 10),
                                            ],
                                          )
                                        : null,
                                    imageShow: ordersController.locationStatus != null
                                        ? Wrap(
                                            children: [
                                              for (int i = 0; i < ordersController.locationStatus["images"].length; i++)
                                                Image.network(
                                                  environment["imagesbaseUrl"] + "${ordersController.locationStatus["images"][i]}",
                                                  fit: BoxFit.scaleDown,
                                                  cacheHeight: 65,
                                                  cacheWidth: 60,
                                                ).paddingOnly(left: 10, bottom: 10),
                                            ],
                                          )
                                        : null,
                                    imagetrap: () {
                                      showDialog(
                                        builder: (BuildContext context) => AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: const EdgeInsets.all(2),
                                          title: Container(
                                            decoration: const BoxDecoration(),
                                            width: MediaQuery.of(context).size.width,
                                            child: Expanded(
                                              child: Image.network(
                                                environment["imagesbaseUrl"] + "${ordersController.locationStatus["images"][index]}",
                                              ),
                                            ),
                                          ),
                                        ),
                                        context: context,
                                      );
                                    },
                                  )
                                : null,
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) => ordersController.onRecord(oldIndex, newIndex, data),
                      ),
                    ),
                  ],
                ).paddingOnly(top: 5),
                if (ordersController.isLoading)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white.withOpacity(.8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            )),
      ),
    );
  }

  showItemModel(context, data) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 80 / 100,
          margin: EdgeInsets.only(top: _commonController.statusBarHeight),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            child: SearchableListView(
              isLive: false,
              isOnSearch: false,
              fetchApi: (search) async {},
              itemList: data,
              bindText: 'name',
              bindValue: '_id',
              labelText: 'Item',
              hintText: 'Please Select Item',
              onSelect: (val, text) {},
            ),
          ),
        );
      },
    );
  }
}
