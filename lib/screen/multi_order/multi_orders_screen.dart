// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/order_address_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class MultiOrdersScreen extends StatelessWidget {
  MultiOrdersController multiOrdersController = Get.put(MultiOrdersController());

  MultiOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiOrdersController>(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            if (multiOrdersController.isOpenOrder == false && multiOrdersController.isOpenB2COrder == false)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < multiOrdersController.order.length; i++)
                        GestureDetector(
                          onTap: () => multiOrdersController.onChange(i),
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
                                color: multiOrdersController.order[i]["isActive"] ? Colors.transparent : AppController().appTheme.primary1.withOpacity(.8),
                                width: 1,
                              ),
                              color: multiOrdersController.order[i]["isActive"] ? AppController().appTheme.primary1.withOpacity(.8) : Colors.white,
                            ),
                            child: Text(
                              multiOrdersController.order[i]["order"],
                              style: AppCss.h1.copyWith(
                                color: multiOrdersController.order[i]["isActive"] ? Colors.white : AppController().appTheme.primary1.withOpacity(.8),
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
                        onPressed: () => multiOrdersController.onOpenTap(),
                        icon: Icon(
                          multiOrdersController.isOpenTap ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            if (multiOrdersController.isOpenOrder == false && multiOrdersController.isOpenTap == true && multiOrdersController.isOpenB2COrder == false)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      commonBottomSheet(
                        context: context,
                        margin: 0.0,
                        widget: SearchableListView(
                          isLive: false,
                          isOnSearch: false,
                          itemList: multiOrdersController.businessCategories,
                          bindText: 'title',
                          bindValue: '_id',
                          labelText: 'Business categories',
                          hintText: 'Please Select',
                          onSelect: (val, text) {
                            multiOrdersController.onBusinessSelected(val, text);
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
                            "Business categories",
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  multiOrdersController.isBusinessSelected != '' ? multiOrdersController.isBusinessSelected : 'Please Select',
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
                            return multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.fatchVendor(search) : multiOrdersController.fatchB2CVendor(search);
                          },
                          itemList: multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.getVendorsList : multiOrdersController.getB2CVendorsList,
                          bindText: 'name',
                          bindValue: '_id',
                          labelText: 'Vendor',
                          hintText: 'Please Select',
                          onSelect: (val, text) {
                            multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.onVendorsSelected(val, text) : multiOrdersController.onB2CVendorsSelected(val, text);
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
                            "Vendor",
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  multiOrdersController.order[0]['isActive'] == true
                                      ? multiOrdersController.isVendorsSelectedId != ""
                                          ? multiOrdersController.isVendorsSelectedId
                                          : 'Please Select'
                                      : multiOrdersController.isB2CVendorsSelectedId != ""
                                          ? multiOrdersController.isB2CVendorsSelectedId
                                          : 'Please Select',
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
                  if (multiOrdersController.order[0]['isActive'] == true)
                    GestureDetector(
                      onTap: () {
                        commonBottomSheet(
                          context: context,
                          widget: SearchableListView(
                            isLive: false,
                            isOnSearch: true,
                            fetchApi: (search) async {
                              return multiOrdersController.fatchArea(search);
                            },
                            itemList: multiOrdersController.areaList,
                            bindText: 'name',
                            bindValue: '_id',
                            labelText: 'Area',
                            hintText: 'Please Select',
                            onSelect: (val, text) {
                              multiOrdersController.onAreaSelected(val, text);
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
                              "Area",
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    multiOrdersController.isAreaSelected != "" ? multiOrdersController.isAreaSelected : 'Please Select',
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
                    ).paddingOnly(bottom: 15),
                  GestureDetector(
                    onTap: () {
                      commonBottomSheet(
                        context: context,
                        widget: SearchableListView(
                          isLive: false,
                          isOnSearch: true,
                          fetchApi: (search) async {
                            return multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.fatchRoute(search) : multiOrdersController.fatchB2CRoute(search);
                          },
                          itemList: multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.routeList : multiOrdersController.b2cRouteList,
                          bindText: 'name',
                          bindValue: '_id',
                          labelText: 'Route',
                          hintText: 'Please Select Route',
                          onSelect: (val, text) {
                            multiOrdersController.order[0]['isActive'] == true ? multiOrdersController.onRouteSelected(val, text) : multiOrdersController.onB2CRouteSelected(val, text);
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
                            "Route",
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  multiOrdersController.order[0]['isActive'] == true
                                      ? multiOrdersController.isRouteSelectedId != ""
                                          ? multiOrdersController.isRouteSelectedId
                                          : 'Please Select'
                                      : multiOrdersController.isb2cRouteSelectedId != ""
                                          ? multiOrdersController.isb2cRouteSelectedId
                                          : 'Please Select',
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
                ],
              ),
            if (multiOrdersController.isRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isVendorsSelectedId != "" && multiOrdersController.isAreaSelected != "")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order locations",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => multiOrdersController.toggleOpenOrder(),
                    icon: Icon(
                      multiOrdersController.isOpenOrder ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                    ),
                  ),
                ],
              ),
            if (multiOrdersController.isb2cRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isB2CVendorsSelectedId != "")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order locations",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => multiOrdersController.toggleOpenB2COrder(),
                    icon: Icon(
                      multiOrdersController.isOpenOrder ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                    ),
                  ),
                ],
              ),
            if (multiOrdersController.isRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isVendorsSelectedId != "" && multiOrdersController.isAreaSelected != "" && multiOrdersController.isOpenOrder == true)
              TextFormField(
                onChanged: (search) {},
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  labelText: 'Search',
                  hintText: 'Enter Order location',
                  suffixIcon: SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintStyle: const TextStyle(fontSize: 15),
                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            if (multiOrdersController.isb2cRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isB2CVendorsSelectedId != "" && multiOrdersController.isOpenB2COrder == true)
              TextFormField(
                onChanged: (search) {},
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  labelText: 'Search',
                  hintText: 'Enter Order location',
                  suffixIcon: SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintStyle: const TextStyle(fontSize: 15),
                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            if (multiOrdersController.isRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isVendorsSelectedId != "" && multiOrdersController.isAreaSelected != "" && multiOrdersController.isOpenOrder == true)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    ...multiOrdersController.vendorOrdersList.map(
                      (e) {
                        int index = multiOrdersController.vendorOrdersList.indexOf(e);
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
                                  multiOrdersController.addToSelectedList(e);
                                },
                                deleteIcon: e['selected'] == null
                                    ? Icons.add
                                    : e['selected'] == true
                                        ? Icons.check
                                        : Icons.add,
                                deleteIconBoxColor: AppController().appTheme.green,
                                deleteIconColor: Colors.black,
                                cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
                                icon: e['selected'] == null
                                    ? false
                                    : e['selected'] == true
                                        ? true
                                        : false,
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            if (multiOrdersController.isb2cRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isB2CVendorsSelectedId != "" && multiOrdersController.isOpenB2COrder == true)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    ...multiOrdersController.vendorB2COrdersList.map(
                      (e) {
                        int index = multiOrdersController.vendorB2COrdersList.indexOf(e);
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
                                addressHeder: e["routeId"]["name"],
                                personName: e["mobile"].toString(),
                                vendor: "vendor : ",
                                vendorName: e["vendorOrderId"]["vendorId"]["name"],
                                onTap: () {
                                  multiOrdersController.addB2CToSelectedList(e);
                                },
                                addressHederfontSize: 15.0,
                                deleteIcon: e['selected'] == null
                                    ? Icons.add
                                    : e['selected'] == true
                                        ? Icons.check
                                        : Icons.add,
                                deleteIconBoxColor: AppController().appTheme.green,
                                deleteIconColor: Colors.black,
                                cardColors: e['selected'] == true ? Colors.green[100] : Colors.white,
                                icon: e['selected'] == null
                                    ? false
                                    : e['selected'] == true
                                        ? true
                                        : false,
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            if (multiOrdersController.isRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isVendorsSelectedId != "" && multiOrdersController.isAreaSelected != "" && multiOrdersController.isOpenOrder == true)
              commonButton(
                onTap: () {
                  multiOrdersController.onSelectedLocation();
                },
                text: "Selected location (${multiOrdersController.selectedOrderTrueList.length})",
                height: 50.0,
              ),
            if (multiOrdersController.isb2cRouteSelectedId != "" && multiOrdersController.isBusinessSelected != "" && multiOrdersController.isB2CVendorsSelectedId != "" && multiOrdersController.isOpenB2COrder == true)
              commonButton(
                onTap: () {
                  multiOrdersController.onSelectedLocation();
                },
                text: "Selected location (${multiOrdersController.selectedB2COrderTrueList.length})",
                height: 50.0,
              ),
          ],
        ),
      ),
    );
  }
}
