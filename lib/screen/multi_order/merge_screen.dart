// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_merge_card.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class MergeScreen extends StatefulWidget {
  const MergeScreen({Key? key}) : super(key: key);

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen> {
  final multiOrdersController = Get.put(MultiOrdersController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiOrdersController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          title: const Text(
            "Order Merge",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                commonBottomSheet(
                  context: context,
                  widget: SearchableListView(
                    isLive: true,
                    isOnSearch: true,
                    itemList: const [],
                    bindText: 'name',
                    bindValue: '_id',
                    labelText: 'Pickup point',
                    hintText: 'Please Select',
                    fetchApi: (search) async {
                      return multiOrdersController.getGlobalAddressBySearch(search);
                    },
                    onSelect: (id, text) {
                      multiOrdersController.onPickupItemsList(id, text);
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
                      "Select Pickup Point",
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Expanded(
                          child: Text(
                            multiOrdersController.isPickupSelected != "" ? multiOrdersController.isPickupSelected : 'Please Select',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  if (multiOrdersController.order[0]['isActive'] == true)
                  ...multiOrdersController.selectedLocations.map((e) {
                    int index = multiOrdersController.selectedLocations.indexOf(e);
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
                          child: CommonMergeCard(
                            person: e["person"],
                            personData: e["name"],
                            shortNo:e["shortNo"].toString(),
                            address: e["address"],
                            items: e["itemList"][0]["quantity"].toString(),
                            onItems: () {
                              multiOrdersController.itemsNameController.text = e["itemList"][0]["itemName"].toString();
                              multiOrdersController.itemsController.text = e["itemList"][0]["quantity"].toString();
                              showItemsModel(context);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
               if (multiOrdersController.order[1]['isActive'] == true)
                ...multiOrdersController.selectedB2CLocations.map((e) {
                    int index = multiOrdersController.selectedB2CLocations.indexOf(e);
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
                          child: CommonMergeCard(
                            person: e["person"],
                            personData: e["name"],
                            shortNo: e["shortNo"].toString(),
                            address: e["address"],
                            items: e["itemList"][0]["quantity"].toString(),
                            onItems: () {
                              multiOrdersController.itemsNameController.text = e["itemList"][0]["itemName"].toString();
                              multiOrdersController.itemsController.text = e["itemList"][0]["quantity"].toString();
                              showItemsModel(context);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            commonButton(
              onTap: () {
                multiOrdersController.onAssignDriver();
              },
              text: "Assign Driver",
              height: 50.0,
            ),
          ],
        ).paddingAll(10),
      ),
    );
  }

  showItemsModel(context) {
    commonBottomSheet(
      context: context,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items List : ',
            style: AppCss.h1,
          ).paddingOnly(left: 5).marginOnly(bottom: 10),
          Expanded(
            child: ListView(
              children: [
                Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Container(
                    height: 50.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: multiOrdersController.itemsNameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: multiOrdersController.itemsController,
                              readOnly: true,
                              textAlign: TextAlign.end,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).marginOnly(bottom: 5),
              ],
            ),
          ),
          commonButton(
            onTap: () {
              Get.back();
            },
            text: "Back",
            height: 50.0,
          ),
        ],
      ).paddingAll(10),
    );
  }
}
