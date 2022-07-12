import 'package:flutter/material.dart';
import 'package:fw_manager/core/theme/app_css.dart';
import 'package:get/get.dart';

class CommonCodVendorDataCard extends StatefulWidget {
  final String? orderNo;
  final String? personName;
  final String? name;
  final String? addressDate;
  final String? status;
  final String? codAmount;
  final String? cashReceive;
  final String? diffAmount;
  final String? allottedDrivers;
  final Color? cardColors;

  const CommonCodVendorDataCard({
    Key? key,
    this.orderNo,
    this.personName,
    this.addressDate,
    this.cardColors,
    this.status,
    this.codAmount,
    this.cashReceive,
    this.diffAmount,
    this.allottedDrivers,
    this.name,
  }) : super(key: key);

  @override
  State<CommonCodVendorDataCard> createState() => _CommonCodVendorDataCardState();
}

class _CommonCodVendorDataCardState extends State<CommonCodVendorDataCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.name ?? "",
                        style: AppCss.h2,
                      ),
                    ),
                    Text(
                      widget.personName ?? '',
                      style: AppCss.h3,
                    ).paddingOnly(top: 2),
                  ],
                ).paddingOnly(bottom: 7),
                Row(
                  children: [
                    Text(
                      "Order No : ",
                      style: AppCss.h3,
                    ),
                    Text(
                      widget.orderNo ?? '',
                      style: AppCss.h3,
                    ),
                    const Spacer(),
                    Text(
                      "Status : ",
                      style: AppCss.h3.copyWith(color: Colors.black),
                    ),
                    Text(
                      widget.status ?? '',
                      style: AppCss.h3.copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Allotted Driver :",
                      style: AppCss.h3.copyWith(color: Colors.black),
                    ).paddingOnly(right: 5),
                    Text(
                      widget.allottedDrivers ?? '',
                      style: AppCss.body2.copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
        ).paddingOnly(right: 5)
      ],
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

String getFormattedDate(String dtStr) {
  var dt = DateTime.parse(dtStr);

  return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
}
