// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/controller/edit_orders_controller.dart';
import 'package:fw_manager/controller/orders_controller.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class EditOrdersScreen extends StatelessWidget {
  EditOrdersController editOrdersController = Get.put(EditOrdersController());

  EditOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return editOrdersController.isSlider;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            foregroundColor: Colors.white,
            title: const Text("Edit Orders"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  commonBottomSheet(
                    context: context,
                    widget: SearchableListView(
                      isLive: false,
                      isOnSearch: true,
                      itemList: const [],
                      bindText: 'title',
                      bindValue: '_id',
                      labelText: 'Routes',
                      hintText: 'Please Select',
                      onSelect: (val, text) {},
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
                        "Routes",
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'Please Select',
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
                      itemList: const [],
                      bindText: 'title',
                      bindValue: '_id',
                      labelText: 'Update Address Details',
                      hintText: 'Please Select',
                      onSelect: (val, text) {},
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
                        "Update Address Details",
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'Please Select',
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
              commonButton(
                onTap: () {},
                text: "Save Change",
                height: 50.0,
                color: Colors.green,
              ).paddingAll(10),
            ],
          ).paddingAll(10),
        ),
      ),
    );
  }
}
