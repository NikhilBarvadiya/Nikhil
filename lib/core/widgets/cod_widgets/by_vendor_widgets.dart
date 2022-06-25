// ignore_for_file: prefer_final_fieldsimport 'package:flutter/material.dart';import 'package:fw_manager/controller/app_controller.dart';import 'package:fw_manager/controller/cod_controller.dart';import 'package:fw_manager/core/theme/app_css.dart';import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_data_card.dart';import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendors_card.dart';import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';import 'package:get/get.dart';class ByVendorWidgets extends StatefulWidget {  const ByVendorWidgets({Key? key}) : super(key: key);  @override  State<ByVendorWidgets> createState() => _ByVendorWidgetsState();}class _ByVendorWidgetsState extends State<ByVendorWidgets> {  CodSettlementController codSettlementController = Get.put(CodSettlementController());  @override  Widget build(BuildContext context) {    return GetBuilder<CodSettlementController>(      builder: (_) => Column(        children: [          if (codSettlementController.personNameSelect != true)            Row(              children: [                Expanded(                  child: GestureDetector(                    onTap: () {                      commonBottomSheet(                        context: context,                        widget: SearchableListView(                          isLive: false,                          isOnSearch: true,                          itemList: const [],                          bindText: 'name',                          bindValue: '_id',                          labelText: 'Vendor category',                          hintText: 'Please Select',                          onSelect: (val, text) {                            Navigator.pop(context);                          },                        ),                      );                    },                    child: Container(                      decoration: BoxDecoration(                        color: Colors.grey[200],                        border: Border(                          bottom: BorderSide(                            color: Theme.of(context).primaryColor,                            width: 1.0,                          ),                        ),                      ),                      padding: const EdgeInsets.all(10),                      child: Row(                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children: [                          const Expanded(                            child: Text('Search vendor'),                          ),                          Icon(                            Icons.arrow_drop_down,                            color: Theme.of(context).primaryColor,                          ),                        ],                      ),                    ),                  ),                ),                const SizedBox(width: 15),                GestureDetector(                  onTap: () => codSettlementController.onDatePickerVendor(),                  child: Card(                    elevation: 1,                    color: Theme.of(context).primaryColor,                    child: AnimatedContainer(                      duration: const Duration(milliseconds: 100),                      alignment: Alignment.center,                      child: Container(                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),                        child: const Icon(                          Icons.filter_alt_outlined,                          size: 25,                          color: Colors.white,                        ),                      ),                    ),                  ),                ),              ],            ).paddingOnly(bottom: codSettlementController.vendorFilter != false ? 10 : 25),          if (codSettlementController.startDateVendor != "" &&              codSettlementController.endDateVendor != "" &&              codSettlementController.vendorFilter != false &&              codSettlementController.personNameSelect != true)            Container(              padding: const EdgeInsets.only(bottom: 25),              width: double.infinity,              alignment: Alignment.topLeft,              child: Text(                "${codSettlementController.startDateVendor.split("T").first} " "- ${codSettlementController.endDateVendor.split("T").first}",                style: AppCss.h3,              ),            ),          if (codSettlementController.personNameSelect != false)            Align(              alignment: Alignment.topLeft,              child: TextButton.icon(                onPressed: () {                  codSettlementController.onBackButton();                },                icon: const Icon(Icons.arrow_back_ios_sharp, size: 13),                label: const Text("Back"),              ),            ),          if (codSettlementController.personNameSelect != true)            Row(              mainAxisAlignment: MainAxisAlignment.spaceBetween,              children: [                Text(                  'Person Name',                  style: AppCss.h3.copyWith(                    color: AppController().appTheme.primary1,                  ),                ),                Text(                  'Collected Amount',                  style: AppCss.h3.copyWith(                    color: AppController().appTheme.primary1,                  ),                ),              ],            ).paddingOnly(bottom: 5),          if (codSettlementController.personNameSelect != true)            Expanded(              child: ListView(                children: [                  ...codSettlementController.vendorNameList.map((e) {                    return CommonCodVendorsCard(                      personName: e["personName"],                      collectedAmount: e["collectedAmount"],                      onTap: () => codSettlementController.onPersonNameClick(),                    );                  }),                ],              ),            ),          if (codSettlementController.personNameSelect != false)            Expanded(              child: ListView(                children: [                  for (int i = 0; i < codSettlementController.vendorList.length; i++)                   Container(                     margin: EdgeInsets.only(bottom: i == (codSettlementController.vendorList.length - 1) ? 100: 5),                     child:  CommonCodVendorDataCard(                       orderNo: codSettlementController.vendorList[i]["orderNo"],                       personName: codSettlementController.vendorList[i]["personName"],                       addressDate: codSettlementController.vendorList[i]["dateTime"],                       status: codSettlementController.vendorList[i]["status"],                       codAmount: codSettlementController.vendorList[i]["codAmount"],                       collectedAmount: codSettlementController.vendorList[i]["collectedAmount"],                       diffAmount: codSettlementController.vendorList[i]["diffAmount"],                       allottedDrivers: codSettlementController.vendorList[i]["allottedDrivers"],                     ),                   )                ],              ),            ),        ],      ),    );  }}