// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:get/get_utils/get_utils.dart';

class CommonCodDriverCard extends StatefulWidget {
  final String? orderNo;
  final String? addressDate;
  final String? codAmount;
  final String? cashReceive;
  final String? diffAmount;
  final String? allottedDrivers;
  final Color? cardColors;
  void Function()? onTap;

  CommonCodDriverCard({
    Key? key,
    this.orderNo,
    this.addressDate,
    this.cardColors,
    this.codAmount,
    this.diffAmount,
    this.allottedDrivers,
    this.cashReceive,
    this.onTap,
  }) : super(key: key);

  @override
  State<CommonCodDriverCard> createState() => _CommonCodDriverCardState();
}

class _CommonCodDriverCardState extends State<CommonCodDriverCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Card(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.orderNo ?? '',
                        style: AppCss.h2,
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Locations : ",
                                style: AppCss.body3.copyWith(color: Colors.black),
                              ),
                              Text(
                                widget.allottedDrivers ?? '',
                                style: AppCss.h3.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'COD AMT',
                            style: AppCss.h3.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.codAmount ?? '',
                            style: AppCss.h3.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'AMT REC',
                            style: AppCss.h3.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.cashReceive ?? '',
                            style: AppCss.h3.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'DIFF AMT',
                            style: AppCss.h3.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.diffAmount ?? '',
                            style: AppCss.h3.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).paddingOnly(top: 8),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              widget.addressDate ?? '',
              style: AppCss.caption,
            ),
          ).paddingOnly(right: 5),
        ],
      ),
    );
  }
}
