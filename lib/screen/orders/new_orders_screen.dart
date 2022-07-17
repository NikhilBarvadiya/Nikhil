// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/order_address_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class NewOrdersScreen extends StatelessWidget {
  NewOrdersScreen({Key? key}) : super(key: key);
  OrdersController ordersController = Get.put(OrdersController());
  final CommonController _commonController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return ordersController.isSlider;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            foregroundColor: Colors.white,
            backgroundColor: ordersController.isNewAdd ? Theme.of(context).primaryColor : Colors.amber,
            title: const Text("New Orders"),
            leading: IconButton(
              onPressed: () => ordersController.isNewAdd ? ordersController.onOrderBack() : ordersController.onRepair(),
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            actions: [
              MaterialButton(
                onPressed: () => ordersController.onNewAdd(),
                child: const Text(
                  "NEW ADD",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (ordersController.isOpenOrder == false)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < ordersController.order.length; i++)
                          GestureDetector(
                            onTap: () => ordersController.onChangeOrder(i),
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
                                  color: ordersController.order[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                                  width: 1,
                                ),
                                color: ordersController.order[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                              ),
                              child: Text(
                                ordersController.order[i]["title"],
                                style: AppCss.h1.copyWith(
                                  color: ordersController.order[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filters",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () => ordersController.onOpenTap(),
                          icon: Icon(
                            ordersController.isOpenTap ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              if (ordersController.isOpenOrder == false && ordersController.isOpenTap == true)
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        commonBottomSheet(
                          context: context,
                          widget: SearchableListView(
                            isLive: false,
                            isOnSearch: true,
                            itemList: ordersController.businessCategories,
                            bindText: 'title',
                            bindValue: '_id',
                            labelText: 'Select category',
                            hintText: 'Please Select',
                            onSelect: (val, text) {
                              ordersController.onBusinessSelected(val, text);
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
                              "Select category",
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    ordersController.isBusinessSelected != '' ? ordersController.isBusinessSelected : 'Please Select',
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
                    GestureDetector(
                      onTap: () {
                        commonBottomSheet(
                          context: context,
                          widget: SearchableListView(
                            isLive: false,
                            isOnSearch: true,
                            fetchApi: (search) async {
                              return ordersController.fatchVendor(search);
                            },
                            itemList: ordersController.getVendorsList,
                            bindText: 'name',
                            bindValue: '_id',
                            labelText: 'Select vendor',
                            hintText: 'Please Select',
                            onSelect: (val, text) {
                              ordersController.onVendorsSelected(val, text);
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
                                    ordersController.isVendorsSelectedId != "" ? ordersController.isVendorsSelectedId : 'Please Select',
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
                    if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isNewAdd == false)
                      GestureDetector(
                        onTap: () {
                          commonBottomSheet(
                            context: context,
                            widget: SearchableListView(
                              isLive: false,
                              isOnSearch: true,
                              itemList: ordersController.getRoutesDetailsList,
                              bindText: 'name',
                              bindValue: '_id',
                              labelText: 'Select routes',
                              hintText: 'Please Select',
                              onSelect: (val, text) {
                                ordersController.onRouteSelected(val, text);
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
                                "Select routes",
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ordersController.isRouteSelected != "" ? ordersController.isRouteSelected : 'Please Select',
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
                      ).paddingOnly(top: 15),
                  ],
                ),
              // if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isRouteSelected != "")
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text(
              //         "New orders address",
              //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              //       ),
              //       IconButton(
              //         onPressed: () => ordersController.onCloseTap(),
              //         icon: Icon(
              //           ordersController.isNewOrder ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
              //         ),
              //       ),
              //     ],
              //   ),
              // if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isRouteSelected != "" && ordersController.isOpenOrder != false && ordersController.isNewAdd == false)
              //   Expanded(
              //     child: ListView(
              //       padding: const EdgeInsets.only(top: 10),
              //       children: [
              //         ...ordersController.vendorOrderMergeByBusinessCategoryIdList.toSet().toList().map(
              //           (e) {
              //             int index = ordersController.vendorOrderMergeByBusinessCategoryIdList.indexOf(e);
              //             return Row(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Container(
              //                   height: 20,
              //                   alignment: Alignment.center,
              //                   margin: const EdgeInsets.only(top: 5),
              //                   child: Text(
              //                     "${index + 1}",
              //                     style: AppCss.h3.copyWith(
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   child: OrderAddressCard(
              //                     addressHeder: e["addressId"]["name"],
              //                     personName: e["addressId"]["person"] + "\t\t\t(${e["addressId"]["mobile"]})",
              //                     vendor: "vendor : ",
              //                     vendorName: e["vendorOrderId"]["vendorId"]["name"],
              //                     onTap: () {
              //                       ordersController.addToSelectedList(e);
              //                     },
              //                     deleteIcon: e['selected'] == null
              //                         ? Icons.add
              //                         : e['selected'] == true
              //                             ? Icons.check
              //                             : Icons.add,
              //                     icon: e['selected'] == null
              //                         ? false
              //                         : e['selected'] == true
              //                             ? true
              //                             : false,
              //                     deleteIconColor: Colors.black,
              //                     deleteIconBoxColor: AppController().appTheme.green,
              //                     cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
              //                   ),
              //                 ),
              //               ],
              //             );
              //           },
              //         ).toList(),
              //       ],
              //     ),
              //   ),

              if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isNewAdd == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Orders address",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => ordersController.onCloseTap(),
                      icon: Icon(
                        ordersController.isOpenOrder ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                      ),
                    ),
                  ],
                ),
              if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isOpenOrder != false && ordersController.isNewAdd == true)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: [
                      ...ordersController.vendorOrderMergeByBusinessCategoryIdList.toSet().toList().map(
                        (e) {
                          int index = ordersController.vendorOrderMergeByBusinessCategoryIdList.indexOf(e);
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
                                child: OrderAddressCard(
                                  addressHeder: e["addressId"]["name"],
                                  personName: e["addressId"]["person"] + "\t\t\t(${e["addressId"]["mobile"]})",
                                  vendor: "vendor : ",
                                  vendorName: e["vendorOrderId"]["vendorId"]["name"],
                                  onTap: () {
                                    ordersController.addToSelectedList(e);
                                  },
                                  deleteIcon: e['selected'] == null
                                      ? Icons.add
                                      : e['selected'] == true
                                          ? Icons.check
                                          : Icons.add,
                                  icon: e['selected'] == null
                                      ? false
                                      : e['selected'] == true
                                          ? true
                                          : false,
                                  deleteIconColor: Colors.black,
                                  deleteIconBoxColor: AppController().appTheme.green,
                                  cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              if (ordersController.isBusinessSelected != '' && ordersController.isVendorsSelectedId != '' && ordersController.isOpenOrder != false && ordersController.isNewAdd == true)
                commonButton(
                  onTap: () {
                    ordersController.onNewSelectedOrders();
                  },
                  text: "Selected location (${ordersController.selectedOrderTrueList.length})",
                  height: 50.0,
                ),
            ],
          ).paddingAll(10),
        ),
      ),
    );
  }

  showItemModel(context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: _commonController.statusBarHeight),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            child: SearchableListView(
              isLive: false,
              isOnSearch: true,
              fetchApi: (search) async {},
              itemList: const [],
              bindText: 'name',
              bindValue: '_id',
              labelText: 'Vendor',
              hintText: 'Please Select Item',
              onSelect: (val, text) {},
            ),
          ),
        );
      },
    );
  }
}
