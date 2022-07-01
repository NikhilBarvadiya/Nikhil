import 'package:flutter/material.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/selected_order_address_card.dart';
import 'package:get/get.dart';

class SelectedLocation extends StatelessWidget {
  final multiOrdersController = Get.put(MultiOrdersController());

  SelectedLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiOrdersController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          title: const Text(
            "Selected Location",
            style: TextStyle(
              fontSize: 20,
            ),
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () => multiOrdersController.onMap(),
              icon: const Icon(Icons.location_pin),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    if (multiOrdersController.order[0]['isActive'] == true)
                      ...multiOrdersController.selectedOrderTrueList.map(
                        (e) {
                          int index = multiOrdersController.selectedOrderTrueList.indexOf(e);
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
                                child: SelectedOrderAddressCard(
                                  addressHeder: e["addressId"]["name"],
                                  address: e["addressId"]["address"],
                                  addressDate: e["addressId"]["updatedAt"].toString(),
                                  shortNo: e["addressId"]["shortNo"].toString(),
                                  personName: e["addressId"]["person"] + "\t\t\t(${e["addressId"]["mobile"]})",
                                  vendor: "vendor : ",
                                  vendorName: e["vendorOrderId"]["vendorId"]["name"],
                                  onTap: () {
                                    multiOrdersController.removeToSelectedList(e);
                                  },
                                  shortNumberAdd: () {
                                    showShortModel(context, index);
                                  },
                                  deleteIcon: Icons.close,
                                  deleteIconColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    if (multiOrdersController.order[1]['isActive'] == true)
                      ...multiOrdersController.selectedB2COrderTrueList.map(
                        (e) {
                          int index = multiOrdersController.selectedB2COrderTrueList.indexOf(e);
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
                                child: SelectedOrderAddressCard(
                                  address: e["address"],
                                  addressDate: e["updatedAt"].toString(),
                                  billNo: e["billNo"].toString(),
                                  personName: e["vendorOrderId"]["orderNo"] + "\t\t\t(${e["mobile"]})",
                                  addressHeder: e["routeId"]["name"],
                                  vendor: "vendor : ",
                                  vendorName: e["vendorOrderId"]["vendorId"]["name"],
                                  onTap: () {
                                    multiOrdersController.removeB2CToSelectedList(e);
                                  },
                                  height: 5.0,
                                  addressHederfontSize: 15.0,
                                  deleteIcon: Icons.close,
                                  deleteIconColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                  ],
                ),
              ),
              if (multiOrdersController.order[0]['isActive'] == true)
                multiOrdersController.isOpenOrder == true
                    ? commonButton(
                        onTap: () {
                          multiOrdersController.onMerge();
                        },
                        text: "Order Merge",
                        height: 50.0,
                      )
                    : Container(),
              if (multiOrdersController.order[1]['isActive'] == true)
                multiOrdersController.isOpenB2COrder == true
                    ? commonButton(
                        onTap: () {
                          multiOrdersController.onB2CMerge();
                        },
                        text: "Order Merge",
                        height: 50.0,
                      )
                    : Container(),
            ],
          ),
        ),
      ),
    );
  }

  showShortModel(context, index) {
    multiOrdersController.shortNumberController.text = multiOrdersController.selectedOrderTrueList[index]['addressId']['shortNo'].toString();
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Container(
            height: 170,
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Short number : ',
                  style: AppCss.h1,
                ).paddingOnly(left: 5),
                const SizedBox(height: 10),
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
                      child: TextFormField(
                        controller: multiOrdersController.shortNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                commonButton(
                  onTap: () => multiOrdersController.onShortNumberUpdate(index),
                  text: "Update",
                  height: 50.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
