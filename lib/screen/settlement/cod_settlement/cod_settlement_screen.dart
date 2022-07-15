import 'package:flutter/material.dart';
import 'package:fw_manager/controller/cod_settlement_controller.dart';
import 'package:get/get.dart';

class CodSettlementScreen extends StatefulWidget {
  const CodSettlementScreen({Key? key}) : super(key: key);

  @override
  State<CodSettlementScreen> createState() => _CodSettlementScreenState();
}

class _CodSettlementScreenState extends State<CodSettlementScreen> {
  CodSettlementController codSettlementController = Get.put(CodSettlementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodSettlementController>(
      builder: (_) => Column(
        children: const [],
      ),
    );
  }
}
