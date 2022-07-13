// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_chip.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_order_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) => Column(
        children: [
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
                        labelText: 'Orders',
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
                          child: Text('Search orders'),
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
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => ordersController.onDatePickerVendor(),
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
          ).paddingAll(10),
          if (ordersController.startDateVendor != "" && ordersController.endDateVendor != "" && ordersController.ordersFilter != false)
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Text(
                "${ordersController.startDateVendor.split("T").first} " "- ${ordersController.endDateVendor.split("T").first}",
                style: AppCss.h3,
              ),
            ).paddingOnly(left: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < ordersController.filters.length; i++)
                  CommonChip(
                    backgroundColor: ordersController.filters[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                    label: ordersController.filters[i]["label"],
                    chipColor: ordersController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                    icon: ordersController.filters[i]["icon"],
                    onTap: () => ordersController.onChange(i),
                  ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: RefreshIndicator(
                onRefresh: () => ordersController.onRefresh(),
                child: ListView(
                  children: [
                    ...ordersController.selectedOrderList.map((e) {
                      var index = ordersController.selectedOrderList.indexOf(e) + 1;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              index.toString(),
                              style: AppCss.h3.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => ordersController.onDetailsTap(e),
                              child: CommonOrderCard(
                                orderNumber: e["orderNo"].toString(),
                                customerName: e["customerId"]["name"] != "" ? e["customerId"]["name"].toString().toUpperCase().capitalizeFirst : "-",
                                customerNumber: e["customerId"]["mobile"] != "" ? e["customerId"]["mobile"].toString() : "-",
                                pickupStop: e["locations"].length.toString() + "\t" + "Stops",
                                amount: "₹" + e["totalPayableAmount"].toString(),
                                // amountType: e["amountType"],
                                status: e["requestStatus"].toString(),
                                requestedVehicle: e["customerId"]["name"] != "" ? e["customerId"]["name"].toString().toUpperCase().capitalizeFirst : "-",
                                image: imageAssets.bike,
                                textClick: () async {
                                  String link = "tel:${e["customerId"]["mobile"]}";
                                  await launch(link);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    // Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
