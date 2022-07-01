// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/common_controller.dart';
import 'package:fw_manager/controller/vender_settlement_controller.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_settlement_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class ReturnOrderWdgets extends StatefulWidget {
  const ReturnOrderWdgets({Key? key}) : super(key: key);

  @override
  State<ReturnOrderWdgets> createState() => _ReturnOrderWdgetsState();
}

class _ReturnOrderWdgetsState extends State<ReturnOrderWdgets> {
  VendorSettlementController vendorSettlementController = Get.put(VendorSettlementController());
  CommonController _commonController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSettlementController>(
      builder: (_) => Column(
        children: [
          GestureDetector(
            onTap: () {
              showVendorModel(context);
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
                    "Vendor category",
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text('Please Select'),
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
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showOrderModel(context);
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
                          child: Text('Search order'),
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
                onTap: () => vendorSettlementController.onDatePickerReturn(),
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
          ),
          const SizedBox(height: 5),
          if (vendorSettlementController.startDateReturnOrder != "" && vendorSettlementController.endDateReturnOrder != "" && vendorSettlementController.returnOrderFilter != false)
            Container(
              padding: const EdgeInsets.only(left: 5),
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Text(
                "${vendorSettlementController.startDateReturnOrder.split("T").first} "
                "- ${vendorSettlementController.endDateReturnOrder.split("T").first}",
                style: AppCss.h3,
              ),
            ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              children: [
                if (vendorSettlementController.returnSettlement != null && vendorSettlementController.returnSettlement.length > 0)
                  ...vendorSettlementController.returnSettlement.map(
                    (e) {
                      return CommonSettlementCard(
                        orderNo: e["orderNo"],
                        id: e["id"],
                        place: e["place"],
                        dateTime: e["dateTime"],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showVendorModel(context) {
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
          child: SizedBox(
            child: SearchableListView(
              isLive: false,
              isOnSearch: true,
              itemList: const [],
              bindText: 'name',
              bindValue: '_id',
              labelText: 'Vendor category',
              hintText: 'Please Select',
              onSelect: (val, text) {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  showOrderModel(context) {
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
          child: SizedBox(
            child: SearchableListView(
              isLive: false,
              isOnSearch: true,
              itemList: const [],
              bindText: 'name',
              bindValue: '_id',
              labelText: 'Order Search',
              hintText: 'Please Select',
              onSelect: (val, text) {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
