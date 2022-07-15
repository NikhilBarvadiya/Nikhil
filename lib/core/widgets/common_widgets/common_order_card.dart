import 'package:flutter/material.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:get/get.dart';

class CommonOrderCard extends StatefulWidget {
  final String? orderNumber;
  final String? customerName;
  final String? customerNumber;
  final String? pickupStop;
  final String? amount;
  final String? amountType;
  final String? status;
  final String? requestedVehicle;
  final Color? cardColors;
  final dynamic margin;
  final dynamic image;
  final dynamic textClick;

  const CommonOrderCard({
    Key? key,
    this.orderNumber,
    this.customerName,
    this.customerNumber,
    this.pickupStop,
    this.amount,
    this.requestedVehicle,
    this.cardColors,
    this.margin,
    this.status,
    this.image,
    this.textClick,
    this.amountType,
  }) : super(key: key);

  @override
  State<CommonOrderCard> createState() => _CommonOrderCardState();
}

class _CommonOrderCardState extends State<CommonOrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        side: BorderSide(
          color: Colors.blue.shade400,
          width: 1,
        ),
      ),
      color: widget.cardColors ?? Colors.white,
      margin: widget.margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.orderNumber ?? '',
                  style: AppCss.h1,
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.amountType} ${widget.amount}",
                      style: AppCss.h3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.person,
                  size: 20,
                ).paddingOnly(right: 5),
                Text(
                  widget.customerName ?? '',
                  style: AppCss.h3.copyWith(color: Colors.black),
                ).paddingOnly(right: 10),
                Text(
                  widget.customerNumber ?? '',
                  style: AppCss.body1.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 5, bottom: widget.status != "Accepted" && widget.status != "Completed" ? 5 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.green.shade300,
                ).paddingOnly(right: 5),
                Text(
                  'Status',
                  style: AppCss.h3.copyWith(color: Colors.black),
                ).paddingOnly(right: 10),
                Text(
                  widget.status ?? '',
                  style: AppCss.body1.copyWith(color: Colors.black),
                ),
                if (widget.status != "Accepted" && widget.status != "Completed" && widget.status != "Cancelled") const Spacer(),
                if (widget.status != "Accepted" && widget.status != "Completed" && widget.status != "Cancelled")
                  Text(
                    widget.pickupStop ?? '',
                    style: AppCss.h3,
                  ).paddingOnly(right: 8),
              ],
            ),
          ),
          if (widget.status != "Pending")
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.textClick,
                    icon: Image.asset(
                      widget.image,
                      scale: 12,
                    ),
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 50 / 100,
                      child: Text(
                        widget.requestedVehicle ?? '',
                        style: AppCss.h3.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.pickupStop ?? '',
                    style: AppCss.h3,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
