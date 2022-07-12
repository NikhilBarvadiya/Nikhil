import 'package:fw_manager/core/assets/index.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:fw_manager/core/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:fw_manager/core/widgets/common_widgets/common_order_card.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderList extends StatelessWidget {
  final dynamic data;
  final VoidCallback? moreOrder;

  const OrderList({Key? key, this.data, this.moreOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(appScreenUtil.size(15), appScreenUtil.size(10), appScreenUtil.size(15), appScreenUtil.size(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              data["_id"].toString(),
              style: AppCss.h3.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: moreOrder,
              child: CommonOrderCard(
                orderNumber: data["orderNo"],
                customerName: data["customerName"],
                customerNumber: data["customerNumber"],
                pickupStop: data["pickupStop"],
                amount: data["amount"],
                amountType: data["amountType"],
                status: data["status"],
                requestedVehicle: data["requestedVehicle"],
                image: imageAssets.bike,
                textClick: () async {
                  String link = "tel:${data["customerName"]}";
                  // ignore: deprecated_member_use
                  await launch(link);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
