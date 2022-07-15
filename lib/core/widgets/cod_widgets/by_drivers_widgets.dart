import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller_view.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_driver_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_data_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendors_card.dart';
import 'package:get/get.dart';

class ByDriversWidgets extends StatefulWidget {
  const ByDriversWidgets({Key? key}) : super(key: key);
  @override
  State<ByDriversWidgets> createState() => _ByDriversWidgetsState();
}

class _ByDriversWidgetsState extends State<ByDriversWidgets> {
  CodSettlementViewController codSettlementViewController = Get.put(CodSettlementViewController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementViewController>(
      builder: (_) => Column(
        children: [
          // if (codSettlementViewController.driverNameSelect != true)
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
          //                 labelText: 'Drivers name',
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
          //                   child: Text('Search drivers'),
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
          //         onTap: () => codSettlementViewController.onDatePickerDriver(),
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
          //   ).paddingOnly(bottom: codSettlementViewController.driverFilter != false ? 10 : 10),
          // if (codSettlementViewController.startDateDriver != "" && codSettlementViewController.endDateDriver != "" && codSettlementViewController.driverFilter != false && codSettlementViewController.driverNameSelect != true)
          //   Container(
          //     padding: const EdgeInsets.only(bottom: 25),
          //     width: double.infinity,
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       "${codSettlementViewController.startDateDriver.split("T").first} "
          //       "- ${codSettlementViewController.endDateDriver.split("T").first}",
          //       style: AppCss.h3,
          //     ),
          //   ),
          if (codSettlementViewController.driverNameSelect != false)
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
          if (codSettlementViewController.driverNameSelect != true && codSettlementViewController.driverNameList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Driver Name',
                  style: AppCss.h3.copyWith(
                    color: AppController().appTheme.primary1,
                  ),
                ),
                Text(
                  'Payable Amount',
                  style: AppCss.h3.copyWith(
                    color: AppController().appTheme.primary1,
                  ),
                ),
              ],
            ).paddingOnly(bottom: 5),
          if (codSettlementViewController.driverNameSelect != true && codSettlementViewController.driverNameList.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < codSettlementViewController.driverNameList[0]["data"].length; i++)
                    CommonCodVendorsCard(
                      personName: codSettlementViewController.driverNameList[0]["data"][i]["name"].toString(),
                      collectedAmount: "₹ " + num.parse(codSettlementViewController.driverNameList[0]["data"][i]["mainBalance"].toString()).abs().toString(),
                      onTap: () {
                        codSettlementViewController.onDriverNameClick(i);
                      },
                    ),
                ],
              ),
            ),
          if (codSettlementViewController.driverNameSelect != false && codSettlementViewController.driversList.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        for (int i = 0; i < codSettlementViewController.driversList.length; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: i == (codSettlementViewController.driversList.length - 1) ? 20 : 5),
                            child: CommonCodDriverCard(
                              onTap: () {
                                codSettlementViewController.addToSelectedDriverList(codSettlementViewController.driversList[i]);
                              },
                              cardColors: codSettlementViewController.driversList[i]["selected"] == true ? Colors.blue[50] : Colors.white,
                              orderNo: codSettlementViewController.driversList[i]["orderDetails"]["orderNo"],
                              addressDate: getFormattedDate(codSettlementViewController.driversList[i]["createdAt"].toString()),
                              codAmount: codSettlementViewController.driversList[i]["orderDetails"]["collectableCash"] != null ? "₹" + codSettlementViewController.driversList[i]["orderDetails"]["collectableCash"].toString() : "₹0",
                              cashReceive: codSettlementViewController.driversList[i]["orderDetails"]["cashReceive"] != null ? "₹" + codSettlementViewController.driversList[i]["orderDetails"]["cashReceive"].toString() : "₹0",
                              diffAmount: codSettlementViewController.driversList[i]["orderDetails"]["deferenceAmount"] != null ? "₹" + codSettlementViewController.driversList[i]["orderDetails"]["deferenceAmount"].toString() : "₹0",
                              allottedDrivers: codSettlementViewController.driversList[i]["orderDetails"]["driverId"] != null ? codSettlementViewController.driversList[i]["orderDetails"]["driverId"]["name"] : "0",
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (codSettlementViewController.selectedDriverCOD.isNotEmpty)
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
          if (codSettlementViewController.driverNameSelect != true && codSettlementViewController.driverNameList.isEmpty)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: const Text("No data found"),
            ),
          if (codSettlementViewController.driverNameSelect != false && codSettlementViewController.driversList.isEmpty)
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
