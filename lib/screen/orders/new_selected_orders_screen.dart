// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/new_order_card.dart';
import 'package:get/get.dart';

class NewSelectedOrdersScreen extends StatelessWidget {
  OrdersController ordersController = Get.put(OrdersController());
  NewSelectedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          backgroundColor: ordersController.isNewAdd ? Theme.of(context).primaryColor : Colors.orange,
          title: const Text(
            "Selected Order Location",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
          ),
          actions: [
            MaterialButton(
              onPressed: () => ordersController.onClearAll(),
              child: const Text(
                "CLEAR ALL",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              if (ordersController.selectedOrderTrueList.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: [
                      ...ordersController.selectedOrderTrueList.toSet().toList().map(
                        (e) {
                          int index = ordersController.selectedOrderTrueList.indexOf(e);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "${index + 1}",
                                  style: AppCss.h3.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: NewOrderCard(
                                  addressHeder: ordersController.order[0]["isActive"] ? e["addressId"]["name"].toString() : e["name"].toString(),
                                  personName: ordersController.order[0]["isActive"] ? e["addressId"]["person"].toString() + "\t\t\t(${e["addressId"]["mobile"]})" : "(${e["mobile"]})",
                                  vendorName: e["vendorOrderId"]["vendorId"]["name"].toString(),
                                  address: ordersController.order[0]["isActive"] ? e["addressId"]["address"].toString() : e["address"].toString(),
                                  onTap: () {
                                    ordersController.removeToSelectedList(e);
                                  },
                                  deleteIcon: Icons.close,
                                  deleteIconColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              if (ordersController.selectedOrderTrueList.isNotEmpty)
                commonButton(
                  onTap: () {},
                  text: "Proceed",
                  height: 50.0,
                ),
              if (ordersController.selectedNewAddOrderTrueList.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: [
                      ...ordersController.selectedNewAddOrderTrueList.toSet().toList().map(
                        (e) {
                          int index = ordersController.selectedNewAddOrderTrueList.indexOf(e);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "${index + 1}",
                                  style: AppCss.h3.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: NewOrderCard(
                                  addressHeder: ordersController.isNewAdd ? e["addressId"]["name"].toString() : e["name"].toString(),
                                  personName: ordersController.isNewAdd ? e["addressId"]["person"].toString() + "\t\t\t(${e["addressId"]["mobile"]})" : e["person"].toString() + "\t\t\t(${e["mobile"]})",
                                  vendorName: ordersController.isNewAdd ? e["vendorOrderId"]["vendorId"]["name"].toString() : "ShortNo : " + e["shortNo"].toString(),
                                  address: ordersController.isNewAdd ? e["addressId"]["address"].toString() : e["address"].toString(),
                                  onTap: () {
                                    ordersController.newRemoveToSelectedList(e);
                                  },
                                  deleteIcon: Icons.close,
                                  deleteIconColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              if (ordersController.selectedNewAddOrderTrueList.isNotEmpty)
                commonButton(
                  onTap: () => ordersController.onPendingProcced(),
                  text: "Proceed",
                  height: 50.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
