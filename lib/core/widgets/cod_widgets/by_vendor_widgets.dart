// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller_view.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_data_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendors_card.dart';
import 'package:get/get.dart';

class ByVendorWidgets extends StatefulWidget {
  const ByVendorWidgets({Key? key}) : super(key: key);
  @override
  State<ByVendorWidgets> createState() => _ByVendorWidgetsState();
}

class _ByVendorWidgetsState extends State<ByVendorWidgets> {
  CodSettlementViewController codSettlementViewController = Get.put(CodSettlementViewController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementViewController>(
      builder: (_) => Column(
        children: [
          // if (codSettlementViewController.personNameSelect != true)
          //   Row(
          //     children: [
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             commonBottomSheet(
          //               context: context,
          //               widget: SearchableListView(
          //                 isLive: false,
          //                 isOnSearch: true,
          //                 itemList: const [],
          //                 bindText: 'name',
          //                 bindValue: '_id',
          //                 labelText: 'Vendor name',
          //                 hintText: 'Please Select',
          //                 onSelect: (val, text) {
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //             );
          //           },
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: Colors.grey[200],
          //               border: Border(
          //                 bottom: BorderSide(
          //                   color: Theme.of(context).primaryColor,
          //                   width: 1.0,
          //                 ),
          //               ),
          //             ),
          //             padding: const EdgeInsets.all(10),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 const Expanded(
          //                   child: Text('Search vendor'),
          //                 ),
          //                 Icon(
          //                   Icons.arrow_drop_down,
          //                   color: Theme.of(context).primaryColor,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 15),
          //       GestureDetector(
          //         onTap: () => codSettlementViewController.onDatePickerVendor(),
          //         child: Card(
          //           elevation: 1,
          //           color: Theme.of(context).primaryColor,
          //           child: AnimatedContainer(
          //             duration: const Duration(milliseconds: 100),
          //             alignment: Alignment.center,
          //             child: Container(
          //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //               child: const Icon(
          //                 Icons.filter_alt_outlined,
          //                 size: 25,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ).paddingOnly(bottom: codSettlementViewController.vendorFilter != false ? 10 : 25),
          // if (codSettlementViewController.startDateVendor != "" && codSettlementViewController.endDateVendor != "" && codSettlementViewController.vendorFilter != false && codSettlementViewController.personNameSelect != true)
          //   Container(
          //     padding: const EdgeInsets.only(bottom: 25),
          //     width: double.infinity,
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       "${codSettlementViewController.startDateVendor.split("T").first} " "- ${codSettlementViewController.endDateVendor.split("T").first}",
          //       style: AppCss.h3,
          //     ),
          //   ),
          if (codSettlementViewController.personNameSelect != false)
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  codSettlementViewController.onBackButton();
                },
                icon: const Icon(Icons.arrow_back_ios_sharp, size: 13),
                label: const Text("Back"),
              ),
            ),
          if (codSettlementViewController.personNameSelect != true && codSettlementViewController.vendorNameList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vendor Name',
                  style: AppCss.h3.copyWith(
                    color: AppController().appTheme.primary1,
                  ),
                ),
                Text(
                  'Collected Amount',
                  style: AppCss.h3.copyWith(
                    color: AppController().appTheme.primary1,
                  ),
                ),
              ],
            ).paddingOnly(bottom: 5),
          if (codSettlementViewController.personNameSelect != true && codSettlementViewController.vendorNameList.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < codSettlementViewController.vendorNameList[0]["data"].length; i++)
                    CommonCodVendorsCard(
                      personName: codSettlementViewController.vendorNameList[0]["data"][i]["name"].toString(),
                      collectedAmount: "₹ " + num.parse(codSettlementViewController.vendorNameList[0]["data"][i]["mainBalance"].toString()).abs().round().toString(),
                      onTap: () => codSettlementViewController.onPersonNameClick(i),
                    ),
                ],
              ),
            ),
          if (codSettlementViewController.personNameSelect != false && codSettlementViewController.vendorList.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < codSettlementViewController.vendorList.length; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: i == (codSettlementViewController.vendorList.length - 1) ? 20 : 3),
                            child: CommonCodVendorDataCard(
                              onTap: () {
                                codSettlementViewController.addToSelectedVendorList(codSettlementViewController.vendorList[i]);
                              },
                              cardColors: codSettlementViewController.vendorList[i]["selected"] == true ? Colors.green[100] : Colors.white,
                              orderNo: codSettlementViewController.vendorList[i]["orderDetails"]["orderNo"],
                              name: codSettlementViewController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"] != null ? codSettlementViewController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"].toString().toCapitalized() : codSettlementViewController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["address"].toString().toCapitalized(),
                              personName: "(${codSettlementViewController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"] != null ? codSettlementViewController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"]["person"].toString().toCapitalized() : '-'})",
                              addressDate: getFormattedDate(codSettlementViewController.vendorList[i]["createdAt"].toString()),
                              status: codSettlementViewController.vendorList[i]["status"].toString().toCapitalized(),
                              codAmount: codSettlementViewController.vendorList[i]["orderDetails"]["collectableCash"] != null ? "₹" + num.parse(codSettlementViewController.vendorList[i]["orderDetails"]["collectableCash"].toString()).abs().round().toString() : "₹0",
                              cashReceive: codSettlementViewController.vendorList[i]["orderDetails"]["cashReceive"] != null ? "₹" + num.parse(codSettlementViewController.vendorList[i]["orderDetails"]["cashReceive"].toString()).abs().round().toString() : "₹0",
                              diffAmount: codSettlementViewController.vendorList[i]["orderDetails"]["deferenceAmount"] != null ? "₹" + num.parse(codSettlementViewController.vendorList[i]["orderDetails"]["deferenceAmount"].toString()).abs().round().toString() : "₹0",
                              allottedDrivers: codSettlementViewController.vendorList[i]["orderDetails"]["driverId"] != null ? codSettlementViewController.vendorList[i]["orderDetails"]["driverId"]["name"] : "0",
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (codSettlementViewController.selectedVendorsCOD.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: commonButton(
                        onTap: () => codSettlementViewController.askForNote(),
                        text: "Proceed",
                        height: 50.0,
                      ),
                    ),
                ],
              ),
            ),
          if (codSettlementViewController.personNameSelect != true && codSettlementViewController.vendorNameList.isEmpty)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: const Text("No data found"),
            ),
          if (codSettlementViewController.personNameSelect != false && codSettlementViewController.vendorList.isEmpty)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: const Text("No data found"),
            ),
        ],
      ),
    );
  }
}
