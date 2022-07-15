// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_chip.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_order_card.dart';
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < ordersController.filters.length; i++)
                  Stack(
                    children: [
                      CommonChip(
                        backgroundColor: ordersController.filters[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                        label: ordersController.filters[i]["label"],
                        chipColor: ordersController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
                        icon: ordersController.filters[i]["icon"],
                        onTap: () => ordersController.onChange(i),
                      ),
                    ],
                  ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              commonBottomSheet(
                context: context,
                height: MediaQuery.of(context).size.height * 45 / 100,
                widget: ListView(
                  children: [
                    for (int i = 0; i < ordersController.searchFilter.length; i++)
                      ListTile(
                        onTap: () => ordersController.onSearchFilter(i),
                        selectedColor: Theme.of(context).primaryColor,
                        title: Text(
                          ordersController.searchFilter[i]["name"].toString(),
                        ),
                      ),
                  ],
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
                  Expanded(
                    child: Text(ordersController.searchFilterName != "" ? ordersController.searchFilterName : 'Search Filter'),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ).paddingSymmetric(horizontal: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (search) {
                      ordersController.onOrdersApiCalling(ordersController.txtSearchController.text);
                    },
                    controller: ordersController.txtSearchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Enter Order location',
                      hintStyle: AppCss.poppins,
                      suffixIcon: SizedBox(
                        child: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
            ).paddingOnly(left: 15),
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
                                orderNumber: e["orderNo"] != null ? e["orderNo"].toString() : "-",
                                customerName: e["customerId"] != null ? e["customerId"]["name"].toString().toUpperCase().capitalizeFirst : "__________",
                                customerNumber: e["customerId"] != null ? e["customerId"]["mobile"].toString() : "",
                                pickupStop: e["locations"].length.toString() + "\t" + "Stops",
                                amount: "₹" + e["totalPayableAmount"].toString(),
                                amountType: e["paymentMode"] != "" ? e["paymentMode"].toString() : "",
                                status: e["requestStatus"].toString(),
                                requestedVehicle: e["driver"] != null ? e["driver"]["driverName"].toString().toUpperCase().capitalizeFirst : "__________",
                                image: imageAssets.bike,
                                textClick: () async {
                                  String link = "tel:${e["driver"]["driverPhone"]}";
                                  await launch(link);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
