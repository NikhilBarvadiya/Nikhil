// ignore_for_file: prefer_final_fieldsimport 'package:flutter/material.dart';import 'package:fw_manager/controller/app_controller.dart';import 'package:fw_manager/controller/cod_controller.dart';import 'package:fw_manager/controller/common_controller.dart';import 'package:fw_manager/core/theme/app_css.dart';import 'package:fw_manager/core/widgets/common_widgets/common_cod_vendor_card.dart';import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';import 'package:get/get.dart';class ByVendorWidgets extends StatefulWidget {  const ByVendorWidgets({Key? key}) : super(key: key);  @override  State<ByVendorWidgets> createState() => _ByVendorWidgetsState();}class _ByVendorWidgetsState extends State<ByVendorWidgets> {  CodSettlementController codSettlementController = Get.put(CodSettlementController());  CommonController _commonController = Get.find();  AppController appController = Get.put(AppController());  @override  Widget build(BuildContext context) {    return GetBuilder<CodSettlementController>(      builder: (_) => Column(        children: [          Row(            children: [              Expanded(                child: GestureDetector(                  onTap: () {                    showVendorModel(context);                  },                  child: Container(                    decoration: BoxDecoration(                      color: Colors.grey[200],                      border: Border(                        bottom: BorderSide(                          color: Theme.of(context).primaryColor,                          width: 1.0,                        ),                      ),                    ),                    padding: const EdgeInsets.all(10),                    child: Row(                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                      children: [                        const Expanded(                          child: Text('Search vendor'),                        ),                        Icon(                          Icons.arrow_drop_down,                          color: Theme.of(context).primaryColor,                        ),                      ],                    ),                  ),                ),              ),              const SizedBox(width: 15),              GestureDetector(                onTap: () => codSettlementController.onDatePickerVendor(),                child: Card(                  elevation: 1,                  color: Theme.of(context).primaryColor,                  child: AnimatedContainer(                    duration: const Duration(milliseconds: 100),                    alignment: Alignment.center,                    child: Container(                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),                      child: const Icon(                        Icons.filter_alt_outlined,                        size: 25,                        color: Colors.white,                      ),                    ),                  ),                ),              ),            ],          ),          const SizedBox(height: 5),          if (codSettlementController.startDateVendor != "" &&              codSettlementController.endDateVendor != "" &&              codSettlementController.vendorFilter != false)            Container(              padding: const EdgeInsets.only(left: 5),              width: double.infinity,              alignment: Alignment.topLeft,              child: Text(                "${codSettlementController.startDateVendor.split("T").first} " "- ${codSettlementController.endDateVendor.split("T").first}",                style: AppCss.h3,              ),            ),          const SizedBox(height: 15),          Expanded(            child: ListView(              children: [                ...codSettlementController.vendorList.map(                  (e) {                    return CommonCodVendorCard(                      orderNo: e["orderNo"],                      personName: e["personName"],                      addressDate: e["dateTime"],                      status: e["status"],                      codAmount: e["codAmount"],                      collectedAmount: e["collectedAmount"],                      diffAmount: e["diffAmount"],                      allottedDrivers: e["allottedDrivers"],                    );                  },                ).toList(),              ],            ),          ),        ],      ),    );  }  showVendorModel(context) {    showModalBottomSheet<void>(      backgroundColor: Colors.transparent,      context: context,      isScrollControlled: true,      enableDrag: false,      builder: (BuildContext context) {        return Container(          margin: EdgeInsets.only(top: _commonController.statusBarHeight),          decoration: const BoxDecoration(            color: Colors.white,            borderRadius: BorderRadius.only(              topLeft: Radius.circular(10),              topRight: Radius.circular(10),            ),          ),          padding: MediaQuery.of(context).viewInsets,          child: SizedBox(            child: SearchableListView(              isLive: false,              isOnSearch: true,              itemList: const [],              bindText: 'name',              bindValue: '_id',              labelText: 'Vendor category',              hintText: 'Please Select',              onSelect: (val, text) {                Navigator.pop(context);              },            ),          ),        );      },    );  }}