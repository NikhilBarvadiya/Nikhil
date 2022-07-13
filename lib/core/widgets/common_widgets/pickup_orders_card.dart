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
  final String? number;
  final String? address;
  final String? otp;
  final String? note;
  final String? status;
  final String? amount;
  final String? amount1;
  final List? stopList;
  final List? shopNameList;
  final dynamic itemList;
  final void Function()? textClick;
  final void Function()? editClick;
  final void Function()? itemClick;
  final void Function()? imagetrap;
  final dynamic callIcon;
  final dynamic image;

  const PickupOrdersCard({
    Key? key,
    this.header,
    this.time,
    this.shopName,
    this.personName,
    this.textClick,
    this.callIcon,
    this.number,
    this.address,
    this.otp,
    this.note,
    this.status,
    this.itemClick,
    this.editClick,
    this.stopList,
    this.shopNameList,
    this.amount,
    this.image,
    this.imagetrap,
    this.amount1,
    this.itemList,
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
                Card(
                  elevation: 1,
                  color: widget.status == "Pending"
                      ? Colors.deepOrangeAccent
                      : widget.status == "Running"
                          ? Colors.blue
                          : widget.status == "Complete"
                              ? Colors.green
                              : widget.status == "Cancelled"
                                  ? Colors.red
                                  : Colors.transparent,
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
          ).paddingOnly(bottom: 5),
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
              GestureDetector(
                onTap: widget.imagetrap,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                    color: Colors.blue,
                  ),
                  child: Image.asset(
                    widget.image ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ).paddingOnly(left: 10, right: 10, bottom: 5),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.address ?? '',
                    style: AppCss.h3.copyWith(fontSize: 15),
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
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    "Cash :",
                    style: AppCss.h3,
                  ),
                  Text(
                    widget.amount ?? "",
                    style: AppCss.h3.copyWith(color: widget.amount == widget.amount1 ? Colors.green : Colors.red),
                  ).paddingOnly(left: 15),
                  Text(
                    widget.amount1 ?? "",
                    style: AppCss.h3.copyWith(color: widget.amount1 == widget.amount ? Colors.green : Colors.red),
                  ).paddingOnly(left: 15),
                ],
              ).paddingOnly(bottom: 5),
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
                if (widget.header != "Pickup")
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
          for (int i = 1; i < widget.stopList!.length - 1; i++)
            widget.header == "Pickup"
                ? Container(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          widget.stopList![i] == "Pickup"
                              ? ""
                              : widget.stopList![i] == "Drop"
                                  ? ""
                                  : widget.stopList![i] ?? '',
                          style: AppCss.h3.copyWith(fontSize: 15),
                        ).paddingOnly(right: 5),
                        Text(
                          widget.stopList![i] == "Pickup"
                              ? ""
                              : widget.stopList![i] == "Drop"
                                  ? ""
                                  : widget.shopNameList![i] ?? '',
                          style: AppCss.h3.copyWith(fontSize: 15, color: Colors.blue),
                        ),
                      ],
                    ),
                  )
                : Container(),
        ],
      ),
    ).paddingAll(8);
  }
}
