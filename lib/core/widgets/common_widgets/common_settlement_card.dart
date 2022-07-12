// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class CommonSettlementCard extends StatefulWidget {
  final String? personName;
  final String? name;
  final String? place;
  final String? dateTime;
  dynamic onTap;
  dynamic borderColor;

  CommonSettlementCard({
    Key? key,
    this.personName,
    this.name,
    this.place,
    this.dateTime,
    this.onTap,
    this.borderColor,
  }) : super(key: key);

  @override
  State<CommonSettlementCard> createState() => _CommonSettlementCardState();
}

class _CommonSettlementCardState extends State<CommonSettlementCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(2),
              ),
              side: BorderSide(
                color: Colors.blue.shade400,
                width: 1,
              ),
            ),
            color: widget.borderColor ?? Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name ?? '',
                          style: AppCss.h3,
                        ),
                      ),
                      Text(
                        widget.personName ?? '',
                        style: AppCss.body3,
                      ),
                    ],
                  ).paddingOnly(bottom: 5),
                  if (widget.place != null)
                    Text(
                      widget.place ?? '',
                      style: AppCss.body2,
                    ),
                ],
              ),
            ),
          ).paddingOnly(top: widget.dateTime != "" ? 8 : 0),
        ),
        if (widget.dateTime != "")
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              widget.dateTime ?? '',
              style: AppCss.caption,
            ),
          ).paddingOnly(right: 5),
      ],
    );
  }
}
