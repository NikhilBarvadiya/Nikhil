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
          title: const Text(
            "Selected Order Location",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
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
                                addressHeder: e["addressId"]["name"],
                                personName: e["addressId"]["person"] + "\t\t\t(${e["addressId"]["mobile"]})",
                                vendorName: e["vendorOrderId"]["vendorId"]["name"],
                                address: e["addressId"]["address"],
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
              commonButton(
                onTap: () {},
                text: "Procceds",
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
