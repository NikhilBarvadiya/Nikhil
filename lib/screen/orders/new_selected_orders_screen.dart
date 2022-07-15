// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/new_orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/new_order_card.dart';
import 'package:get/get.dart';

class NewSelectedOrdersScreen extends StatelessWidget {
  NewOrderController newOrderController = Get.put(NewOrderController());
  NewSelectedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderController>(
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
                    ...newOrderController.selectedOrderTrueList.map(
                      (e) {
                        int index = newOrderController.selectedOrderTrueList.indexOf(e);
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
                                addressHeder: e["shopName"],
                                personName: e["personName"] + "\t\t\t(${e["number"]})",
                                vendorName: e["Vendor"],
                                address: e["address"],
                                onTap: () {
                                  newOrderController.removeToSelectedList(e);
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
