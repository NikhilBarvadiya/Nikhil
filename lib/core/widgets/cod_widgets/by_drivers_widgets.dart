import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/cod_controller.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_driver_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_data_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendors_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class ByDriversWidgets extends StatefulWidget {
  const ByDriversWidgets({Key? key}) : super(key: key);
  @override
  State<ByDriversWidgets> createState() => _ByDriversWidgetsState();
}

class _ByDriversWidgetsState extends State<ByDriversWidgets> {
  CodSettlementController codSettlementController = Get.put(CodSettlementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementController>(
      builder: (_) => Column(
        children: [
          if (codSettlementController.driverNameSelect != true)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      commonBottomSheet(
                        context: context,
                        widget: SearchableListView(
                          isLive: false,
                          isOnSearch: true,
                          itemList: const [],
                          bindText: 'name',
                          bindValue: '_id',
                          labelText: 'Drivers category',
                          hintText: 'Please Select',
                          onSelect: (val, text) {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text('Search drivers'),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => codSettlementController.onDatePickerDriver(),
                  child: Card(
                    elevation: 1,
                    color: Theme.of(context).primaryColor,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: const Icon(
                          Icons.filter_alt_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(bottom: codSettlementController.driverFilter != false ? 10 : 25),
          if (codSettlementController.startDateDriver != "" && codSettlementController.endDateDriver != "" && codSettlementController.driverFilter != false && codSettlementController.driverNameSelect != true)
            Container(
              padding: const EdgeInsets.only(bottom: 25),
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Text(
                "${codSettlementController.startDateDriver.split("T").first} "
                "- ${codSettlementController.endDateDriver.split("T").first}",
                style: AppCss.h3,
              ),
            ),
          if (codSettlementController.driverNameSelect != false)
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
          if (codSettlementController.driverNameSelect != true && codSettlementController.driverNameList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Person Name',
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
          if (codSettlementController.driverNameSelect != true && codSettlementController.driverNameList.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < codSettlementController.driverNameList[0]["data"].length; i++)
                    CommonCodVendorsCard(
                      personName: codSettlementController.driverNameList[0]["data"][i]["name"].toString(),
                      collectedAmount: "₹ " + num.parse(codSettlementController.driverNameList[0]["data"][i]["mainBalance"].toString()).abs().toString(),
                      onTap: () {
                        codSettlementController.onDriverNameClick(i);
                      },
                    ),
                ],
              ),
            ),
          if (codSettlementController.driverNameSelect != false && codSettlementController.driversList.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < codSettlementController.driversList.length; i++)
                    Container(
                      margin: EdgeInsets.only(bottom: i == (codSettlementController.driversList.length - 1) ? 100 : 5),
                      child: CommonCodDriverCard(
                        orderNo: codSettlementController.driversList[i]["orderDetails"]["orderNo"],
                        addressDate: getFormattedDate(codSettlementController.driversList[i]["createdAt"].toString()),
                        codAmount: codSettlementController.driversList[i]["orderDetails"]["collectableCash"] != null ? "₹" + codSettlementController.driversList[i]["orderDetails"]["collectableCash"].toString() : "₹0",
                        cashReceive: codSettlementController.driversList[i]["orderDetails"]["cashReceive"] != null ? "₹" + codSettlementController.driversList[i]["orderDetails"]["cashReceive"].toString() : "₹0",
                        diffAmount: codSettlementController.driversList[i]["orderDetails"]["deferenceAmount"] != null ? "₹" + codSettlementController.driversList[i]["orderDetails"]["deferenceAmount"].toString() : "₹0",
                        allottedDrivers: codSettlementController.driversList[i]["orderDetails"]["driverId"] != null ? codSettlementController.driversList[i]["orderDetails"]["driverId"]["name"] : "0",
                      ),
                    ),
                ],
              ),
            ),
          if (codSettlementController.driverNameSelect != false && codSettlementController.driversList.isEmpty)
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
