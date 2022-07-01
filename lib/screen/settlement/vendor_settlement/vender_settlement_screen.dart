// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/vender_settlement_controller.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/vendor_widgets/return_order_widgets.dart';
import 'package:get/get.dart';

class VendorSettlementScreen extends StatelessWidget {
  VendorSettlementController vendorSettlementController = Get.put(VendorSettlementController());
  VendorSettlementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSettlementController>(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < vendorSettlementController.selectedOrder.length; i++)
                  GestureDetector(
                    onTap: () => vendorSettlementController.onChange(i),
                    child: AnimatedContainer(
                      height: 45,
                      width: Get.width * 0.45,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          color: vendorSettlementController.selectedOrder[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                          width: 1,
                        ),
                        color: vendorSettlementController.selectedOrder[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                      ),
                      child: Text(
                        vendorSettlementController.selectedOrder[i]["selectedOrder"],
                        style: AppCss.h1.copyWith(
                          color: vendorSettlementController.selectedOrder[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            // if(vendorSettlementController.selectedOrder[0]["isActive"])
            const Expanded(child: ReturnOrderWdgets()),
            // if(vendorSettlementController.selectedOrder[1]["isActive"])
            //   const Expanded(child: CodOrderWidgets())
          ],
        ),
      ),
    );
  }
}
