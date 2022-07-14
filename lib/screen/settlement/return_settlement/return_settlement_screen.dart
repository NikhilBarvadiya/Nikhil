// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/return_settlement_controller.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_data_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_settlement_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class ReturnSettlementScreen extends StatefulWidget {
  const ReturnSettlementScreen({Key? key}) : super(key: key);

  @override
  State<ReturnSettlementScreen> createState() => _ReturnSettlementScreenState();
}

class _ReturnSettlementScreenState extends State<ReturnSettlementScreen> {
  ReturnSettlementController returnSettlementController = Get.put(ReturnSettlementController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnSettlementController>(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < returnSettlementController.selectedOrder.length; i++)
                  GestureDetector(
                    onTap: () => returnSettlementController.onChange(i),
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
                          color: returnSettlementController.selectedOrder[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                          width: 1,
                        ),
                        color: returnSettlementController.selectedOrder[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                      ),
                      child: Text(
                        returnSettlementController.selectedOrder[i]["selectedOrder"],
                        style: AppCss.h1.copyWith(
                          color: returnSettlementController.selectedOrder[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      commonBottomSheet(
                        context: context,
                        margin: 0.0,
                        widget: SearchableListView(
                          isLive: false,
                          isOnSearch: false,
                          itemList: returnSettlementController.returnVendor,
                          bindText: 'name',
                          bindValue: '_id',
                          labelText: 'Select vendor',
                          hintText: 'Please select',
                          onSelect: (val, text) {
                            returnSettlementController.onReturnSettlementSelected(val, text);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select vendor",
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  returnSettlementController.isReturnSettlement != '' ? returnSettlementController.isReturnSettlement : 'Please Select',
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (returnSettlementController.returnSettlement.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: [
                          for (int i = 0; i < returnSettlementController.returnSettlement.length; i++)
                            CommonSettlementCard(
                              onTap: () {
                                if (returnSettlementController.isReturnSettlementId != "") {
                                  returnSettlementController.addToSelectedList(returnSettlementController.returnSettlement[i]);
                                }
                              },
                              borderColor: returnSettlementController.returnSettlement[i]["selected"] == true ? Colors.blue[50] : Colors.white,
                              name: returnSettlementController.returnSettlement[i]["addressId"] != null ? returnSettlementController.returnSettlement[i]["addressId"]["name"].toString() : '',
                              personName: returnSettlementController.returnSettlement[i]["addressId"] != null ? returnSettlementController.returnSettlement[i]["addressId"]["person"].toString() : '',
                              place: returnSettlementController.returnSettlement[i]["addressId"] != null ? returnSettlementController.returnSettlement[i]["addressId"]["address"].toString() : '',
                              dateTime: getFormattedDate(returnSettlementController.returnSettlement[i]["createdAt"].toString()),
                            ).paddingOnly(bottom: 5),
                          // Dismissible(
                          //   key: Key("$i"),
                          //   onUpdate: (i) {
                          //     // vendorSettlementController.returnSettlement;
                          //     vendorSettlementController.addToSelectedList(i);
                          //   },
                          //   direction: vendorSettlementController.isReturnSettlementId != "" ? DismissDirection.startToEnd : DismissDirection.none,
                          //   background: Stack(
                          //     children: [
                          //       if (vendorSettlementController.isReturnSettlementId != "")
                          //         CommonSettlementCard(
                          //           borderColor: Colors.green,
                          //           name: vendorSettlementController.returnSettlement[i]["addressId"]["name"].toString(),
                          //           personName: vendorSettlementController.returnSettlement[i]["addressId"]["person"].toString(),
                          //           place: vendorSettlementController.returnSettlement[i]["addressId"]["address"].toString(),
                          //         ),
                          //       if (vendorSettlementController.isReturnSettlementId != "")
                          //         Container(
                          //           decoration: const BoxDecoration(
                          //             color: Colors.green,
                          //           ),
                          //           padding: const EdgeInsets.all(2),
                          //           child: Text(
                          //             "Selected",
                          //             style: AppCss.body2.copyWith(color: Colors.white),
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          //   confirmDismiss: (direction) {
                          //     // return Future.delayed(const Duration(milliseconds: 100), () {
                          //     //   return vendorSettlementController.isReturnSettlementId != "" ? vendorSettlementController.addToSelectedList(i) : false;
                          //     // });
                          //     return vendorSettlementController.returnSettlement;
                          //   },
                          //   dismissThresholds: const {
                          //     DismissDirection.horizontal: 0.5,
                          //   },
                          // child: CommonSettlementCard(
                          //   name: vendorSettlementController.returnSettlement[i]["addressId"]["name"].toString(),
                          //   personName: vendorSettlementController.returnSettlement[i]["addressId"]["person"].toString(),
                          //   place: vendorSettlementController.returnSettlement[i]["addressId"]["address"].toString(),
                          //   dateTime: getFormattedDate(vendorSettlementController.returnSettlement[i]["createdAt"].toString()),
                          // ).paddingOnly(bottom: 5),
                          // ),
                        ],
                      ),
                    ),
                  if (returnSettlementController.isReturnSettlementId != "")
                    commonButton(
                      onTap: () => returnSettlementController.askForNote(),
                      text: "Procced",
                      height: 50.0,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
