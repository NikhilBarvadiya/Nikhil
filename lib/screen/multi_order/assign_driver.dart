import 'package:flutter/material.dart';
import 'package:fw_manager/controller/multi_orders_controller.dart';
import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_button.dart';
import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
import 'package:get/get.dart';

class AssignDriverScreen extends StatefulWidget {
  const AssignDriverScreen({Key? key}) : super(key: key);
  @override
  State<AssignDriverScreen> createState() => _AssignDriverScreenState();
}

class _AssignDriverScreenState extends State<AssignDriverScreen> {
  final multiOrdersController = Get.put(MultiOrdersController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiOrdersController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: true,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => multiOrdersController.onBack(),
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            title: const Text(
              "Assign Driver",
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
                    margin: 0.0,
                    widget: SearchableListView(
                      isLive: false,
                      isOnSearch: false,
                      itemList: multiOrdersController.vehiclesNames,
                      bindText: 'name',
                      bindValue: '_id',
                      labelText: 'Requested Vehicle',
                      hintText: 'Please Select',
                      onSelect: (id, text) {
                        multiOrdersController.onSelectedVehiclesList(id, text);
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
                        "Requested Vehicle",
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              multiOrdersController.isVehiclesSelected != "" ? multiOrdersController.isVehiclesSelected : 'Please Select',
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
              ).paddingAll(10),
              GestureDetector(
                onTap: () {
                  commonBottomSheet(
                    context: context,
                    height: Get.height * 0.4,
                    widget: SearchableListView(
                      isLive: false,
                      isOnSearch: false,
                      itemList: multiOrdersController.driversByVehicleName,
                      bindText: 'name',
                      bindValue: '_id',
                      labelText: 'Assign Driver',
                      hintText: 'Please Select',
                      onSelect: (id, text) {
                        multiOrdersController.onSelectedDriverVehiclesList(id, text);
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
                        "Assign Driver",
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              multiOrdersController.isDriversSelected != "" ? multiOrdersController.isDriversSelected : 'Please Select',
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
              ).paddingAll(10),
              TextFormField(
                controller: multiOrdersController.amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  labelText: "Driver Amount",
                  filled: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ).paddingAll(10),
              commonButton(
                onTap: () {
                  multiOrdersController.isOrderDone != true ? multiOrdersController.onPlacingOrderClicked() : null;
                },
                text: "Place Order",
                height: 50.0,
                color: multiOrdersController.isOrderDone != true ? Colors.green : Colors.grey,
              ).paddingAll(10),
            ],
          ),
        );
      },
    );
  }
}
