import 'package:flutter/material.dart';
import 'package:fw_manager/core/theme/index.dart';
import 'package:get/get.dart';

class NewOrderCard extends StatefulWidget {
  final String? addressHeder;
  final String? personName;
  final String? address;
  final String? vendorName;
  final Color? cardColors;
  final Color? deleteIconColor;
  final bool? icon;
  final IconData? deleteIcon;
  final void Function()? onTap;

  const NewOrderCard({
    Key? key,
    this.addressHeder,
    this.personName,
    this.address,
    this.vendorName,
    this.onTap,
    this.cardColors,
    this.deleteIcon,
    this.deleteIconColor,
    this.icon,
  }) : super(key: key);

  @override
  State<NewOrderCard> createState() => _NewOrderCardState();
}

class _NewOrderCardState extends State<NewOrderCard> {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.addressHeder ?? '',
                    style: AppCss.h3.copyWith(color: Theme.of(context).primaryColor, fontSize: 15),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.deleteIconColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      widget.deleteIcon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.personName ?? '',
              style: AppCss.h3,
            ).paddingOnly(bottom: 5, top: 4),
            Text(
              widget.address ?? '',
              style: AppCss.body3,
            ).paddingOnly(bottom: 5),
            RichText(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.end,
              textDirection: TextDirection.rtl,
              softWrap: true,
              maxLines: 1,
              textScaleFactor: 1,
              text: TextSpan(
                text: 'Vendor : ',
                style: AppCss.h3.copyWith(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.vendorName ?? '',
                    style: AppCss.h3.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
