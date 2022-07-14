// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_widgets/pickup_orders_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersDetailsScreen extends StatelessWidget {
  OrdersController ordersController = Get.put(OrdersController());
  final CommonController _commonController = Get.find();

  OrdersDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    return GetBuilder<OrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return ordersController.isSlider;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            foregroundColor: Colors.white,
            title: Text(ordersController.isdragDrop ? data["orderNo"] : "Drag and Drop on"),
            leading: IconButton(
              onPressed: () => ordersController.onBack(),
              icon: const Icon(Icons.arrow_back),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () => ordersController.onMap(),
            //     icon: const Icon(FontAwesomeIcons.mapLocationDot),
            //   ),
            // ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: data["locations"].length,
                  buildDefaultDragHandles: ordersController.isdragDrop ? false : true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Stack(
                      key: Key("$index"),
                      children: [
                        PickupOrdersCard(
                          header: data["locations"][index]["type"].toString().toUpperCase().capitalizeFirst,
                          // time: ordersController.orderList[index]["time"],
                          shopName: data["locations"][index]["location"]["name"].toString().toUpperCase().capitalizeFirst,
                          personName: data["locations"][index]["location"]["person"].toString().toUpperCase().capitalizeFirst,
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
                          editClick: () {
                            ordersController.openEditDialog();
                          },
                          address: data["locations"][index]["location"]["address"].toString().toUpperCase().capitalizeFirst,
                          otp: data["locations"][index]["otp"],
                          note: "Notes: " + data["locations"][index]["package"]["anyNote"].toString().toUpperCase().capitalizeFirst.toString(),
                          itemList: data["locations"][index]["package"]["itemList"].length.toString(),
                          // status: ordersController.orderList[index]["status"],
                          amount: "₹" + num.parse(data["driverAmount"].toString()).abs().round().toString(),
                          amount1: "₹" + num.parse(data["adminAmount"].toString()).abs().round().toString(),
                          image: imageAssets.logo,
                          imagetrap: () {
                            showDialog(
                              builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(2),
                                title: Container(
                                  decoration: const BoxDecoration(),
                                  width: MediaQuery.of(context).size.width,
                                  child: Expanded(
                                    child: Image.asset(
                                      imageAssets.logo,
                                    ),
                                  ),
                                ),
                              ),
                              context: context,
                            );
                          },
                          stopList: [
                            ...ordersController.selectedOrderList[0]["locations"].map((e) {
                              return e["location"]["name"].toString().toUpperCase().capitalizeFirst;
                            }),
                          ],
                          shopNameList: [
                            ...ordersController.selectedOrderList[0]["locations"].map((e) {
                              return e["location"]["flatFloorBuilding"].toString().toUpperCase().capitalizeFirst;
                            }),
                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            data["customerId"]["updatedAt"].split("T").first.toString(),
                            style: AppCss.h2.copyWith(fontSize: 13),
                          ).paddingOnly(right: 10),
                        ),
                      ],
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) => ordersController.onRecord(oldIndex, newIndex),
                ),
              ),
            ],
          ).paddingOnly(top: 5),
        ),
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
          height: MediaQuery.of(context).size.height * 50 / 100,
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
