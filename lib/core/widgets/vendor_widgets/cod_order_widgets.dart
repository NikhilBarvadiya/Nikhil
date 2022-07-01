// // ignore_for_file: unused_field, prefer_final_fields

// import 'package:flutter/material.dart';
// import 'package:fw_manager/controller/common_controller.dart';
// import 'package:fw_manager/controller/vender_settlement_controller.dart';
// import 'package:fw_manager/core/theme/app_css.dart';
// import 'package:fw_manager/core/widgets/common_bottom_sheet/common_bottom_sheet.dart';
// import 'package:fw_manager/core/widgets/common_widgets/common_settlement_card.dart';
// import 'package:fw_manager/core/widgets/common_widgets/searchable_list.dart';
// import 'package:get/get.dart';

// class CodOrderWidgets extends StatefulWidget {
//   const CodOrderWidgets({Key? key}) : super(key: key);

//   @override
//   State<CodOrderWidgets> createState() => _CodOrderWidgetsState();
// }

// class _CodOrderWidgetsState extends State<CodOrderWidgets> {
//   VendorSettlementController vendorSettlementController = Get.put(VendorSettlementController());
//   CommonController _commonController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<VendorSettlementController>(
//       builder: (_) => Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               commonBottomSheet(
//                 context: context,
//                 widget: SearchableListView(
//                   isLive: false,
//                   isOnSearch: true,
//                   itemList: const [],
//                   bindText: 'name',
//                   bindValue: '_id',
//                   labelText: 'Vendor category',
//                   hintText: 'Please Select',
//                   onSelect: (val, text) {
//                     Navigator.pop(context);
//                   },
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: Border(
//                   bottom: BorderSide(
//                     color: Theme.of(context).primaryColor,
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Vendor category",
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Expanded(
//                         child: Text('Please Select'),
//                       ),
//                       Icon(
//                         Icons.arrow_drop_down,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     commonBottomSheet(
//                       context: context,
//                       widget: SearchableListView(
//                         isLive: false,
//                         isOnSearch: true,
//                         itemList: const [],
//                         bindText: 'name',
//                         bindValue: '_id',
//                         labelText: 'Order Search',
//                         hintText: 'Please Select',
//                         onSelect: (val, text) {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       border: Border(
//                         bottom: BorderSide(
//                           color: Theme.of(context).primaryColor,
//                           width: 1.0,
//                         ),
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Expanded(
//                           child: Text('Search order'),
//                         ),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               GestureDetector(
//                 onTap: () => vendorSettlementController.onDatePickerCod(),
//                 child: Card(
//                   elevation: 1,
//                   color: Theme.of(context).primaryColor,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 100),
//                     alignment: Alignment.center,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: const Icon(
//                         Icons.filter_alt_outlined,
//                         size: 25,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           if (vendorSettlementController.startDateCodOrder != "" &&
//               vendorSettlementController.endDateCodOrder != "" &&
//               vendorSettlementController.codOrderFilter != false)
//             Container(
//               padding: const EdgeInsets.only(left: 5),
//               width: double.infinity,
//               alignment: Alignment.topLeft,
//               child: Text(
//                 "${vendorSettlementController.startDateCodOrder.split("T").first} "
//                 "- ${vendorSettlementController.endDateCodOrder.split("T").first}",
//                 style: AppCss.h3,
//               ),
//             ),
//           const SizedBox(height: 15),
//           Expanded(
//             child: ListView(
//               children: [
//                 ...vendorSettlementController.codLocation.map(
//                   (e) {
//                     return CommonSettlementCard(
//                       orderNo: e["orderNo"],
//                       id: e["id"],
//                       place: e["place"],
//                       dateTime: e["dateTime"],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
