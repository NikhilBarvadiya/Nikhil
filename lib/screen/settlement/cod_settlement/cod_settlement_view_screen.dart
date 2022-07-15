// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller_view.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/cod_widgets/by_drivers_widgets.dart';
import 'package:fw_manager/core/widgets/cod_widgets/by_vendor_widgets.dart';
import 'package:get/get.dart';

class CodSettlementViewScreen extends StatefulWidget {
  const CodSettlementViewScreen({Key? key}) : super(key: key);

  @override
  State<CodSettlementViewScreen> createState() => _CodSettlementViewScreenState();
}

class _CodSettlementViewScreenState extends State<CodSettlementViewScreen> {
  CodSettlementViewController codSettlementViewController = Get.put(CodSettlementViewController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementViewController>(
      builder: (_) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: codSettlementViewController.personNameSelect != false || codSettlementViewController.driverNameSelect != false ? 0 : 10),
            child: Column(
              children: [
                if (codSettlementViewController.personNameSelect != true && codSettlementViewController.driverNameSelect != true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < codSettlementViewController.codList.length; i++)
                        GestureDetector(
                          onTap: () {
                            codSettlementViewController.onChange(i);
                            codSettlementViewController.onDriverApiCalling();
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
                                color: codSettlementViewController.codList[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                                width: 1,
                              ),
                              color: codSettlementViewController.codList[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                            ),
                            child: Text(
                              codSettlementViewController.codList[i]["cod"],
                              style: AppCss.h1.copyWith(
                                color: codSettlementViewController.codList[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ).paddingOnly(bottom: 15),
                if (codSettlementViewController.codList[0]["isActive"]) const Expanded(child: ByVendorWidgets()),
                if (codSettlementViewController.codList[1]["isActive"]) const Expanded(child: ByDriversWidgets()),
              ],
            ),
          ),
          if (codSettlementViewController.personNameSelect != true && codSettlementViewController.codList[0]["isActive"] && codSettlementViewController.vendorNameList.isNotEmpty)
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
                          "₹" + num.parse(codSettlementViewController.vendorNameList[0]["totalCash"].toString()).abs().round().toString(),
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
          if (codSettlementViewController.driverNameSelect != true && codSettlementViewController.codList[1]["isActive"] && codSettlementViewController.driverNameList.isNotEmpty)
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
                          "₹" + num.parse(codSettlementViewController.driverNameList[0]["totalCash"].toString()).abs().round().toString(),
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

          // if (codSettlementViewController.personNameSelect != true &&
          //     codSettlementViewController.codList[0]["isActive"] &&
          //     codSettlementViewController.vendorList.isNotEmpty)
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
          //                 num.parse(codSettlementViewController.vendorList[0]["collectedAmount"].toString()).abs().toString(),
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
          // if (codSettlementViewController.personNameSelect != true &&
          //     codSettlementViewController.codList[1]["isActive"] &&
          //     codSettlementViewController.driversList != null)
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
          //                 codSettlementViewController.vendorNameList[1]["collectedAmount"],
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
