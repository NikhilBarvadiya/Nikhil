// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/cod_widgets/by_drivers_widgets.dart';
import 'package:fw_manager/core/widgets/cod_widgets/by_vendor_widgets.dart';
import 'package:get/get.dart';

class CodSettlementScreen extends StatefulWidget {
  const CodSettlementScreen({Key? key}) : super(key: key);

  @override
  State<CodSettlementScreen> createState() => _CodSettlementScreenState();
}

class _CodSettlementScreenState extends State<CodSettlementScreen> {
  CodSettlementController codSettlementController = Get.put(CodSettlementController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementController>(
      builder: (_) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: codSettlementController.personNameSelect != false || codSettlementController.driverNameSelect != false ? 0 : 10),
            child: Column(
              children: [
                if (codSettlementController.personNameSelect != true && codSettlementController.driverNameSelect != true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < codSettlementController.codList.length; i++)
                        GestureDetector(
                          onTap: () {
                            codSettlementController.onChange(i);
                            codSettlementController.onDriverApiCalling();
                          },
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
                                color: codSettlementController.codList[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                                width: 1,
                              ),
                              color: codSettlementController.codList[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                            ),
                            child: Text(
                              codSettlementController.codList[i]["cod"],
                              style: AppCss.h1.copyWith(
                                color: codSettlementController.codList[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ).paddingOnly(bottom: 15),
                if (codSettlementController.codList[0]["isActive"]) const Expanded(child: ByVendorWidgets()),
                if (codSettlementController.codList[1]["isActive"]) const Expanded(child: ByDriversWidgets()),
              ],
            ),
          ),
          if (codSettlementController.personNameSelect != true && codSettlementController.codList[0]["isActive"] && codSettlementController.vendorNameList.isNotEmpty)
            Column(
              children: [
                const Spacer(),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "₹" + num.parse(codSettlementController.vendorNameList[0]["totalCash"].toString()).abs().round().toString(),
                          style: AppCss.h1.copyWith(
                            color: Colors.black,
                          ),
                        ).paddingOnly(left: 5, bottom: 3),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Total Collected Amount",
                          style: AppCss.h1.copyWith(color: Colors.black, fontSize: 15),
                        ).paddingOnly(left: 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (codSettlementController.driverNameSelect != true && codSettlementController.codList[1]["isActive"] && codSettlementController.driverNameList.isNotEmpty)
            Column(
              children: [
                const Spacer(),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "₹" + num.parse(codSettlementController.driverNameList[0]["totalCash"].toString()).abs().round().toString(),
                          style: AppCss.h1.copyWith(
                            color: Colors.black,
                          ),
                        ).paddingOnly(left: 5, bottom: 3),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Total Collected Amount",
                          style: AppCss.h1.copyWith(color: Colors.black, fontSize: 15),
                        ).paddingOnly(left: 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          // if (codSettlementController.personNameSelect != true &&
          //     codSettlementController.codList[0]["isActive"] &&
          //     codSettlementController.vendorList.isNotEmpty)
          //   Column(
          //     children: [
          //       const Spacer(),
          //       Container(
          //         width: double.infinity,
          //         color: Theme.of(context).primaryColor,
          //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //         child: Column(
          //           children: [
          //             Container(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 num.parse(codSettlementController.vendorList[0]["collectedAmount"].toString()).abs().toString(),
          //                 style: AppCss.h1.copyWith(
          //                   color: Colors.black,
          //                 ),
          //               ).paddingOnly(left: 5, bottom: 3),
          //             ),
          //             Container(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 "Total Payable Amount",
          //                 style: AppCss.h1.copyWith(color: Colors.black, fontSize: 15),
          //               ).paddingOnly(left: 5),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // if (codSettlementController.personNameSelect != true &&
          //     codSettlementController.codList[1]["isActive"] &&
          //     codSettlementController.driversList != null)
          //   Column(
          //     children: [
          //       const Spacer(),
          //       Container(
          //         width: double.infinity,
          //         color: Theme.of(context).primaryColor,
          //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //         child: Column(
          //           children: [
          //             Container(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 codSettlementController.vendorNameList[1]["collectedAmount"],
          //                 style: AppCss.h1.copyWith(
          //                   color: Colors.black,
          //                 ),
          //               ).paddingOnly(left: 5, bottom: 3),
          //             ),
          //             Container(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 "Total Payable Amount",
          //                 style: AppCss.h1.copyWith(color: Colors.black, fontSize: 15),
          //               ).paddingOnly(left: 5),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
