// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller.dart';
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
  CodSettlementController codSettlementController = Get.put(CodSettlementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementController>(
      builder: (_) => Column(
        children: [
          // if (codSettlementController.personNameSelect != true)
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
          //         onTap: () => codSettlementController.onDatePickerVendor(),
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
          //   ).paddingOnly(bottom: codSettlementController.vendorFilter != false ? 10 : 25),
          // if (codSettlementController.startDateVendor != "" && codSettlementController.endDateVendor != "" && codSettlementController.vendorFilter != false && codSettlementController.personNameSelect != true)
          //   Container(
          //     padding: const EdgeInsets.only(bottom: 25),
          //     width: double.infinity,
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       "${codSettlementController.startDateVendor.split("T").first} " "- ${codSettlementController.endDateVendor.split("T").first}",
          //       style: AppCss.h3,
          //     ),
          //   ),
          if (codSettlementController.personNameSelect != false)
            Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  codSettlementController.onBackButton();
                },
                icon: const Icon(Icons.arrow_back_ios_sharp, size: 13),
                label: const Text("Back"),
              ),
            ),
          if (codSettlementController.personNameSelect != true && codSettlementController.vendorNameList.isNotEmpty)
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
          if (codSettlementController.personNameSelect != true && codSettlementController.vendorNameList.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < codSettlementController.vendorNameList[0]["data"].length; i++)
                    CommonCodVendorsCard(
                      personName: codSettlementController.vendorNameList[0]["data"][i]["name"].toString(),
                      collectedAmount: "₹ " + num.parse(codSettlementController.vendorNameList[0]["data"][i]["mainBalance"].toString()).abs().round().toString(),
                      onTap: () => codSettlementController.onPersonNameClick(i),
                    ),
                ],
              ),
            ),
          if (codSettlementController.personNameSelect != false && codSettlementController.vendorList.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < codSettlementController.vendorList.length; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: i == (codSettlementController.vendorList.length - 1) ? 20 : 3),
                            child: CommonCodVendorDataCard(
                              onTap: () {
                                codSettlementController.addToSelectedList(codSettlementController.vendorList[i]);
                              },
                              cardColors: codSettlementController.vendorList[i]["selected"] == true ? Colors.blue[50] : Colors.white,
                              orderNo: codSettlementController.vendorList[i]["orderDetails"]["orderNo"],
                              name: codSettlementController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"] != null ? codSettlementController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"]["name"].toString().toCapitalized() : codSettlementController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["address"].toString().toCapitalized(),
                              personName: "(${codSettlementController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"] != null ? codSettlementController.vendorList[i]["orderDetails"]["vendorOrderStatusId"]["addressId"]["person"].toString().toCapitalized() : '-'})",
                              addressDate: getFormattedDate(codSettlementController.vendorList[i]["createdAt"].toString()),
                              status: codSettlementController.vendorList[i]["status"].toString().toCapitalized(),
                              codAmount: codSettlementController.vendorList[i]["orderDetails"]["collectableCash"] != null ? "₹" + num.parse(codSettlementController.vendorList[i]["orderDetails"]["collectableCash"].toString()).abs().round().toString() : "₹0",
                              cashReceive: codSettlementController.vendorList[i]["orderDetails"]["cashReceive"] != null ? "₹" + num.parse(codSettlementController.vendorList[i]["orderDetails"]["cashReceive"].toString()).abs().round().toString() : "₹0",
                              diffAmount: codSettlementController.vendorList[i]["orderDetails"]["deferenceAmount"] != null ? "₹" + num.parse(codSettlementController.vendorList[i]["orderDetails"]["deferenceAmount"].toString()).abs().round().toString() : "₹0",
                              allottedDrivers: codSettlementController.vendorList[i]["orderDetails"]["driverId"] != null ? codSettlementController.vendorList[i]["orderDetails"]["driverId"]["name"] : "0",
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (codSettlementController.selectedVendorsCOD.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: commonButton(
                        onTap: () => codSettlementController.askForNote(),
                        text: "Proceed",
                        height: 50.0,
                      ),
                    ),
                ],
              ),
            ),
          if (codSettlementController.personNameSelect != false && codSettlementController.vendorList.isEmpty)
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
