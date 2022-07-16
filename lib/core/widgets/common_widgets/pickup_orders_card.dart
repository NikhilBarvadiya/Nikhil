// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_manager/controller/app_controller.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:get/get.dart';

class PickupOrdersCard extends StatefulWidget {
  final String? header;
  final String? time;
  final String? shopName;
  final String? personName;
  final Column? items;
  final String? number;
  final String? address;
  final String? otp;
  final String? note;
  final String? status;
  final String? amount;
  final String? amount1;
  final String? accpeted;
  final int? index;
  // final List? stopList;
  // final List? shopNameList;
  final dynamic itemList;
  final void Function()? textClick;
  final void Function()? editClick;
  final void Function()? itemClick;
  final void Function()? imagetrap;
  final dynamic callIcon;
  final dynamic imageShow;

  const PickupOrdersCard({
    Key? key,
    this.header,
    this.time,
    this.shopName,
    this.personName,
    this.textClick,
    this.callIcon,
    this.accpeted,
    this.number,
    this.address,
    this.otp,
    this.note,
    this.status,
    this.itemClick,
    this.editClick,
    this.amount,
    this.imageShow,
    this.imagetrap,
    this.amount1,
    this.itemList,
    this.index,
    this.items,
  }) : super(key: key);

  @override
  State<PickupOrdersCard> createState() => _PickupOrdersCardState();
}

class _PickupOrdersCardState extends State<PickupOrdersCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: AppController().appTheme.primary1),
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 35.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: widget.header == "Pickup"
                  ? Theme.of(context).primaryColor
                  : widget.header == "Drop"
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.2),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.header ?? '',
                      style: AppCss.h1.copyWith(
                        color: widget.header == "Pickup"
                            ? Colors.white
                            : widget.header == "Drop"
                                ? Colors.white
                                : AppController().appTheme.primary1,
                      ),
                    ).paddingOnly(right: 5),
                    Text(
                      widget.header == "Pickup"
                          ? ""
                          : widget.header == "Drop"
                              ? ""
                              : widget.index.toString(),
                      style: AppCss.h1.copyWith(
                        color: widget.header == "Pickup"
                            ? Colors.white
                            : widget.header == "Drop"
                                ? Colors.white
                                : AppController().appTheme.primary1,
                      ),
                    ),
                  ],
                ),
                if (widget.status != "Pending")
                  Card(
                    elevation: 1,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Colors.black,
                            size: 15,
                          ).paddingOnly(right: 2),
                          Text(
                            widget.time ?? '',
                            style: AppCss.body1.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.status != null && widget.status == "Pending")
                  Card(
                    elevation: 1,
                    color: Colors.blue,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.status ?? '',
                        style: AppCss.body1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ).paddingOnly(bottom: 5),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.shopName ?? '',
                    style: AppCss.h3.copyWith(color: Theme.of(context).primaryColor, fontSize: 15),
                  ).paddingOnly(right: 5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "OTP :",
                      style: AppCss.body1.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.otp ?? '',
                      style: AppCss.h3.copyWith(fontSize: 15),
                    ).paddingOnly(right: 5),
                  ],
                ),
              ],
            ),
          ).paddingOnly(bottom: 7),
          Row(
            children: [
              Text(
                widget.personName ?? '',
                style: AppCss.h3,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: GestureDetector(
                  onTap: widget.textClick,
                  child: Text(
                    widget.number ?? '',
                    style: AppCss.h3.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(left: 10, right: 10, bottom: 7),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.address ?? '',
                    style: AppCss.poppins.copyWith(fontSize: 15),
                  ).paddingOnly(bottom: widget.amount == null ? 5 : 7),
                ),
                TextButton(
                  onPressed: widget.itemClick,
                  child: Row(
                    children: [
                      Text(
                        "Item : ",
                        style: AppCss.h3.copyWith(
                          color: AppController().appTheme.primary1,
                        ),
                      ).paddingOnly(top: 2),
                      Text(
                        widget.itemList ?? "",
                        style: AppCss.h3.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ).paddingOnly(top: 2),
                    ],
                  ),
                ).paddingOnly(right: 5),
              ],
            ),
          ),
          if (widget.header != "Pickup")
            Container(
              child: widget.items,
            ),
          if (widget.imageShow != null)
            GestureDetector(
              onTap: widget.imagetrap,
              child: widget.imageShow,
            ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  widget.note ?? '',
                  style: AppCss.h3.copyWith(fontSize: 15),
                ).paddingOnly(right: 2),
                const Spacer(),
                if (widget.header != "Pickup" && widget.accpeted != "Accepted")
                  GestureDetector(
                    onTap: widget.editClick,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      padding: const EdgeInsets.only(top: 2, bottom: 4, left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.edit, size: 12, color: AppController().appTheme.primary1.withOpacity(0.5)),
                          Text(
                            "Edit",
                            style: AppCss.h3.copyWith(fontSize: 15, color: AppController().appTheme.primary1),
                          ).paddingOnly(top: 4, left: 4),
                        ],
                      ),
                    ),
                  ).paddingOnly(bottom: 5),
              ],
            ),
          ).paddingOnly(bottom: widget.header != "Pickup" ? 0 : 5),
        ],
      ),
    ).paddingAll(8);
  }
}
