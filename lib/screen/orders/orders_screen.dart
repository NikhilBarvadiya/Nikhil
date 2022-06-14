// ignore_for_file: must_be_immutable, deprecated_member_useimport 'package:flutter/material.dart';import 'package:fw_manager/controller/app_controller.dart';import 'package:fw_manager/controller/orders_controller.dart';import 'package:fw_manager/core/assets/index.dart';import 'package:fw_manager/core/theme/app_css.dart';import 'package:fw_manager/core/widgets/common_widgets/common_chip.dart';import 'package:fw_manager/core/widgets/common_widgets/common_order_card.dart';import 'package:get/get.dart';import 'package:url_launcher/url_launcher.dart';class OrdersScreen extends StatelessWidget {  OrdersController ordersController = Get.put(OrdersController());  AppController appController = Get.put(AppController());  OrdersScreen({Key? key}) : super(key: key);  @override  Widget build(BuildContext context) {    return GetBuilder<OrdersController>(      builder: (_) => Column(        children: [          SingleChildScrollView(            scrollDirection: Axis.horizontal,            padding: const EdgeInsets.only(              top: 10,              left: 10,              right: 10,              bottom: 10,            ),            child: Row(              mainAxisAlignment: MainAxisAlignment.spaceEvenly,              children: [                for (int i = 0; i < ordersController.filters.length; i++)                  CommonChip(                    backgroundColor: ordersController.filters[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,                    label: ordersController.filters[i]["label"],                    chipColor: ordersController.filters[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),                    icon: ordersController.filters[i]["icon"],                    onTap: () => ordersController.onChange(i),                  ),                const SizedBox(width: 15),              ],            ),          ),          Expanded(            child: Padding(                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),                child: RefreshIndicator(                  onRefresh: () {                    return Future(() {                      const Duration(seconds: 2);                    });                  },                  child: ListView(                    children: [                      ...ordersController.selectedOrders.obs.map((e) {                        return Row(                          crossAxisAlignment: CrossAxisAlignment.start,                          children: [                            Container(                              height: 20,                              alignment: Alignment.center,                              margin: const EdgeInsets.only(top: 5),                              child: Text(                                e["_id"].toString(),                                style: AppCss.h3.copyWith(                                  color: Colors.black,                                ),                              ),                            ),                            Expanded(                              child: CommonOrderCard(                                orderNumber: e["orderNo"],                                orderDateTime: e["orderDateTime"],                                customerName: e["customerName"],                                customerNumber: e["customerNumber"],                                pickupStop: e["pickupStop"],                                amount: e["amount"],                                status: e["status"],                                requestedVehicle: e["requestedVehicle"],                                image: imageAssets.bike,                                textClick: () async {                                  String link = "tel:${e["customerName"]}";                                  await launch(link);                                },                              ),                            ),                          ],                        );                      }).toList(),                    ],                  ),                )),          ),        ],      ),    );  }}